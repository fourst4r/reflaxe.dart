import dart.Lib.assert;

typedef T = {
	function func():Void;
	var v:String;
	public var prop(default, null):String;
}

@:keep class C {
	public function func() { }
	public var v:String;
	public var prop(default, null):String;
	static function staticFunc() { }
	static public var staticVar:String;
	static var staticProp(default, null):String;

	public function new() {
		v = "var";
		prop = "prop";
		staticVar = "staticVar";
		staticProp = "staticProp";
	}
}

@:keep class C2 {
	public function func() { return "foo"; }
	public var v:String;
	public var prop(default, null):String;
	@:isVar public var propAcc(get, set):String;

	public function new() {
		v = "var";
		prop = "prop";
		propAcc = "0";
	}

	public function get_propAcc() {
		return "1";
	}

	public function set_propAcc(v) {
		return this.propAcc = v.toUpperCase();
	}
}

class CChild extends C { }

class EmptyClass {
	public function new() { }
}

@:keep class ReallyEmptyClass { }

class ClassWithToString {
    public function new() {
        trace("base trace");
    }
    public function toString() return "ClassWithToString.toString()";
}

class ClassWithToStringChild extends ClassWithToString {
    public function new() {
        trace("before super");
        super();
    }
}

@:keep class ClassWithCtorDefaultValues {
	public var a : Null<Int>;
	public var b : String;
	public function new(a = 1, b = "foo") {
		this.a = a;
		this.b = b;
	}
}

class ClassWithCtorDefaultValuesChild extends ClassWithCtorDefaultValues {

}

@:keep class ClassWithCtorDefaultValues2 {
	public var a : Null<Float>;
	public var b : String;
	public function new(a = 1.1, b = "foo") {
		this.a = a;
		this.b = b;
	}
}

enum E {
	NoArgs;
	OneArg(i:Int);
	RecArg(e:E);
	MultipleArgs(i:Int, s:String);
}

enum EnumFlagTest {
	EA;
	EB;
	EC;
}



