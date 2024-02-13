package dartcompiler.filters;

#if (macro || dart_runtime)

interface IClassFilter {
    function filterClass(cls:ClassDef):ClassDef;
}

#end