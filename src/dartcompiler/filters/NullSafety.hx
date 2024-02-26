package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;
import reflaxe.helpers.Context;
import dartcompiler.TypeTools.mk;

class NullSafety implements IExprFilter implements IClassFilter {
    public function new() {}

    /**
        We have to do this specifically for returns, because for some reason
        TReturn type is always dynamic so we can't handle it in filterExpr...
    **/
    public function filterClass(cls:ClassDef):ClassDef {
        for (func in cls.funcFields) {
            if (func.expr != null && !func.ret.isNull()) {
                func.setExpr(coerceReturnsToNonNullable(func.expr));
            }
        }
        return cls;
    }

    /**
        Dart can have stricter null-safety than Haxe at times, so we have to
        make sure these cases can compile.
    **/
    function coerceReturnsToNonNullable(e:TypedExpr):TypedExpr {
        return switch (e.expr) {
            case TReturn(re) if (re?.t.isNull()):
                return e.copy(TReturn(mk(TUnop(OpNot, true, re))));
            default: 
                e.map(coerceReturnsToNonNullable);
        }
    }

    function coerceToNonNullable(e:TypedExpr):TypedExpr {
        return mk(TUnop(OpNot, true, e), e.t.unwrapNull(), e.pos);
    }

    public function filterExpr(e:TypedExpr):TypedExpr {
        // if (b:Null<Bool>) ==> if (b:Bool)
        return switch (e.expr) {
            case TIf(econd, eif, eelse) if (econd.t.isNull()):
                e.copy(TIf(coerceToNonNullable(econd), eif, eelse));
            default:
                e;
        }
    }
}

#end