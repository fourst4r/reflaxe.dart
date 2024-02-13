// A bit of code to compile with your custom compiler.
//
// This code has no relevance beyond testing purposes.
// Please modify and add your own test code!

package;

import haxe.Json;

// @:nullSafety(Strict)
// function main() {
// 	Sys.println("asd" + 1);
// }

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

enum TestEnum {
	One;
	Two;
	Three;
}

@:nullSafety(StrictThreaded)
class TestClass {
	var field: TestEnum;

	public function new() {
		trace("Create Code class!");
		field = One;
	}

	public function increment() {
		switch(field) {
			case One: field = Two;
			case Two: field = Three;
			case _:
		}
		trace(field);
	}
}

typedef F = {
	a:Int, b:Int, c:Int, ?d:Int, ?e:Int,
}




class Code {
	@:nullSafety(Strict)
	static function main() {
		trace("Hello world!");

		final c = new TestClass();
		for(i in 0...3) {
			c.increment();
		}

		new ClassWithToStringChild();
		// var t:F = {a:0,b:1,c:2};
		// trace((t.a:Dynamic) + t.b+t.c + (t.e ?? 123));

		// 	// Creating an array using array syntax and explicit type definition Array<String>
		// var strings:Array<String> = ["Apple", "Pear", "Banana"];
		// trace(strings);
		// trace("ok");

		// var i:Null<String> = null;
		// trace(i ?? "itwasnull");

		// // Creating an array with float values
		// // Here, the type definition Array<Float> is left out - it is infered by the compiler
		// var floats = [10.2, 40.5, 60.3];
		// trace(floats);

		// var ints = [for(i in 0...5) i];
		// trace(ints); // [0,1,2,3,4]

		// var evens = [for(i in 0...5) i*2];
		// trace(evens); // [0,2,4,6,8]

		// var chars = [for(c in 65...70) String.fromCharCode(c)];
		// trace(chars); // ['A','B','C','D','E']         
		// for (c in chars)
		// 	trace(c);

		// var x = 1;
		// var bits = [while(x <= 64) x = x * 2];
		// trace(bits); // [2,4,8,16,32,64,128]

		// var strings:Array<String> = [];

		// // Adds "Hello" at index 0, offsetting elements to the right by one position
		// strings.insert(0, "Hello");

		// // Prepends "Haxe" to the start of the array
		// strings.unshift("Haxe");

		// // Appends "World" to the end of the array 
		// strings.push("World");

		// // Appends "foo", "bar" elements to the end of a copy of the array
		// strings = strings.concat(["foo", "bar"]);

		// var strings:Array<String> = ["first", "foo", "middle", "foo", "last"];

		// // Removes first occurence of "middle" in the array
		// strings.remove("middle");

		// // Removes and returns three elements beginning with (and including) index 0
		// var sub = strings.splice(0, 3);

		// // Removes and returns first element of the array
		// var first = strings.shift();

		// // Removes and returns last element of the array
		// var last = strings.pop();


		var strings:Array<String> = ["first", "foo", "middle", "foo", "last"];
		var i = 1;
		var j = 2;
		trace(i + j);
		trace(Lambda.count(strings, s -> s.length == 3));

		trace(Json.stringify(strings));
		Json.stringify(null);

		var d:Dynamic = null;
		if (d != null) {
			trace("notnull");
		} else {
			trace("null");
		}

		if (d == null) {
			trace("null");
		} else {
			trace("notnull");
		}
trace("ok");
		// Retrieves first array element
		var first = strings[0];

		// Retrieves last array element
		var last = strings[strings.length - 1];

		// Retrieves first occurrence of "foo" string
		// var first = strings[strings.indexOf("foo")];

		// Retrieves last occurrence of "foo" string
		// var last = strings[strings.lastIndexOf("foo")];
	}
}