package dartcompiler.filters;

#if (macro || dart_runtime)

import reflaxe.data.*;
import dartcompiler.builders.ClassFieldBuilder;
import haxe.macro.Expr;
import haxe.macro.Type;
import reflaxe.helpers.Context;

/**
    Applies Abstract type params to the implementation class methods.
**/
class AbstractParamsApplicator implements IAbstractFilter {
    public function new() {}

    static function findTypeParamsUsed(e:TypedExpr, module:String, pack:Array<String>) {
        final params:Map<String,Type> = [];
        function e_iter(ee:TypedExpr) {
            function t_iter(t:Type) {
                switch (t) {
                    case null: return;
                    case TInst(_.get() => {pack:p, module:m, name:n, kind:KTypeParameter(_)}, _):
                        if (module == m && pack.equalTo(p)) {
                            final id = t.getUniqueId();
                            if (!params.exists(id))
                                params.set(id, t);
                        } else 
                            trace('didnt match m=$m p=$p');
                    default:
                }
                t.iter(t_iter);
            }
            ee.t?.iter(t_iter);
            ee.iter(e_iter);
        }
        e.iter(e_iter);
        return params.array();
    }

    public function filterAbstract(abs:AbstractDef):AbstractDef {

        final params = abs.abstractType.params;
        if (params.length == 0)
            return abs;

        for (func in abs.classDef.funcFields) {
            final paramPack = abs.abstractType.pack.copy();
            paramPack.push(abs.abstractType.name);
            final paramTypes = findTypeParamsUsed(func.expr, abs.abstractType.module, paramPack);
            for (t in paramTypes) {
                func.field.params.push({
                    name: t.getTypeParameterName(),
                    t: t,
                });
            }
        }

        return abs;
    }
}

#end