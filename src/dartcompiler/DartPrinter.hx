package dartcompiler;

// Make sure this code only exists at compile-time.
#if (macro || dart_runtime)

import reflaxe.data.*;
import haxe.macro.Type;
import haxe.macro.Expr;

using reflaxe.helpers.NameMetaHelper;
using reflaxe.helpers.TypedExprHelper;
using reflaxe.helpers.ModuleTypeHelper;
using reflaxe.helpers.TypeHelper;
using Lambda;

class DartPrinter extends Printer {
    var _compiler:dartcompiler.Compiler;

    public function new(compiler, indent, newline) {
        super(indent, newline);
        _compiler = compiler;
    }

    public function printClass(classType: ClassType, varFields: Array<ClassVarData>, funcFields: Array<ClassFuncData>) {
        final className = classType.qualifiedName();
        final superClass = classType.superClass;
        
        if (classType.isInterface)
            write('abstract ');
        write('class $className');
        if (classType.params.length > 0) {
            write('<');
            list(classType.params, p -> {
                write(p.name);
            }, ', ');
            write('>');
        }

        if (superClass != null) {
            write(' extends ');
            write(superClass.t.get().qualifiedName());
            printTypeParams(superClass.params);
        }

        writeln(' {');
        indent();
        for (field in varFields)
            printField(field);
        for (func in funcFields)
            printFunction(func);
        unindent();
        writeln('}');
    }

    function printTypeParams(params:Array<Type>) {
        if (params.length == 0)
            return;
        write('<');
        list(params, printPNameOrType, ', ');
        write('>');
    }

    public function printType(type:Type, qualified:Bool = true, once:Bool = false) {
        // Handle nullables
        if (type.isNull()) {
            printPNameOrType(type = type.unwrapNull());
            if (!type.isDynamic())
                write("?");
            return;
        }

        if (_compiler.compileNativeTypeCodeMeta(type) != null)
            return;

        switch (type) {
            case TEnum(_.get() => t, params): 
                // write('/*tenum*/');
                write(t.qualifiedName());
                printTypeParams(params);
            case TInst(_.get() => t, params):
                // write('/*tinst*/');
                write(t.qualifiedName());
                printTypeParams(params);
            case TAbstract(_.get() => t = {name:"EnumValue", pack:[]}, _):
                write('$$HxEnum');
            case TAbstract(_.get() => t = {name:"Class"|"Enum", pack:[]}, params):
                write('Type');
            case TAbstract(_.get() => t, params):
                // write('/*tabstract*/');
                // trace(type);
                // if (!once)
                //     printType(t.type.getUnderlyingType(), qualified, true);
                // else {
                    write(t.qualifiedName());
                    printTypeParams(params);
                // }
            case TDynamic(t): write('dynamic');
            case TType(_.get() => t, params):
                if (t.type.isAnonStruct()) {
                    // so that $HxAnon field accesses work
                    write('dynamic');
                } else {
                    // write('/*ttype*/');
                    write(t.qualifiedName());
                    printTypeParams(params);
                }
            case TAnonymous(_.get() => a):
                // write('/*tanon*/');
                switch (a.status) {
                    case AClassStatics(_):
                        write('/* unhandled aclassstatics*/');
                    default:
                        write('dynamic');
                }
            case TFun(args, ret):
                printPNameOrType(ret);
                write(' Function(');
                list(args, a -> {
                    printPNameOrType(a.t);
                    if (a.opt)
                        write('?');
                    if (a.name.length > 0)
                        write(' ${a.name}');
                }, ', ');
                write(')');
            // case TMono(_.get() => t):
            //     if (t != null) {
            //         final real = Context.follow(t);
            //         write('/*tmono*/'+Std.string(real));
            //     } else {
            //         write('/*tmono*/');
            //     }
            default:
                write('dynamic/*mono*/');
                trace("unable to print type: "+type);
        }
    }

