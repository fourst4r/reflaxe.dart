package dartcompiler.filters;

#if (macro || dart_runtime)

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

#end