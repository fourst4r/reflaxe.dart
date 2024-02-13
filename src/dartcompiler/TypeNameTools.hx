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

    /** Qualified name of BaseType, including the package in the type name. **/
    public static function qualifiedName(bt:BaseType):String {
        if (bt.hasMeta(Meta.Native)) 
            return bt.getNameOrNative();

        // final prefix = bt.importPrefix();
        final name = bt.getNameOrNativeName();

        // if (prefix != null)
            // return prefix + name;

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