    public function printTypedef(def:DefType) {
        if (def.type.isAnonStruct())
            // anon structs are dynamic in order for $HxAnon to work, so no need to gen
            return;

        final name = def.qualifiedName();
        write('typedef $name');
        if (def.params.length > 0) {
            write('<');
            list(def.params, p -> {
                write(p.name);
            }, ', ');
            write('>');
        }
        write(' = ');
        // switch (def.type) {
        //     case TAnonymous(_): write('$HX_ANON as dynamic');
        //     default:
        // }
        // write('dynamic');
        printType(def.type);
        write(';');
    }

    public function printField(varField: ClassVarData) {
        final type = varField.field.type;
        final expr = varField.field.expr() ?? varField.findDefaultExpr();
        final name = varField.field.name;
        
        if (varField.isStatic)
            write('static ');

        final lateInit = !type.isNull() && expr == null;
        if (lateInit)
            write('late ');

        printType(type);
        
        write(' $name');

        if (expr != null) {
            write(' = ');
            _compiler.compileExpression(expr);
        }
        
        writeln(';');
    }

    public function printFunction(funcField: ClassFuncData) {
        final isConstructor = funcField.field.name == "new";
        final isDummyCtor = funcField.field.hasMeta(Meta.DummyCtor);
        final isLateCtor = funcField.field.hasMeta(Meta.LateCtor);
        final ret = funcField.ret;
        final className = funcField.classType.qualifiedName();
        final fieldName = funcField.field.getNameOrNativeName();
        final name = isConstructor ? className : fieldName;
        final args = funcField.args;
        final body = funcField.expr;
        final params = funcField.field.params;
        final initers = funcField.field.meta.extract(Meta.Initializer);
        final isOverride = funcField.classType.overrides.exists(f -> f.get().name == funcField.field.name);
        final hasOptional = args.exists(a -> a.opt);
        
        if (isDummyCtor) {
            writeln('$className.$fieldName();');
            return;
        }

        if (isOverride)
            write('@override ');

        if (funcField.isStatic)
            write('static ');

        if (!isConstructor) {
            printPNameOrType(ret);
            write(' ');
        }
        
        write(name);

        if (params.length > 0) {
            write('<');
            list(params, p -> {
                write(p.name);
            }, ', ');
            write('>');
        }

        write('(');
        var hasOpt = false;
        list(args, a -> {
            if (a.opt && !hasOpt) {
                hasOpt = true;
                write('[');
            }
            printPNameOrType(a.type);
            write(' ${a.name}');
            if (a.expr != null) {
                write('=');
                _compiler.compileExpression(a.expr);
            }
        }, ', ');
        if (hasOpt) write(']');
        write(') ');

        if (initers.length > 0) {
            write(': ');
            list(initers, m -> {
                final e = m?.params.first();
                if (e != null) {
                    write(e.toString());
                }
            }, ', ');
            write(' ');
        }
        
        printFuncBody(body);
        newline();
    }

    function list<T>(el:Array<T>, fn:T->Void, sep:String) {
        if (el.length == 0)
            return;
        fn(el[0]);
        for (i in 1...el.length) {
            write(sep);
            fn(el[i]);
        }
    }

    public function printAbstract(abstractType:AbstractType) {
        if (abstractType.isExtern) {
            return;
        }

        final className = abstractType.qualifiedName();
        writeln('// meta=${abstractType.meta.get()}');
        write('class $className');
        if (abstractType.params.length > 0) {
            write('<');
            list(abstractType.params, p -> {
                write(p.name);
            }, ', ');
            write('>');
        }

        writeln(' {');
        indent();
        // for (field in varFields)
        //     printField(field);
        // for (func in funcFields)
        //     printFunction(func);
        unindent();
        writeln('}');
    }

    public function printEnum(enumType: EnumType, constructs: Array<EnumOptionData>) {
        final isADT = constructs.exists(c -> c.args.length > 0);
        if (isADT)
            printEnumADT(enumType, constructs);
        else
            printEnumSimple(enumType, constructs);

        writeln();
    }

    public function printEnumSimple(enumType: EnumType, constructs: Array<EnumOptionData>) {
        final enumName = enumType.qualifiedName();
        writeln('enum ${enumName} {');
        indent();

        for (con in constructs) {
            final fname = con.field.name;
            write('$fname,');
        }

        unindent();
        writeln();
        writeln('}');
    }

