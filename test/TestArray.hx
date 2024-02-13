
class ClassWithToString {
	public function new(?a:Int) { 
        Sys.println("bassist");
    }
	public function toString() return "ClassWithToString.toString()";
}

class ClassWithToStringChild extends ClassWithToString {
    public function new() {
        Sys.println("before super");
        super(123);
        Sys.println("after super");
    }
}

class ClassWithToStringChild2 extends ClassWithToString {
	public override function toString() return "ClassWithToStringChild2.toString()";
}

class IntWrap {
	public var i(default, null):Int;

	public function new(i:Int) {
		this.i = i;
	}

	static public function compare(a:IntWrap, b:IntWrap) {
		return if (a.i == b.i) 0;
			else if (a.i > b.i) 1;
			else -1;
	}
}

@:native("assert")
extern function assert(cond:Bool):Void;

@:nullSafety(Strict)
function main() {
    // var a = 0.987;
    // // Sys.println(a);
    // var b = a;
    // var a = 1234;
    // var b = a;
    // Sys.println(b);

// length
assert([].length == 0);
assert([1].length == 1);
    var a:Array<Null<Int>> = [];
    a[4] = 1;
assert(a.length == 5);
a[a.length] = 1;
assert(a.length == 6);
var a = [];
trace(a);
    var b = a;
Sys.println(b);

// concat
assert([].concat([]) == []);
assert([1].concat([]) == [1]);
assert([].concat([1]) == [1]);
assert([1].concat([2]) == [1,2]);
assert([1,2].concat([2,1]) == [1,2,2,1]);

// join
assert([1,2].join("") == "12");
assert([].join("x") == "");
assert([1].join("x") == "1");
assert([1,2].join("x") == "1x2");
assert([].join("") == "");
assert([new ClassWithToString(), new ClassWithToStringChild(), new ClassWithToStringChild2()].join("_") == "ClassWithToString.toString()_ClassWithToString.toString()_ClassWithToStringChild2.toString()");

// pop
assert([].pop() == null);
assert([1].pop() == 1);
    var a = [1, 2, 3];
    var b = a;
    trace(b);


assert(a.pop() == 3);
assert(a == [1, 2]);
assert(a == b);
assert(a.pop() == 2);
assert(a == [1]);
assert(a == b);
assert(a.pop() == 1);
assert(a == []);
assert(a == b);
assert(a.pop() == null);
assert(a == []);
assert(a == b);

// push
var a:Array<Null<Int>> = [];
var b = a;
assert(a.push(1) == 1);
assert(a == b);
assert(a == [1]);
assert(a.push(2) == 2);
assert(a == b);
assert(a == [1, 2]);
assert(a.push(null) == 3);
assert(a == [1, 2, null]);

// reverse
var a = [1, 2, 3];
var b = a;
a.reverse();
assert(a == b);
assert(a == [3, 2, 1]);
var a = [];
a.reverse();
assert(a == []);
var a = [1];
a.reverse();
assert(a == [1]);

// shift
assert([].shift() == null);
assert([1].shift() == 1);
var a = [1, 2, 3];
var b = a;
assert(a.shift() == 1);
assert(a == [2, 3]);
assert(a == b);
assert(a.shift() == 2);
assert(a == [3]);
assert(a == b);
assert(a.shift() == 3);
assert(a == []);
assert(a == b);
assert(a.shift() == null);
assert(a == []);
assert(a == b);

// slice
var i0 = new IntWrap(1);
var i1 = new IntWrap(1);
var i2 = new IntWrap(5);
var i3 = new IntWrap(9);
var i4 = new IntWrap(2);
var a = [i4,i0,i1,i3,i0,i2];
var b = a.slice(0);
assert(b != a);
assert(b == [i4, i0, i1, i3, i0, i2]);
b = b.slice(1);
assert(b == [i0, i1, i3, i0, i2]);
b = b.slice(1, 3);
assert(b == [i1, i3]);
b = b.slice( -1);
assert(b == [i3]);
b = b.slice(0, 4);
assert(b == [i3]);
assert(b.slice( -3) == [i3]);
assert(b.slice( -3, -3) == []);
assert([1, 2, 3].slice(2, 1) == []);

// sort
var i0 = new IntWrap(1);
var i1 = new IntWrap(1);
var i2 = new IntWrap(5);
var i3 = new IntWrap(9);
var i4 = new IntWrap(2);
var a = [i4, i0, i1, i3, i0, i2];
haxe.ds.ArraySort.sort(a, IntWrap.compare);
assert(a == [i0, i1, i0, i4, i2, i3]);

// splice
var i0 = new IntWrap(1);
var i1 = new IntWrap(1);
var i2 = new IntWrap(5);
var i3 = new IntWrap(9);
var i4 = new IntWrap(2);
var b = [i4, i0, i1, i3, i0, i2];
var a = b.splice(0, 0);
b != a;
assert(a == []);
assert(b == [i4, i0, i1, i3, i0, i2]);
a = b.splice(1, b.length - 1);
assert(b == [i4]);
assert(a == [i0, i1, i3, i0, i2]);
b = a.splice(1, -1);
assert(a == [i0, i1, i3, i0, i2]);
assert(b == []);
b = a.splice(0, 10);
assert(b == [i0, i1, i3, i0, i2]);
assert(a == []);
a = b.splice(10, 10);
assert(a == []);
b = [i0, i1, i3, i0, i2];
a = b.splice( -2, 2);
assert(b == [i0, i1, i3]);
assert(a == [i0, i2]);

// toString
var a = [new ClassWithToString(), new ClassWithToStringChild(), new ClassWithToStringChild2()];
var comp = "ClassWithToString.toString(),ClassWithToString.toString(),ClassWithToStringChild2.toString()";
assert([comp, "[" + comp + "]"].contains(a.toString()));

// unshift
var a:Array<Null<Int>> = [];
var b = a;
a.unshift(1);
assert(a == b);
assert(a == [1]);
a.unshift(2);
assert(a == b);
assert(a == [2, 1]);
a.unshift(null);
assert(a == [null, 2, 1]);

// insert
var a = [];
a.insert(5, 1);
assert(a == [1]);
var a = [1, 2, 3];
a.insert(1, 4);
assert(a == [1, 4, 2, 3]);
var a = [1, 2, 3];
a.insert( -1, 4);
assert(a == [1, 2, 4, 3]);
a.insert( -2, 8);
assert(a == [1, 2, 8, 4, 3]);
a.insert ( -8, 9);
assert(a == [9, 1, 2, 8, 4, 3]);

// remove
var i0 = new IntWrap(1);
var i1 = new IntWrap(1);
var i2 = new IntWrap(5);
var i3 = new IntWrap(9);
var i4 = new IntWrap(2);
var a = [i4, i0, i1, i3, i0, i2];
assert(a.remove(i0) == true);
assert(a == [i4, i1, i3, i0, i2]);
assert(a.remove(i0) == true);
assert(a == [i4, i1, i3, i2]);
assert(a.remove(i0) == false);
assert(a == [i4, i1, i3, i2]);
var a = ["foo", "bar"];
assert(a.remove("foo") == true);
assert(a == ["bar"]);
var a = [i0, null, i1, null, null];
assert(a.remove(null) == true);
assert(a == [i0, i1, null, null]);
assert(a.remove(null) == true);
assert(a == [i0, i1, null]);
assert(a.remove(null) == true);
assert(a == [i0, i1]);
assert(a.remove(null) == false);
assert(a == [i0, i1]);

// contains
assert([].contains(1) == false);
assert([1].contains(1) == true);
assert([1].contains(2) == false);
assert([1,2].contains(1) == true);
assert([1,2].contains(2) == true);
assert([1,2].contains(3) == false);
#if !js // see https://github.com/HaxeFoundation/haxe/issues/3330
assert(([1,2]:Dynamic).contains(2) == true);
#end

// indexOf
assert([].indexOf(10) == -1);
assert([10].indexOf(10) == 0);
assert([10, 10].indexOf(10) == 0);
assert([2, 10].indexOf(10) == 1);
assert([2, 5].indexOf(10) == -1);
assert(["foo", "bar", "bar", "baz"].indexOf("bar") == 1);
assert([1, 10, 10, 1].indexOf(10, 0) == 1);
assert([1, 10, 10, 1].indexOf(10, 1) == 1);
assert([1, 10, 10, 1].indexOf(10, 2) == 2);
assert([1, 10, 10, 1].indexOf(10, 3) == -1);
assert([1, 10, 10, 1].indexOf(10, 4) == -1);
assert([1, 10, 10, 1].indexOf(10, 5) == -1);
assert([1, 10, 10, 1].indexOf(10, -1) == -1);
assert([1, 10, 10, 1].indexOf(10, -2) == 2);
assert([1, 10, 10, 1].indexOf(10, -3) == 1);
assert([1, 10, 10, 1].indexOf(10, -5) == 1);

// lastIndexOf
assert([].lastIndexOf(10) == -1);
assert([10].lastIndexOf(10) == 0);
assert([10, 10].lastIndexOf(10) == 1);
assert([2, 10].lastIndexOf(10) == 1);
assert([2, 5].lastIndexOf(10) == -1);
assert(["foo", "bar", "bar", "baz"].lastIndexOf("bar") == 2);
assert([1, 10, 10, 1].lastIndexOf(10, 4) == 2);
assert([1, 10, 10, 1].lastIndexOf(10, 3) == 2);
assert([1, 10, 10, 1].lastIndexOf(10, 2) == 2);
assert([1, 10, 10, 1].lastIndexOf(10, 1) == 1);
assert([1, 10, 10, 1].lastIndexOf(10, 0) == -1);
assert([1, 10, 10, 1].lastIndexOf(10, -1) == 2);
assert([1, 10, 10, 1].lastIndexOf(10, -2) == 2);
assert([1, 10, 10, 1].lastIndexOf(10, -3) == 1);
assert([1, 10, 10, 1].lastIndexOf(10, -4) == -1);
assert([1, 10, 10, 1].lastIndexOf(10, -5) == -1);

// copy
var i0 = new IntWrap(1);
var i1 = new IntWrap(1);
var i2 = new IntWrap(5);
var a = [i0, i1, i2];
var b = a.copy();
assert(a != b);
assert(b == [i0, i1, i2]);
var a = [];
var b = a.copy();
assert(a != b);
assert(b == []);

// map
assert([1, 2, 3].map(function(i) return i * 2) == [2, 4, 6]);
var a = [new IntWrap(1), new IntWrap(2)];
var b = a.map(function(x) return x);
assert(a != b);
assert(b.length == a.length);
assert(a[0] == b[0]);
assert(a[1] == b[1]);
var func = function(s) return s.toUpperCase();
assert(["foo", "bar"].map(func) == ["FOO", "BAR"]);
assert([].map(func) == []);

// filter
assert([1, 2, 3, 4].filter(function(i) return i < 3) == [1, 2]);
assert([1, 2, 3, 4].filter(function(i) return true) == [1, 2, 3, 4]);
assert([1, 2, 3, 4].filter(function(i) return false) == []);
assert([].filter(function(_) return true) == []);
assert([].filter(function(_) return false) == []);
var arr = [{id: 1}, {id: 2}, {id: 3}, {id: 4}, {id: 5}];
arr = arr.filter(function(i) return i.id % 2 != 0);
var values = [];
for (a in arr) values.push(a.id);
assert(values == [1, 3, 5]);

// check that map and filter work well on Dynamic as well
var a : Dynamic = [0,1,2];
var b : Dynamic = a.filter(function(x) return x & 1 == 0).map(function(x) return x * 10);
assert(b.length == 2);
assert(b[0] == 0);
assert(b[1] == 20);

// resize
var a : Array<Int> = [1,2,3];
a.resize(10);
assert(a.length == 10);
assert(a == [1,2,3]);
a.resize(2);
assert(a.length == 2);
assert(a == [1, 2]);
a.resize(3);
assert(a.length == 3);
assert(a[0] == 1);
assert(a[1] == 2);
assert(a[2] != 3);
a.resize(0);
assert(a.length == 0);
assert(a == []);

// keyValueIterator
var a : Array<Int> = [1,2,3,5,8];
assert([for (k=>v in a) k] == [0,1,2,3,4]);
assert([for (k=>v in a) v] == [1,2,3,5,8]);
assert([for (k=>v in a) k*v] == [0,2,6,15,32]);

// keyValueIterator through Structure
var a : Array<Int> = [1,2,3,5,8];
var it : KeyValueIterator<Int, Int> = a.keyValueIterator();
var a2 = [for (k=>v in it) k];
assert(a2 == [0,1,2,3,4]);
var it : KeyValueIterator<Int, Int> = a.keyValueIterator();
a2 = [for (k=>v in it) v];
assert(a2 == [1,2,3,5,8]);
var it : KeyValueIterator<Int, Int> = a.keyValueIterator();
a2 = [for (k=>v in it) k*v];
assert(a2 == [0,2,6,15,32]);

// keyValueIterator through Structure
var a : Array<Int> = [1,2,3,5,8];
var it : KeyValueIterable<Int, Int> = a;
assert([for (k=>v in it) k] == [0,1,2,3,4]);
assert([for (k=>v in it) v] == [1,2,3,5,8]);
assert([for (k=>v in it) k*v] == [0,2,6,15,32]);

#if !flash
// Can't create this closure on Flash apparently
// keyValueIterator closure because why not
var a : Array<Int> = [1,2,3,5,8];
var itf : () -> KeyValueIterator<Int, Int> = a.keyValueIterator;
var it = itf();
var a2 = [for (k=>v in it) k];
assert(a2 == [0,1,2,3,4]);
var itf : () -> KeyValueIterator<Int, Int> = a.keyValueIterator;
var it = itf();
a2 = [for (k=>v in it) v];
assert(a2 == [1,2,3,5,8]);
var itf : () -> KeyValueIterator<Int, Int> = a.keyValueIterator;
var it = itf();
a2 = [for (k=>v in it) k*v];
assert(a2 == [0,2,6,15,32]);
#end
}