package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;

class BinopPrecedence implements IExprFilter {
    public function new() {}

    public function filterExpr(e:TypedExpr):TypedExpr {
        // 1 == 2 == 3  ->  (1 == 2) == 3
        switch (e.expr) {
            case TBinop(op = OpEq|OpNotEq, eparen = {expr: TBinop(_,_,_)}, ee)
               | TBinop(op = OpEq|OpNotEq, ee, eparen = {expr: TBinop(_,_,_)}):
                eparen = eparen.copy(TParenthesis(eparen));
                e.expr = TBinop(op, ee, eparen);
                return e;
            default:
                return e;
        }
    }
}

#end