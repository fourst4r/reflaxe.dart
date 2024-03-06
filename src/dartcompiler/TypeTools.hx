package dartcompiler;

#if (macro || dart_runtime)

import haxe.macro.Type;

class TypeTools {

    public static function isUnreflectable(cls:ClassType):Bool {
        return cls.name.endsWith("_Impl_") 
            || cls.name.endsWith("_Fields_");
    }

    public static function ref<T>(o:T) {
        return {get: () -> o, toString: Std.string.bind(o)};
    }

    public static function mk(def:TypedExprDef, ?t:Type, ?pos) {
        return TypedExprHelper.make(def, t ?? TDynamic(null), pos);
    }

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