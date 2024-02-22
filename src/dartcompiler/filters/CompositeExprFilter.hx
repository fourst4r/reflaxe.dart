package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;

class CompositeExprFilter implements IExprFilter {
    var _filters:Array<IExprFilter>;

    public function new(filters) {
        _filters = filters;
    }

    public function filterExpr(e:TypedExpr):TypedExpr {
        for (f in _filters) {
            e = f.filterExpr(e);
        }
        return e;
    }
}

#end