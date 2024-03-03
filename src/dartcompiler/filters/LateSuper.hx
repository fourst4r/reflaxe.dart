package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.TypedExprTools;
import haxe.macro.Expr;
import haxe.macro.Type;
import reflaxe.data.ClassFuncData;
import reflaxe.helpers.Context;

/**
    Transforms late `super()` calls for languages that don't support them.
**/
class LateSuper implements IClassFilter {
    public function new() {}

    static function ref<T>(o:T) {
        return {get: () -> o, toString: Std.string.bind(o)};
    }
    
    static final mk = TypedExprHelper.make.bind(_, TDynamic(null), null);

    static function isSuperCall(e:TypedExpr):Bool {
        return switch (e.expr) {
            case TCall({expr: TConst(TSuper)}, _): true;
            default: false;
        }
    }

    static function extractSuperExpr(e:TypedExpr):Null<TypedExpr> {
        var ret:Null<TypedExpr> = null;
        e.iter(ee -> {
            if (isSuperCall(ee))
                ret = ee;
        });
        return ret;
    }
    
    public function filterClass(cls:ClassDef):ClassDef {
        if (cls.classType.isExtern)
            return cls;

        final cons = cls.classType.constructor?.get();
        if (cons == null) return cls;

        final pos = cls.classType.pos;
        final hasSuperClass = cls.classType.superClass != null;
        final isSuperExtern = hasSuperClass && cls.classType.superClass.t.get().isExtern;
        final hasSubClass = true;

        var ctorBody = switch (cons.expr().expr) {
            case TFunction(tfunc): tfunc.expr;
            default: throw "impossible";
        }
        
        final meta = new MetaAccessor();
        meta.add(Meta.LateCtor, [], pos);
        final ctorField:ClassField = {
            name: '__hx_ctor_${cls.classType.name}',
            type: cons.type,
            pos: pos,
            params: [],
            overloads: null,
            meta: meta,
            kind: FMethod(MethNormal),
            isAbstract: false,
            isFinal: false,
            isExtern: false,
            isPublic: true,
            doc: null,
            expr: null,
        };

        if (hasSubClass) {
            // required for subclasses (unchecked)
            final superCtorField = Reflect.copy(ctorField);
            if (hasSuperClass)
                superCtorField.name = '__hx_ctor_${cls.classType.superClass.t.get().name}';
            
            function superToLateCtor(e:TypedExpr):TypedExpr {
                return switch (e.expr) {
                    case TCall({expr: TConst(TSuper)}, el): 
                        e.copy(TCall(mk(TField(mk(TConst(TSuper)), FInstance(cls.classType.superClass.t, [], ref(superCtorField)))), el));
                    default: 
                        e.map(superToLateCtor);
                }
            }

            final consField = cls.funcFields.find(f -> f.field.name == "new");
            final callArgs = consField.args.map(a -> mk(TIdent(a.name)));
            consField.setExpr(mk(TBlock([mk(TCall(mk(TField(mk(TConst(TThis)), FInstance(ref(cls.classType), [], ref(ctorField)))), callArgs))])));
            if (isSuperExtern) {
                final superExpr = Context.storeTypedExpr(extractSuperExpr(ctorBody));
                consField.field.meta.add(Meta.Initializer, [macro $superExpr], pos);
            } else if (hasSuperClass)
                consField.field.meta.add(Meta.Initializer, [macro super.__hx_dummyctor()], pos);
            
            final lateBody = hasSuperClass && !isSuperExtern ? ctorBody.map(superToLateCtor) : ctorBody;
            final lateCtor = new ClassFuncData(cls.classType, ctorField, false, MethNormal, Context.resolveType(macro:Void,pos), consField.args, null, lateBody);
            cls.funcFields.push(lateCtor);
        }

        if (hasSubClass) {
            // Dummy ctor
            final meta = new MetaAccessor();
            meta.add(Meta.DummyCtor, [], pos);
            if (hasSuperClass && !isSuperExtern)
                meta.add(Meta.Initializer, [macro super.__hx_dummyctor()], pos);
            final dummyCtor = new ClassFuncData(cls.classType, {
                name: "__hx_dummyctor",
                type: Context.resolveType(macro:()->Void, pos),
                pos: pos,
                params: [],
                overloads: null,
                meta: meta,
                kind: FMethod(MethNormal),
                isAbstract: false,
                isFinal: false,
                isExtern: false,
                isPublic: true,
                doc: null,
                expr: null,
            }, false, MethNormal, Context.resolveType(macro:Void,pos), [], null, null);
            cls.funcFields.push(dummyCtor);
        }

        return cls;
    }
}

#end