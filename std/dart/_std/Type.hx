package;

enum ValueType {
	TNull;
	TInt;
	TFloat;
	TBool;
	TObject;
	TFunction;
	TClass(c:Class<Dynamic>);
	TEnum(e:Enum<Dynamic>);
	TUnknown;
}

// @:coreApi 
@:nativeName("$HxType")
class Type {
	public static function getClass<T>(o:T):Class<T> {
        return untyped o?.runtimeType;
	// 	if (o == null)
	// 		return null;

	// 	if (python.Boot.isClass(o))
	// 		return null;

	// 	if (python.Boot.isAnonObject(o))
	// 		return null;

	// 	if (Internal.hasClass(o)) {
	// 		return Internal.fieldClass(o);
	// 	}
	// 	if (UBuiltins.hasattr(o, "__class__")) {
	// 		return Syntax.field(o, "__class__");
	// 	} else {
	// 		return null;
	// 	}
	}

	public static function getEnum(o:EnumValue):Enum<Dynamic> {
	// 	if (o == null)
			return null;
	// 	return Syntax.field(o, "__class__");
	}

	public static function getSuperClass(c:Class<Dynamic>):Class<Dynamic> {
        return null;
	// 	return python.Boot.getSuperClass(c);
	}

	public static function getClassName(c:Class<Dynamic>):String {
	// 	if (Internal.hasClassName(c)) {
	// 		return Internal.fieldClassName(c);
	// 	} else {
	// 		// it's not a Haxe class
	// 		if (c == Array)
	// 			return "Array";
	// 		if (c == Math)
	// 			return "Math";
	// 		if (c == String)
	// 			return "String";

	// 		try {
	// 			return Syntax.field(c, "__name__");
	// 		} catch (e:Dynamic) {
				return null;
	// 		}
	// 	}
	}

	public static function getEnumName(e:Enum<Dynamic>):String {
        return "TODO";
	// 	return Internal.fieldClassName(e);
	}

	public static function resolveClass(name:String):Class<Dynamic> {
	// 	if (name == "Array")
	// 		return Array;
	// 	if (name == "Math")
	// 		return Math;
	// 	if (name == "String")
	// 		return String;

	// 	var cl:Class<Dynamic> = Internal.classRegistry().get(name, null);
	// 	// ensure that this is a class
	// 	if (cl == null || !python.Boot.isClass(cl))
			return null;
	// 	return cl;
	}

	public static function resolveEnum(name:String):Enum<Dynamic> {
	// 	if (name == "Bool")
	// 		return cast Bool;
	// 	var o = resolveClass(name);
	// 	return if (Internal.hasConstructs(o)) cast o else null;
    return null;
	}

	public static inline function createInstance<T>(cl:Class<T>, args:Array<Dynamic>):T {
	// 	return Syntax.construct(cl, Syntax.varArgs(args));
    return null;
	}

	public static function createEmptyInstance<T>(cl:Class<T>):T {
	// 	var i = Syntax.callField(cl, "__new__", cl);

	// 	function callInit(cl) {
	// 		var sc = getSuperClass(cl);
	// 		if (sc != null) {
	// 			callInit(sc);
	// 		}
	// 		if (Internal.hasEmptyInit(cl)) {
	// 			Internal.callEmptyInit(cl, i);
	// 		}
	// 	}
	// 	callInit(cl);

	// 	return i;
    return null;
	}

	public static function createEnum<T>(e:Enum<T>, constr:String, ?params:Array<Dynamic>):T {
	// 	var f:Dynamic = Reflect.field(e, constr);
	// 	if (f == null)
			throw "No such constructor " + constr;
	// 	if (Reflect.isFunction(f)) {
	// 		if (params == null)
	// 			throw "Constructor " + constr + " need parameters";

	// 		return Reflect.callMethod(e, f, params);
	// 	}
	// 	if (params != null && params.length != 0)
	// 		throw "Constructor " + constr + " does not need parameters";
	// 	return f;
	}

	public static function createEnumIndex<T>(e:Enum<T>, index:Int, ?params:Array<Dynamic>):T {
	// 	var c:String = Internal.fieldConstructs(e)[index];
	// 	if (c == null)
			throw index + " is not a valid enum constructor index";
	// 	return createEnum(e, c, params);
	}

	public static inline function getInstanceFields(c:Class<Dynamic>):Array<String> {
	// 	return python.Boot.getInstanceFields(c);
    return [];
	}

	public static inline function getClassFields(c:Class<Dynamic>):Array<String> {
        return [];
	// 	return python.Boot.getClassFields(c);
	}

	public static function getEnumConstructs(e:Enum<Dynamic>):Array<String> {
	// 	if (UBuiltins.hasattr(e, Internal.constructsVal())) {
	// 		var x:Array<String> = Internal.fieldConstructs(e);
	// 		return x.copy();
	// 	} else {
			return [];
	// 	}
	}

	public static function typeof(v:Dynamic):ValueType {
		if (v == null) {
			return TNull;
		} else if (v is Bool) {
			return TBool;
		} else if (v is Int) {
			return TInt;
		} else if (v is Float) {
			return TFloat;
		} else if (v is String) {
			return TClass(String);
		} else if (v is Array) {
			return TClass(Array);
		} else if (untyped v.runtimeType == $HxAnon) {
			return TObject;
		} else if (v is dart.core.Enum || untyped v.runtimeType == $HxEnum) {
            return TEnum(untyped v.runtimeType);
			// return TEnum(Syntax.field(v, "__class__"));
		} else if (untyped __dart__("{0} is Object", v)) {
            return TClass(untyped v.runtimeType);
			// return TClass(Syntax.field(v, "__class__"));
		} else if (v is dart.core.Function) {
			return TFunction;
		} else {
			return TUnknown;
		}
	}

	// static inline function asEnumImpl(x:Dynamic):EnumImpl {
	// 	return (cast x : EnumImpl);
	// }

	public static function enumEq<T>(a:T, b:T):Bool {
	// 	if (a == b)
	// 		return true;
	// 	try {
	// 		if (b == null && a != b)
	// 			return false;
	// 		if (asEnumImpl(a).tag != asEnumImpl(b).tag)
	// 			return false;
	// 		var p1 = asEnumImpl(a).params;
	// 		var p2 = asEnumImpl(b).params;
	// 		if (p1.length != p2.length)
	// 			return false;

	// 		for (i in 0...p1.length)
	// 			if (!enumEq(p1[i], p2[i]))
	// 				return false;

	// 		if (Internal.fieldClass(a) != Internal.fieldClass(b))
	// 			return false;
	// 	} catch (e:Dynamic) {
			return false;
	// 	}
	// 	return true;
	}

	public static inline function enumConstructor(e:EnumValue):String {
	// 	return asEnumImpl(e).tag;
    return "TODO";
	}

	public static inline function enumParameters(e:EnumValue):Array<Dynamic> {
	// 	return asEnumImpl(e).params.toArray();
    return [];
	}

	public static inline function enumIndex(e:EnumValue):Int {
	// 	return asEnumImpl(e).index;
    return -1;
	}

	public static function allEnums<T>(e:Enum<T>):Array<T> {
	// 	var ctors = getEnumConstructs(e);
	// 	var ret = [];
	// 	for (ctor in ctors) {
	// 		var v = Reflect.field(e, ctor);
	// 		if (Std.isOfType(v, e))
	// 			ret.push(v);
	// 	}

	// 	return ret;
    return [];
	}
}