function main() {

switch (Math.random()) {
    case 0: 
    case 1:
    case 2:
}

    // getClass
    assert(Type.getClass("foo") == String);
    assert(Type.getClass(new C()) == C);
    
    //Issue #1485
    assert(Type.getClass([]) == Array);
    assert(Type.getClass(Float) == null);
    assert(Type.getClass(null) == null);
    assert(Type.getClass(Int) == null);
    assert(Type.getClass(Bool) == null);
    //Type.getClass(haxe.macro.Expr.ExprDef.EBreak) == null);
    assert(Type.getClass( { } ) == null);

    // getEnum
    assert(Type.getEnum(haxe.macro.Expr.ExprDef.EBreak) == haxe.macro.Expr.ExprDef);
    assert(Type.getEnum(null) == null);

    // getSuperClass
    assert(Type.getSuperClass(String) == null);
    assert(Type.getSuperClass(ClassWithToString) == null);
    assert(Type.getSuperClass(ClassWithToStringChild) == ClassWithToString);
    //Type.getSuperClass(null) == null;

    // getClassName
    assert(Type.getClassName(String) == "String");
    // assert(Type.getClassName(C) == "unit.spec.C");
    //Type.getClassName(null) == null;
    assert(Type.getClassName(Type.getClass([])) == "Array");

    // getEnumName
    //Type.getEnumName(null) == null;
    assert(Type.getEnumName(haxe.macro.Expr.ExprDef) == "haxe.macro.ExprDef");

    // resolveClass
    assert(Type.resolveClass("String") == String);
    // assert(Type.resolveClass("unit.spec.C") == C);
    //Type.resolveClass("Float") == null;
    //Type.resolveClass(null) == null;
    assert(Type.resolveClass("MyNonExistingClass") == null);

    // resolveEnum
    //Type.resolveEnum(null) == null;
    assert(Type.resolveEnum("haxe.macro.ExprDef") == haxe.macro.Expr.ExprDef);
    assert(Type.resolveEnum("String") == null);

    // createInstance
    assert(Type.createInstance(String, ["foo"]) == "foo");
    //Type.createInstance(null, []) == null;
    assert(Type.createInstance(C, []).v == "var");
    //var t = Type.createInstance(ClassWithCtorDefaultValues, []);
    //t.a == 1;
    //t.b == "foo";
    //var t = Type.createInstance(ClassWithCtorDefaultValues, [2]);
    //t.a == 2;
    //t.b == "foo";
    var c = Type.createInstance(ClassWithCtorDefaultValues, [2, "bar"]);
    assert(c.a == 2);
    assert(c.b == "bar");
    var c2 = Type.createInstance(ClassWithCtorDefaultValues2, [2, "bar"]);
    assert(c2.a == 2);
    assert(c2.b == "bar");
    //var t = Type.createInstance(ClassWithCtorDefaultValuesChild, [2, "bar"]);
    //t.a == 2;
    //t.b == "bar";

    // createEmptyInstance
    //Type.createEmptyInstance(String) == "foo";
    //Type.createEmptyInstance(null, []) == null;
    var c = Type.createEmptyInstance(ClassWithCtorDefaultValues);
    assert(c.a == null);
    assert(c.b == null);
    var c = Type.createEmptyInstance(ClassWithCtorDefaultValuesChild);
    assert(c.a == null);
    assert(c.b == null);

    // createEnum
    var e = Type.createEnum(E, "NoArgs");
    assert(e == NoArgs);
    assert(Type.createEnum(E, "NoArgs", []) == NoArgs);
    assert(Type.enumEq(Type.createEnum(E, "OneArg", [1]), OneArg(1)) == true);
    assert(Type.enumEq(Type.createEnum(E, "RecArg", [e]), RecArg(e)) == true);
    assert(Type.enumEq(Type.createEnum(E, "MultipleArgs", [1, "foo"]), MultipleArgs(1, "foo")) == true);

    // createEnumIndex
    var e = Type.createEnumIndex(E, 0);
    assert(e == NoArgs);
    assert(Type.createEnumIndex(E, 0, []) == NoArgs);
    assert(Type.createEnumIndex(E, 0, null) == NoArgs);
    assert(Type.enumEq(Type.createEnumIndex(E, 1, [1]), OneArg(1)) == true);
    assert(Type.enumEq(Type.createEnumIndex(E, 2, [e]), RecArg(e)) == true);
    assert(Type.enumEq(Type.createEnumIndex(E, 3, [1, "foo"]), MultipleArgs(1, "foo")) == true);
    var e = Type.createEnumIndex(EnumFlagTest, 0);
    assert(e == EA);
    assert(Type.createEnumIndex(EnumFlagTest, 1, []) == EB);
    assert(Type.createEnumIndex(EnumFlagTest, 2, null) == EC);

    // getInstanceFields
    var fields = Type.getInstanceFields(C);
    var requiredFields = ["func", "v", "prop"];
    for (f in fields)
        requiredFields.remove(f);
        // t(requiredFields.remove(f));
    assert(requiredFields == []);
    var fields = Type.getInstanceFields(CChild);
    var requiredFields = ["func", "v", "prop"];
    for (f in fields)
        requiredFields.remove(f);
        // t(requiredFields.remove(f));
    assert(requiredFields == []);
    var fields = Type.getClassFields(C);
    var requiredFields = ["staticFunc", "staticVar", "staticProp"];
    for (f in fields)
        requiredFields.remove(f);
        // t(requiredFields.remove(f));
    assert(requiredFields == []);
    var fields = Type.getClassFields(CChild);
    var requiredFields = [];
    for (f in fields)
        requiredFields.remove(f);
        // t(requiredFields.remove(f));
    assert(requiredFields == []);

    // getEnumConstructs
    assert(Type.getEnumConstructs(E) == ["NoArgs", "OneArg", "RecArg", "MultipleArgs"]);
    assert(Type.getEnumConstructs(EnumFlagTest) == ["EA", "EB", "EC"]);

    // typeof
    // not much to test here?

    // enumEq
    assert(Type.enumEq(NoArgs, NoArgs) == true);
    assert(Type.enumEq(OneArg(1), OneArg(1)) == true);
    assert(Type.enumEq(RecArg(OneArg(1)), RecArg(OneArg(1))) == true);
    assert(Type.enumEq(MultipleArgs(1, "foo"), MultipleArgs(1, "foo")) == true);
    assert(Type.enumEq(NoArgs, OneArg(1)) == false);
    assert(Type.enumEq(NoArgs, RecArg(NoArgs)) == false);
    assert(Type.enumEq(NoArgs, MultipleArgs(1, "foo")) == false);
    assert(Type.enumEq(OneArg(1), OneArg(2)) == false);
    assert(Type.enumEq(RecArg(OneArg(1)), RecArg(OneArg(2))) == false);
    assert(Type.enumEq(EA, EA) == true);
    assert(Type.enumEq(EA, EB) == false);

    // enumConstructor
    assert(Type.enumConstructor(NoArgs) == "NoArgs");
    assert(Type.enumConstructor(OneArg(1)) == "OneArg");
    assert(Type.enumConstructor(RecArg(OneArg(1))) == "RecArg");
    assert(Type.enumConstructor(MultipleArgs(1, "foo")) == "MultipleArgs");
    assert(Type.enumConstructor(EC) == "EC");

    // enumParameters
    assert(Type.enumParameters(NoArgs) == []);
    assert(Type.enumParameters(OneArg(1)) == [1]);
    assert(Type.enumParameters(RecArg(NoArgs)) == [NoArgs]);
    assert(Type.enumParameters(MultipleArgs(1, "foo")) == [1, "foo"]);
    assert(Type.enumParameters(EC) == []);

    // enumIndex
    assert(Type.enumIndex(NoArgs) == 0);
    assert(Type.enumIndex(OneArg(1)) == 1);
    assert(Type.enumIndex(RecArg(OneArg(1))) == 2);
    assert(Type.enumIndex(MultipleArgs(1, "foo")) == 3);
    assert(Type.enumIndex(EB) == 1);

    // allEnums
    assert(Type.allEnums(E) == [NoArgs]);
    assert(Type.allEnums(haxe.macro.Expr.ExprDef) == [EBreak, EContinue]);
    assert(Type.allEnums(EnumFlagTest) == [EA, EB, EC]);
}