package dartcompiler;

#if (macro || dart_runtime)

import haxe.macro.Type;
import reflaxe.helpers.Context;

class MetaTools {
    public static function importPrefix(bt:BaseType):Null<String> {
        final pkg = bt.meta.extractStringFromFirstMeta(Meta.Import) ?? return null;
        return switch (pkg.split(":")) {
            case [path]: path.replace("/", "_");
            case [scheme, path]: scheme + "_" + path.replace("/", "_");
            default: 
                Context.error("unsupported import format", bt.pos);
        }
    }
}

#end