    public function printEnumADT(enumType: EnumType, constructs: Array<EnumOptionData>) {
        // more information here: https://dart.dev/language/class-modifiers#sealed

        final enumName = enumType.qualifiedName();
        writeln('sealed class ${enumName} extends $$HxEnum {');
        indent();
        writeln('$enumName(super.index);');
        unindent();
        writeln('}');

        for (con in constructs) {
            final fname = con.field.name;
            final index = con.field.index;
            final conName = '${enumName}_$fname';
            writeln('class $conName extends $enumName {');
            indent();
            for (arg in con.args) {
                printType(arg.type);
                writeln(' ${arg.name};');
            }
            write('$conName(');
            list(con.args, arg -> {
                write('this.${arg.name}');
            }, ', ');
            writeln(') : super($index);');
            unindent();
            writeln('}');
        }

        writeln();
    }

    public function printBlock(el:Array<TypedExpr>) {
        if (el.length > 0) {
            _compiler.compileExpression(el[0]);
            printTerm(el[0]);
            
            for (i in 1...el.length) {
                writeln();
                _compiler.compileExpression(el[i]);
                printTerm(el[i]);
            }
        }
    }

    function printTerm(e) switch (e.expr) {
        case TBlock(_)|TWhile(_,_,_)|TIf(_,_,_)|TTry(_,_): /* no terminator */
        default: write(';');
    }

    function toLiteral(c:TConstant) return switch (c) {
        case TNull: 'null';
        case TBool(b): b ? 'true' : 'false';
        case TInt(i): Std.string(i);
        case TFloat(s): s.endsWith('.') ? s+'0' : s;
        case TString(s): {
            s = StringTools.replace(s, '\n', '\\n');
            s = StringTools.replace(s, '\r', '\\r');
            s = StringTools.replace(s, "'", "\\'");
            s = StringTools.replace(s, '"', '\\"');
            s = StringTools.replace(s, "$", "\\$");
            '\'$s\'';
        }
        case TThis: 'this';
        case TSuper: 'super';
    } 

    function printPNameOrType(t:Type) {
        final pname = t.getTypeParameterName();
        if (pname != null)
            write(pname);
        else
            printType(t);
    }

