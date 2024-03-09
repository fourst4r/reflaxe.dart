package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;

typedef AbstractDef = {
    abstractType: AbstractType,
    classDef: ClassDef,
}

#end