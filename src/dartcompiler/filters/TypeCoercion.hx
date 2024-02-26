package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;
import reflaxe.helpers.Context;
import dartcompiler.TypeTools.mk;

class TypeCoercion implements IExprFilter implements IClassFilter {
    public function new() {}

    /**
        We have to do this specifically for returns, because for some reason
        TReturn type is always dynamic so we can't handle it in filterExpr...
    **/
    public function filterClass(cls:ClassDef):ClassDef {
        for (func in cls.funcFields) {
            if (func.ret.isFloat()) {
                func.setExpr(coerceReturnsToDouble(func.expr));
            }
        }
        return cls;
    }

    function coerceReturnsToDouble(e:TypedExpr):TypedExpr {
        return switch (e.expr) {
            case TReturn(re):
                switch (re.expr) {
                    case TConst(TFloat(_)): e;
                    default: e.copy(TReturn(mk(TCall(mk(TField(re, FDynamic("toDouble"))), []))));
                }
            default: e.map(coerceReturnsToDouble);
        }
    }

    function coerceToDouble(e:TypedExpr):TypedExpr {
        return mk(TCall(mk(TField(e, FDynamic("toDouble"))), []));
    }

    public function filterExpr(e:TypedExpr):TypedExpr {
        // ((i:Int):Float) ==> i.toDouble()
        return switch (e.expr) {
            case TBinop(OpAssign, e1, e2) if (e1.t.isFloat() && e2.t.isInt()):
                e.copy(TBinop(OpAssign, e1, coerceToDouble(e2)));
            default:
                e;
        }
    }
}

#end