    public function printExpr(expr: TypedExpr, topLevel: Bool) {
        final cx = _compiler.compileExpression.bind(_, topLevel);

        switch (expr.expr) {
            case TConst(toLiteral(_) => s): write(s);
            case TLocal(v): 
                write(_compiler.compileVarName(v.name));
            case TArray(e1, e2): 
                _compiler.compileExpression(e1);
                write('[');
                _compiler.compileExpression(e2);
                write(']');
            case TBinop(op, e1, e2):
                printBinop(op, e1, e2);
            case TField(e, FStatic(_.get() => c,cf)):

                final cf = cf.get();
                final fname = cf.getNameOrNative();
                if (cf.hasMeta(":native")) {
                    write(fname);
                } else {
                    // TODO: figure out why this works for Class<T>, but compileExpression does not...
                    write(c.qualifiedName());
                    // _compiler.compileExpression(e);
                    write('.${cf.name}');
                }
            case TField(e, FInstance(_,_,cf)|FClosure(_,cf)): 

                final cf = cf.get();
                final fname = cf.getNameOrNative();
                if (cf.hasMeta(":native")) {
                    write(fname);
                } else {
                    _compiler.compileExpression(e);
                    if (e.t.isNull())
                        write('!');
                    write('.${cf.getNameOrNativeName()}');
                }
            case TField(e, FAnon(_.get() => cf)):
                
                final fname = cf.getNameOrNative();
                if (cf.hasMeta(":native")) {
                    write(fname);
                } else {
                    _compiler.compileExpression(e);
                    if (e.t.isNull())
                        write('!');
                    write('.${cf.getNameOrNativeName()}');
                }

            case TField(e, FDynamic(s)):
                
                _compiler.compileExpression(e);
                write('.' + s);
            case TField(e, FEnum(_.get() => en, ef)):
                _compiler.compileExpression(e);
                
                if (en.isSumType()) {
                    // if there are no constructor args it gets compiled as TEnum instead of TFun, 
                    // so we add empty parens to make up for it
                    final noArgs = ef.type.match(TEnum(_,_));

                    write('_${ef.name}');
                    if (noArgs)
                        write('()');
                } else {
                    write('.${ef.name}');
                }
                
            case TTypeExpr(m):
                final type = m.fromModuleType();

                if (_compiler.compileNativeTypeCodeMeta(type) != null) {
                    write('/*nativecode*/');
                    return;
                }
                
                if (m.getCommonData().hasMeta(Meta.Native)) {
                    write(m.getNameOrNative());
                } else {
                    write(m.getCommonData().qualifiedName());
                }
            case TObjectDecl(fields):
                final nullableFields = switch (expr.t) {
                    case TAnonymous(_.get() => a):
                        a.fields.filter(f -> {
                            return f.type.isNull();
                        });
                    default:
                        null;
                }
                write('$$HxAnon({');
                list(fields, f -> {
                    
                    final found = nullableFields.find(nf -> nf.name == f.name);
                    if (found != null)
                        nullableFields.remove(found);

                    // we do this because this is the format of Invocation.memberName.toString()
                    // for the $HxAnon.noSuchMethod() impl... is there a better way?
                    write('\'Symbol("${f.name}")\'');
                    write(':');
                    _compiler.compileExpression(f.expr);
                }, ', ');

                if (nullableFields.length > 0) {
                    write(', ');
                    list(nullableFields, f -> {
                        write('\'${f.name}\':null');
                    }, ', ');
                }

                write('}) as dynamic');
            case TArrayDecl(el):
                write('Array.fromList([');
                list(el, _compiler.compileExpression.bind(_, topLevel), ', ');
                write('])');
            case TCall(e, el):
                final nfc = _compiler.compileNativeFunctionCodeMeta(e, el);
                if (nfc != null) {
                    write(nfc);
                } else {
                    _compiler.compileExpression(e);

                    // TODO: do this properly
                    final params = e.getFunctionTypeParams() ?? [];
                    if (!params.exists(t -> t.match(TMono(_)))) {
                        printTypeParams(params);
                    }
                    
                    if (e.t.isNull())
                        write('!');

                    final expectedArgTypes = e.getClassField(true)?.type?.getTFunArgs();
                    var n = 0;
                    write('(');
                    list(el, e -> {
                        _compiler.compileExpression(e);
                        if (e.t.isNull() && !e.isNullExpr() && expectedArgTypes != null && !expectedArgTypes[n].t.isNull())
                            write('!');
                        n++;
                    }, ', ');
                    write(')');
                }
            case TNew(_.get() => c, params, el):

                final result = _compiler.compileNativeFunctionCodeMeta(expr, el);
                if (result != null) {
                    write(result);
                    return;
                }

                final cons = c.constructor.get();
                final fname = cons.getNameOrNative();
                if (cons.hasMeta(":native")) {
                    final result = cons.meta.extractParamsFromFirstMeta(":native");
                    write(cons.getNameOrNative());
                } else {
                    write(c.qualifiedName());
                    // printTypeParams(c.params.map(p -> p.t));
                    write('(');
                    list(el, cx, ', ');
                    write(')');
                }

            case TUnop(op, postFix, e): switch (op) {
                case OpNot: 
                    write('!');
                    _compiler.compileExpression(e);
                case OpNeg: 
                    write('-');
                    _compiler.compileExpression(e);
                case OpNegBits: 
                    write('~');
                    _compiler.compileExpression(e);
                case OpSpread: 
                    write('...');
                case OpIncrement:
                    if (postFix) {
                        _compiler.compileExpression(e);
                        write('++');
                    } else {
                        write('++');
                        _compiler.compileExpression(e);
                    }
                case OpDecrement: 
                    if (postFix) {
                        _compiler.compileExpression(e);
                        write('--');
                    } else {
                        write('--');
                        _compiler.compileExpression(e);
                    }
            }
            case TFunction(tfunc):
                write('(');
                list(tfunc.args, printArg, ', ');
                writeln(') {');
                indent();
                _compiler.compileExpression(tfunc.expr);
                unindent();
                writeln();
                write('}');
            case TVar(v, expr):
                if (v.t.isMonomorph())
                    write('var');
                else
                    printPNameOrType(v.t);

                write(' ');
                write(_compiler.compileVarName(v.name));

                if (expr != null) {
                    write(' = ');
                    _compiler.compileExpression(expr);
                }
            case TParenthesis(e):
                write('(');
                _compiler.compileExpression(e);
                write(')');
            case TBlock(el):
                final hasDecl = el.exists(e -> e.expr.match(TVar(_,_)));
                if (hasDecl) {
                    writeln('{');
                    indent();
                    printBlock(el);
                    unindent();
                    writeln();
                    write('}');
                } else {
                    printBlock(el);
                }
            case TIf(econd, eif, eelse):
                write('if (');
                _compiler.compileExpression(econd.unwrapParenthesis());
                writeln(') {');
                indent();
                printBlock(eif.unwrapBlock());
                writeln();
                if (eelse != null) {
                    unindent();
                    writeln('} else {');
                    indent();
                    printBlock(eelse.unwrapBlock());
                    writeln();
                }
                unindent();
                write('}');
            case TWhile(econd, e, normalWhile):
                if (normalWhile) {
                    write('while (');
                    _compiler.compileExpression(econd.unwrapParenthesis());
                    writeln(') {');
                    indent();
                    printBlock(e.unwrapBlock());
                    writeln();
                    unindent();
                    write('}');
                } else {
                    writeln('do {');
                    indent();
                    printBlock(e.unwrapBlock());
                    unindent();
                    writeln();
                    write('} while (');
                    _compiler.compileExpression(econd);
                    write(');');
                }
            case TSwitch(e, cases, edef):
                printSwitch(e, cases, edef);
            case TTry(e, catches):
                write('try {');
                _compiler.compileExpression(e);
                writeln();
                write('}');
                for (c in catches) {
                    write(' catch (');
                    // cx(c.v.t);
                    writeln(' ${c.v.name}) {');
                    _compiler.compileExpression(c.expr);
                    write('}');
                }
                writeln();
            case TReturn(e): 
                write('return');
                if (e != null) {
                    write(' ');
                    _compiler.compileExpression(e);
                }
            case TBreak: write('break');
            case TContinue: write('continue');
            case TThrow(e): 
                write('throw ');
                _compiler.compileExpression(e);
            case TCast(e, m):
                if (m != null) {
                    write('(');
                    _compiler.compileExpression(e);
                    write(' as ');
                    printType(m.fromModuleType());
                    write(')');
                } else {
                    _compiler.compileExpression(e);
                }
            case TMeta(m, e1): _compiler.compileExpression(e1);
            case TEnumParameter(e1, ef, index): 
                write('(');
                _compiler.compileExpression(e1);
                write(' as ');
                final argName = switch (ef.type) {
                    case TFun(args,_): args[index].name;
                    default: throw "impossible";
                }
                printType(e1.t);
                write('_${ef.name}');
                write(').$argName');
            case TEnumIndex(e1):
                cx(e1);
                write('.index');
            case TIdent(s): 
                write(s);
            case e:
                trace('unhandled expr: '+e);
        }
    }

