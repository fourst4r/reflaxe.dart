package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;

class CompositeClassFilter implements IClassFilter {
    var _filters:Array<IClassFilter>;

    public function new(filters) {
        _filters = filters;
    }

    public function filterClass(cls:ClassDef):ClassDef {
        for (f in _filters) {
            cls = f.filterClass(cls);
        }
        return cls;
    }
}

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

class CompositeAbstractFilter implements IAbstractFilter {
    var _filters:Array<IAbstractFilter>;

    public function new(filters)
        _filters = filters;

    public function filterAbstract(abs:AbstractDef):AbstractDef {
        for (f in _filters) {
            abs = f.filterAbstract(abs);
        }
        return abs;
    }
}

#end