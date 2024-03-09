package dartcompiler.filters;

#if (macro || dart_runtime)

interface IAbstractFilter {
    function filterAbstract(abs:AbstractDef):AbstractDef;
}

#end