    function printBinop(op:Binop, e1:TypedExpr, e2:TypedExpr) {

        final assignOp = switch (op) {
            case OpAssignOp(o): 
                op = o;
                true;
            default: 
                false;
        }

        var opStr = switch (op) {
            case OpAssign: '=';
            case OpAdd: '+';
            case OpSub: '-';
            case OpMult: '*';
            case OpDiv: '/';
            case OpMod: '%';
            case OpLt: '<';
            case OpLte: '<=';
            case OpGt: '>';
            case OpGte: '>=';
            case OpEq: '==';
            case OpNotEq: '!=';
            case OpBoolAnd: '&&';
            case OpBoolOr: '||';
            case OpNullCoal: '??';
            case OpAnd: '&';
            case OpArrow: '=>';
            case OpIn: 'in';
            case OpInterval: '...';
            case OpOr: '|';
            case OpShl: '<<';
            case OpShr: '>>';
            case OpUShr: '>>>';
            case OpXor: '^';
            default: throw "impossible";
        }

        if (assignOp)
            opStr += '=';

        function printSafeString(e:TypedExpr) {
            _compiler.compileExpression(e);
            if (!e.t.isString())
                write('.toString()');
        }

        final bothAreStrings = e1.t.isString() && e2.t.isString();
        final shouldCoerceToString = e1.t.isString() != e2.t.isString();

        switch (op) {
            // lexicographic comparisons
            case OpGt|OpGte|OpLt|OpLte if (bothAreStrings):
                _compiler.compileExpression(e1);
                write('.compareTo(');
                _compiler.compileExpression(e2);
                write(') $opStr 0');
            case OpAdd if (shouldCoerceToString):
                printSafeString(e1);
                write(' $opStr ');
                printSafeString(e2);
            case OpAssignOp(OpAdd) if (shouldCoerceToString):
                _compiler.compileExpression(e1);
                write(' $opStr ');
                printSafeString(e2);
            default:
                _compiler.compileExpression(e1);
                write(' $opStr ');
                _compiler.compileExpression(e2);
        }
        
    }

