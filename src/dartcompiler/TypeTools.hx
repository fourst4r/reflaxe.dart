package dartcompiler;

#if (macro || dart_runtime)

import haxe.macro.Type;

class TypeNameTools {
    public static function with(e:TypedExpr, ?edef:TypedExprDef, ?t:Type) {
		return {
			expr: edef == null ? e.expr : edef,
			pos: e.pos,
			t: t == null ? e.t : t
		}
	}

    public static function extractFunctionBody(e:TypedExpr):TypedExpr {
        return switch (e.expr) {
            case TFunction(tfunc): tfunc.expr;
            default: throw "not a function";
        }
    }

    public static function unwrapNull(t: Type): Type {
		return switch(t) {
			case TAbstract(absRef, params) if(params.length == 1): {
				final abs = absRef.get();
				if(abs.name == "Null" && abs.pack.length == 0) {
					unwrapNull(params[0]);
				} else {
					t;
				}
			}
			case _: t;
		}
	}

    /** Qualified name of BaseType, including the package in the type name. **/
    public static function qualifiedName(bt:BaseType):String {
        if (bt.hasMeta(Meta.Native)) 
            return bt.getNameOrNative();

        final name = bt.getNameOrNativeName();

        return bt.pack.concat([name]).join("_");
    }

    public static function unwrapBlock(expr:TypedExpr) {
        return switch (expr.expr) {
            case TBlock(el): el;
            default: [];
        }
    }

    public static function isSumType(t:EnumType) {
        return t.constructs.array().exists(c -> c.type.getTFunArgs() != null);
    }
}

#end