package dartcompiler.filters;

#if (macro || dart_runtime)
import haxe.macro.Type;

interface IExprFilter {
    function filterExpr(e:TypedExpr):TypedExpr;
}

#end