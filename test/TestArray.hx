import dart.Lib.assert;

function aeq<T>(a:Array<T>, b:Array<T>) {
    for (i in 0...a.length) {
        assert(a[i] == b[i]);
    }
}

function aneq(a, b) assert(a != b);

class ClassWithToString {
	public function new(?a:Int) { 
        Sys.println("bassist");
    }
    @:keep
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
    @:keep
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

@:nullSafety(StrictThreaded)
function main() {

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


    // concat
    aeq([].concat([]) , []);
    aeq([1].concat([]) , [1]);
    aeq([].concat([1]) , [1]);
    aeq([1].concat([2]) , [1,2]);
    aeq([1,2].concat([2,1]) , [1,2,2,1]);

    // join
    assert([1,2].join("") == "12");
    assert([].join("x") == "");
    assert([1].join("x") == "1");
    assert([1,2].join("x") == "1x2");
    assert([].join("") == "");
    trace([new ClassWithToString(), new ClassWithToStringChild(), new ClassWithToStringChild2()].join("_"));
    assert([new ClassWithToString(), new ClassWithToStringChild(), new ClassWithToStringChild2()].join("_") == "ClassWithToString.toString()_ClassWithToString.toString()_ClassWithToStringChild2.toString()");

    // pop
    assert([].pop() == null);
    assert([1].pop() == 1);
    var a = [1, 2, 3];
    var b = a;
    trace(b);


    assert(a.pop() == 3);
    aeq(a , [1, 2]);
    aeq(a , b);
    assert(a.pop() == 2);
    aeq(a , [1]);
    aeq(a , b);
    assert(a.pop() == 1);
    aeq(a, []);
    aeq(a , b);
    assert(a.pop() == null);
    aeq(a , []);
    aeq(a, b);

    // push
    var a:Array<Null<Int>> = [];
    var b = a;
    assert(a.push(1) == 1);
    aeq(a, b);
    aeq(a, [1]);
    assert(a.push(2) == 2);
    aeq(a, b);
    aeq(a, [1, 2]);
    assert(a.push(null) == 3);
    aeq(a, [1, 2, null]);

    // reverse
    var a = [1, 2, 3];
    var b = a;
    a.reverse();
    aeq(a, b);
    aeq(a, [3, 2, 1]);
    var a = [];
    a.reverse();
    aeq(a, []);
    var a = [1];
    a.reverse();
    aeq(a, [1]);

    // shift
    assert([].shift() == null);
    assert([1].shift() == 1);
    var a = [1, 2, 3];
    var b = a;
    assert(a.shift() == 1);
    aeq(a , [2, 3]);
    aeq(a , b);
    assert(a.shift() == 2);
    aeq(a , [3]);
    aeq(a , b);
    assert(a.shift() == 3);
    aeq(a , []);
    aeq(a , b);
    assert(a.shift() == null);
    aeq(a , []);
    aeq(a, b);

    // slice
    var i0 = new IntWrap(1);
    var i1 = new IntWrap(1);
    var i2 = new IntWrap(5);
    var i3 = new IntWrap(9);
    var i4 = new IntWrap(2);
    var a = [i4,i0,i1,i3,i0,i2];
    var b = a.slice(0);
    aneq(b , a);
    aeq(b , [i4, i0, i1, i3, i0, i2]);
    b = b.slice(1);
    aeq(b , [i0, i1, i3, i0, i2]);
    b = b.slice(1, 3);
    aeq(b , [i1, i3]);
    b = b.slice( -1);
    aeq(b , [i3]);
    b = b.slice(0, 4);
    aeq(b , [i3]);
    aeq(b.slice( -3) , [i3]);
    aeq(b.slice( -3, -3) , []);
    aeq([1, 2, 3].slice(2, 1) , []);

    // sort
    var i0 = new IntWrap(1);
    var i1 = new IntWrap(1);
    var i2 = new IntWrap(5);
    var i3 = new IntWrap(9);
    var i4 = new IntWrap(2);
    var a = [i4, i0, i1, i3, i0, i2];
    haxe.ds.ArraySort.sort(a, IntWrap.compare);
    aeq(a , [i0, i1, i0, i4, i2, i3]);

    // splice
    var i0 = new IntWrap(1);
    var i1 = new IntWrap(1);
    var i2 = new IntWrap(5);
    var i3 = new IntWrap(9);
    var i4 = new IntWrap(2);
    var b = [i4, i0, i1, i3, i0, i2];
    var a = b.splice(0, 0);
    aneq(b , a);
    aeq(a , []);
    aeq(b , [i4, i0, i1, i3, i0, i2]);
    a = b.splice(1, b.length - 1);
    aeq(b , [i4]);
    aeq(a , [i0, i1, i3, i0, i2]);
    b = a.splice(1, -1);
    aeq(a , [i0, i1, i3, i0, i2]);
    aeq(b , []);
    b = a.splice(0, 10);
    aeq(b , [i0, i1, i3, i0, i2]);
    aeq(a , []);
    a = b.splice(10, 10);
    aeq(a , []);
    b = [i0, i1, i3, i0, i2];
    a = b.splice( -2, 2);
    aeq(b , [i0, i1, i3]);
    aeq(a , [i0, i2]);

    // toString
    var a = [new ClassWithToString(), new ClassWithToStringChild(), new ClassWithToStringChild2()];
    var comp = "ClassWithToString.toString(),ClassWithToString.toString(),ClassWithToStringChild2.toString()";
    assert([comp, "[" + comp + "]"].contains(a.toString()));

    // unshift
    var a:Array<Null<Int>> = [];
    var b = a;
    a.unshift(1);
    aeq(a , b);
    aeq(a , [1]);
    a.unshift(2);
    aeq(a , b);
    aeq(a , [2, 1]);
    a.unshift(null);
    aeq(a , [null, 2, 1]);

    // insert
    var a = [];
    a.insert(5, 1);
    aeq(a , [1]);
    var a = [1, 2, 3];
    a.insert(1, 4);
    aeq(a , [1, 4, 2, 3]);
    var a = [1, 2, 3];
    a.insert( -1, 4);
    aeq(a , [1, 2, 4, 3]);
    a.insert( -2, 8);
    aeq(a , [1, 2, 8, 4, 3]);
    a.insert ( -8, 9);
    aeq(a , [9, 1, 2, 8, 4, 3]);

    // remove
    var i0 = new IntWrap(1);
    var i1 = new IntWrap(1);
    var i2 = new IntWrap(5);
    var i3 = new IntWrap(9);
    var i4 = new IntWrap(2);
    var a = [i4, i0, i1, i3, i0, i2];
    assert(a.remove(i0) == true);
    aeq(a , [i4, i1, i3, i0, i2]);
    assert(a.remove(i0) == true);
    aeq(a , [i4, i1, i3, i2]);
    assert(a.remove(i0) == false);
    aeq(a , [i4, i1, i3, i2]);
    var a = ["foo", "bar"];
    assert(a.remove("foo") == true);
    aeq(a , ["bar"]);
    var a = [i0, null, i1, null, null];
    assert(a.remove(null) == true);
    aeq(a , [i0, i1, null, null]);
    assert(a.remove(null) == true);
    aeq(a , [i0, i1, null]);
    assert(a.remove(null) == true);
    aeq(a , [i0, i1]);
    assert(a.remove(null) == false);
    aeq(a , [i0, i1]);

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
    aeq(b , [i0, i1, i2]);
    var a = [];
    var b = a.copy();
    assert(a != b);
    aeq(b , []);

    // map
    assert([1, 2, 3].map(function(i) return i * 2) == [2, 4, 6]);
    var a = [new IntWrap(1), new IntWrap(2)];
    var b = a.map(function(x) return x);
    assert(a != b);
    assert(b.length == a.length);
    assert(a[0] == b[0]);
    assert(a[1] == b[1]);
    var func = function(s) return s.toUpperCase();
    aeq(["foo", "bar"].map(func) , ["FOO", "BAR"]);
    aeq([].map(func) , []);

    // filter
    aeq([1, 2, 3, 4].filter(function(i) return i < 3) , [1, 2]);
    aeq([1, 2, 3, 4].filter(function(i) return true) , [1, 2, 3, 4]);
    aeq([1, 2, 3, 4].filter(function(i) return false) , []);
    aeq([].filter(function(_) return true) , []);
    aeq([].filter(function(_) return false) , []);
    var arr = [{id: 1}, {id: 2}, {id: 3}, {id: 4}, {id: 5}];
    arr = arr.filter(function(i) return i.id % 2 != 0);
    var values = [];
    for (a in arr) values.push(a.id);
    aeq(values , [1, 3, 5]);

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
    aeq(a , [1,2,3]);
    a.resize(2);
    assert(a.length == 2);
    aeq(a , [1, 2]);
    a.resize(3);
    assert(a.length == 3);
    assert(a[0] == 1);
    assert(a[1] == 2);
    assert(a[2] != 3);
    a.resize(0);
    assert(a.length == 0);
    aeq(a , []);

    // keyValueIterator
    var a : Array<Int> = [1,2,3,5,8];
    aeq([for (k=>v in a) k] , [0,1,2,3,4]);
    aeq([for (k=>v in a) v] , [1,2,3,5,8]);
    aeq([for (k=>v in a) k*v] , [0,2,6,15,32]);

    // keyValueIterator through Structure
    var a : Array<Int> = [1,2,3,5,8];
    var it : KeyValueIterator<Int, Int> = a.keyValueIterator();
    var a2 = [for (k=>v in it) k];
    aeq(a2 , [0,1,2,3,4]);
    var it : KeyValueIterator<Int, Int> = a.keyValueIterator();
    a2 = [for (k=>v in it) v];
    aeq(a2 , [1,2,3,5,8]);
    var it : KeyValueIterator<Int, Int> = a.keyValueIterator();
    a2 = [for (k=>v in it) k*v];
    aeq(a2 , [0,2,6,15,32]);

    // keyValueIterator through Structure
    var a : Array<Int> = [1,2,3,5,8];
    var it : KeyValueIterable<Int, Int> = a;
    aeq([for (k=>v in it) k] , [0,1,2,3,4]);
    aeq([for (k=>v in it) v] , [1,2,3,5,8]);
    aeq([for (k=>v in it) k*v] , [0,2,6,15,32]);

    #if !flash
    // Can't create this closure on Flash apparently
    // keyValueIterator closure because why not
    var a : Array<Int> = [1,2,3,5,8];
    var itf : () -> KeyValueIterator<Int, Int> = a.keyValueIterator;
    var it = itf();
    var a2 = [for (k=>v in it) k];
    aeq(a2 , [0,1,2,3,4]);
    var itf : () -> KeyValueIterator<Int, Int> = a.keyValueIterator;
    var it = itf();
    a2 = [for (k=>v in it) v];
    aeq(a2 , [1,2,3,5,8]);
    var itf : () -> KeyValueIterator<Int, Int> = a.keyValueIterator;
    var it = itf();
    a2 = [for (k=>v in it) k*v];
    aeq(a2 , [0,2,6,15,32]);
    #end
}