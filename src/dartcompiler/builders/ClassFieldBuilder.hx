package dartcompiler.builders;

#if (macro || dart_runtime)

import reflaxe.data.*;
import reflaxe.helpers.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

/**
    Helper class to make building class fields less painful.
**/
class ClassFieldBuilder {
    var _name:String;
    var _kind:FieldKind;
    var _pos:Position;
    var _isPublic:Bool;
    var _isStatic:Bool;
    var _cf:ClassField;
    var _fieldType:Type;
    var _texpr:TypedExpr;
    var _ret:Type;
    var _args:Array<ClassFuncArg>;

    public function new(kind:FieldKind) {
        _kind = kind;
        _isPublic = true;
    }

    public function named(name:String) {
        _name = name;
        return this;
    }
    
    public function positioned(pos:Position) {
        _pos = pos;
        return this;
    }
    
    public function privated() {
        _isPublic = false;
        return this;
    }

    public function statically() {
        _isStatic = true;
        return this;
    }

    public function implemented(e:Expr) {
        _texpr = Context.typeExpr(e);
        if (_kind.match(FMethod(_))) {
            switch (_texpr.expr) {
                case TFunction(tfunc):
                    _texpr = tfunc.expr;
                    _ret = tfunc.t;
                    _args = tfunc.args.mapi((i, a) -> new ClassFuncArg(i, a.v.t, a.value != null, a.v.name, a.v.meta, a.value, a.v));

                    _fieldType = TFun(tfunc.args.map(a -> {name: a.v.name, opt: a.value != null, t: a.v.t}), _ret);
                default: 
                    throw "expected function as implementation";
            }
        } else {
            _fieldType = _texpr.t;
        }
        return this;
    }

    public function build():ClassField {
        return {
            name: _name,
            type: _fieldType,
            kind: _kind,
            pos: _pos,
            expr: () -> _texpr,
            params: [],
            overloads: null,
            meta: new MetaAccessor(),
            isAbstract: false,
            isFinal: false,
            isExtern: false, 
            isPublic: _isPublic,
            doc: null,
        };
    }

    public function buildFunc(classType:ClassType) {
        final cf = build();
        final fkind = switch (cf.kind) {
            case FMethod(k): k;
            default: throw "not a function";
        }
        final fun = switch (cf.type) {
            case TFun(args, ret): {args: args.mapi((i, a) -> new ClassFuncArg(i, a.t, a.opt, a.name)), ret: ret};
            default: throw "not a function";
        }
        return new ClassFuncData(classType, cf, _isStatic, fkind, fun.ret, fun.args, null, cf.expr());
    }

    public function buildVar(classType:ClassType) {
        final cf = build();
        switch (cf.kind) {
            case FVar(read, write): 
                return new ClassVarData(classType, cf, _isStatic, read, write);
            default: 
                throw "not a function";
        }
    }
}

#end