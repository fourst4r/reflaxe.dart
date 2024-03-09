package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Expr;

/**
    Prevents accidentally shadowing a Dart base object field.

    The fields are:
        var hashCode(get, never):Int;
        var runtimeType(get, never):Type;
        function noSuchMethod(invocation:Invocation):Dynamic;
        function toString():String;
        static function hash(...):Int
        static function hashAll(...):Int;
        static function hashAllUnordered(...):Int;
**/
class ObjectFieldsFixer implements IClassFilter {
    public function new() {}

    public function filterClass(cls:ClassDef):ClassDef {
        if (cls.classType.isExtern)
            return cls;

        for (func in cls.varFields) {
            switch (func.field.name) {
                case "hashCode"|"runtimeType"|"noSuchMethod"|"toString"|"hash"|"hashAll"|"hashAllUnordered": 
                    func.field.meta.add(Meta.NativeName, [macro $v{"_"+func.field.name}], func.field.pos);
            }
        }

        final overrides = cls.classType.overrides.map(f -> f.get().name);
        for (func in cls.funcFields) {
            switch (func.field.name) {
                case "toString" if (!func.isStatic && !overrides.contains(func.field.name)): 
                    cls.classType.overrides.push(func.field.ref());
                case "hashCode"|"runtimeType"|"noSuchMethod"|"toString"|"hash"|"hashAll"|"hashAllUnordered": 
                    trace("MADE NATIVE: "+cls.classType.name+","+func.field.name);
                    func.field.meta.add(Meta.NativeName, [macro $v{"_"+func.field.name}], func.field.pos);
            }
        }

        return cls;
    }
}

#end