    static function isRest(t:Type) {
        return switch (t) {
            case TAbstract(_.get() => { pack: ["haxe"], name: "Rest" }, params): true;
            default: false;
        }
    }

    function printFuncBody(expr:Null<TypedExpr>) {
        switch (expr?.expr) {
            case null: write(';');
            case TReturn(e): 
                write('=> ');
                _compiler.compileExpression(e);
            default:
                writeln('{');
                indent();
                printBlock(expr?.unwrapBlock());
                unindent();
                writeln();
                write('}');
        }
    }

    function printArg(arg:{v:TVar, value:Null<TypedExpr>}) {
        write(arg.v.name);
        if (isRest(arg.v.t))
            write('*');
    }

    public function printImport(uri:String, namespace:String) {
        writeln('import "$uri" as $namespace;');
    }

    function printSwitch(e:TypedExpr, cases:Array<{values:Array<TypedExpr>, expr:TypedExpr}>, edef:Null<TypedExpr>) {
        write('var __temp = ');
        _compiler.compileExpression(e.unwrapParenthesis());
        writeln(';');
        for (i in 0...cases.length) {
            final c = cases[i];
            final isFirst = (i == 0);
            write(isFirst ? 'if (' : '} else if (');
            list(c.values, v -> {
                write('__temp == ');
                _compiler.compileExpression(v);
            }, ' || ');
            writeln(') {');
            indent();
            printBlock(c.expr.unwrapBlock());
            unindent();
            writeln();
        }
        if (edef != null) {
            writeln('} else {');
            indent();
            printBlock(edef.unwrapBlock());
            unindent();
        }
        writeln();
        write('}');
    }

    public function printMain() {
        final main = _compiler.getMainExpr();
        if (main == null)
            return;
        writeln('void main() {');
        indent();
        _compiler.compileExpression(main, true);
        writeln(';');
        unindent();
        writeln('}');
    }

    public function printFooter() {
        writeln("class $HxAnon {
  Map<String, dynamic> $fields;

  $HxAnon(this.$fields);

  noSuchMethod(Invocation inv) {
    if (inv.isSetter) {
      print('setter '+inv.memberName.toString());
      $fields[inv.memberName.toString().replaceAll('=', '')] = inv.positionalArguments[0];
    } else if (inv.isGetter) {
      print('getter '+inv.memberName.toString());
      return $fields[inv.memberName.toString()];
    } else {
      super.noSuchMethod(inv);
    }
  }
}");
        writeln("sealed class $HxEnum {
    int index;
    $HxEnum(this.index);
}");
    }
}

#end