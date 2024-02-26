package;

@:coreApi
class Reflect {
	public static inline function hasField(o:Dynamic, field:String):Bool {
		// return Boot.hasField(o, field);
        return false;
	}

	@:ifFeature("dynamic_read", "anon_optional_read")
	public static function field(o:Dynamic, field:String):Dynamic {
		// return Boot.field(o, field);
        return null;
	}

	@:ifFeature("dynamic_write", "anon_optional_write")
	public static inline function setField(o:Dynamic, field:String, value:Dynamic):Void {
		// UBuiltins.setattr(o, handleKeywords(field), value);
	}

	public static function getProperty(o:Dynamic, field:String):Dynamic {
        return null;
		// if (o == null)
		// 	return null;

		// field = handleKeywords(field);
		// if (Boot.isAnonObject(o))
		// 	return Reflect.field(o, field);
		// var tmp = Reflect.field(o, "get_" + field);
		// if (tmp != null && UBuiltins.callable(tmp))
		// 	return tmp();
		// else
		// 	return Reflect.field(o, field);
	}

	public static function setProperty(o:Dynamic, field:String, value:Dynamic):Void {
		// var field = handleKeywords(field);
		// if (Boot.isAnonObject(o))
		// 	UBuiltins.setattr(o, field, value);
		// else if (UBuiltins.hasattr(o, "set_" + field))
		// 	UBuiltins.getattr(o, "set_" + field)(value);
		// else
		// 	UBuiltins.setattr(o, field, value);
	}

	public static function callMethod(o:Dynamic, func:haxe.Constraints.Function, args:Array<Dynamic>):Dynamic {
		// return if (UBuiltins.callable(func)) func(python.Syntax.varArgs(args)) else null;
        return null;
	}

	public static inline function fields(o:Dynamic):Array<String> {
		// return python.Boot.fields(o);
        return [];
	}

	public static function isFunction(f:Dynamic):Bool {
		// return Inspect.isfunction(f) || Inspect.ismethod(f) || Boot.hasField(f, "func_code");
        return false;
	}

	public static function compare<T>(a:T, b:T):Int {
		// if (a == null && b == null)
			return 0;
		// return if (a == null) 1 else if (b == null) -1 else (a == b) ? 0 : (((cast a) > (cast b)) ? 1 : -1);
	}

	static inline function isClosure(v:Dynamic):Bool {
		// return UBuiltins.isinstance(v, MethodClosure);
        return false;
	}

	public static function compareMethods(f1:Dynamic, f2:Dynamic):Bool {
		// if (f1 == f2)
		// 	return true;
		// if (isClosure(f1) && isClosure(f2)) {
		// 	var m1 = (f1 : MethodClosure);
		// 	var m2 = (f2 : MethodClosure);
		// 	return m1.obj == m2.obj && m1.func == m2.func;
		// }
		// if (!isFunction(f1) || !isFunction(f2))
		// 	return false;

		return false;
	}

	public static function isObject(v:Dynamic):Bool {
		return switch (Type.typeof(v)) {
			case TObject, TClass(_): true;
			case _: false;
		}
	}

	public static function isEnumValue(v:Dynamic):Bool {
		// return v != Enum && UBuiltins.isinstance(v, cast Enum);
        return false;
	}

	public static function deleteField(o:Dynamic, field:String):Bool {
		// field = handleKeywords(field);
		// if (!hasField(o, field))
		// 	return false;
		// Syntax.callField(o, "__delattr__", field);
		return true;
	}

	public static function copy<T>(o:Null<T>):Null<T> {
		if (o == null)
			return null;
		var o2:Dynamic = {};
		for (f in Reflect.fields(o))
			Reflect.setField(o2, f, Reflect.field(o, f));
		return o2;
	}

	public static function makeVarArgs(f:Array<Dynamic>->Dynamic):Dynamic {
		// return function(v:VarArgs<Dynamic>) {
		// 	return f(v);
		// }
        return null;
	}
}
