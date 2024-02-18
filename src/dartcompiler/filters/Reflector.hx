package dartcompiler.filters;

#if (macro || dart_runtime)

import reflaxe.data.*;
import dartcompiler.builders.ClassFieldBuilder;
import haxe.macro.Expr;
import haxe.macro.Type;
import reflaxe.helpers.Context;

/**
    Adds reflection info to a class.
**/
class Reflector implements IClassFilter {
    public function new() {}

    function isUnreflectable(v:ClassFuncData) {
        return v.field.hasMeta(Meta.DummyCtor)
            || v.field.hasMeta(Meta.LateCtor)
            || v.field.hasMeta(Meta.Native)
            || v.field.hasMeta(Meta.NativeName)
            || v.field.name == "new";
    }

    public function filterClass(cls:ClassDef):ClassDef {

        if (cls.classType.isExtern || cls.classType.isAbstract || cls.classType.isInterface)
            return cls;

        final allFields = cls.varFields
            .filter(f -> !f.isStatic)
            .map(f -> f.field.name);
        
        final superCls = cls.classType.superClass?.t.get();
        final pos = cls.classType.pos;

        cls.funcFields.push(
            new ClassFieldBuilder(FMethod(MethNormal))
                .named('__hx_getfield')
                .implemented(macro function(field:String):Dynamic {
                    $b{[
                        for (fname in allFields)
                            macro untyped if (field == $v{fname}) return $i{fname}
                    ]};
                    return ${superCls == null ? macro null : macro untyped __dart__("super.__hx_getfield({0})", field)};
                })
                .positioned(pos)
                .buildFunc(cls.classType)
        );

        cls.funcFields.push(
            new ClassFieldBuilder(FMethod(MethNormal))
                .named('__hx_setfield')
                .implemented(macro function(field:String, value:Dynamic):Dynamic {
                    $b{[
                        for (fname in allFields)
                            macro untyped if (field == $v{fname}) return $i{fname} = value
                    ]};
                    return ${superCls == null ? macro null : macro untyped __dart__("super.__hx_setfield({0}, {1})", field, value)};
                })
                .positioned(pos)
                .buildFunc(cls.classType)
        );

        cls.varFields.push(
            new ClassFieldBuilder(FVar(AccNormal, AccNever))
                .named('__hx_name')
                .implemented(macro $v{cls.classType.qualifiedName()})
                .statically()
                .positioned(pos)
                .buildVar(cls.classType)
        );

        return cls;
    }
}

#end