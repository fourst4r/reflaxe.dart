package;


/**
    An Array is a storage for values. You can access it using indexes or
    with its API.

    @see https://haxe.org/manual/std-Array.html
    @see https://haxe.org/manual/lf-array-comprehension.html
**/

import haxe.iterators.ArrayKeyValueIterator;

@:access(Array)
private class ArrayImpl {
    public static function push<T>(a:Array<T>, value:T):Int {
        a._a.add(value);
        return a.length = a._a.length;
    }

    public static function pop<T>(a:Array<T>):Null<T> {
        final result = a.length > 0 ? a._a.removeLast() : null;
        a.length = a._a.length;
        return result;
    }

    public static function shift<T>(a:Array<T>):Null<T> {
        if (a.length == 0)
            return null;
        final result = a._a.removeAt(0);
        a.length = a._a.length;
        return result;
    }

    public static function splice<T>(a:Array<T>, pos:Int, len:Int):Array<T> {
        if (len < 0 || pos > a.length)
            return [];
        if (pos < 0)
            pos += a.length;
        if (pos < 0)
            pos = 0;
        if (pos+len > a.length)
            len = a.length-pos;
        final result = a._a.sublist(pos, pos+len);
        a._a.removeRange(pos, pos+len);
        a.length = a._a.length;
        return Array.fromList(result);
    }

    public static function slice<T>(a:Array<T>, pos:Int, ?end:Int):Array<T> {
        var len = a.length;
        if (len <= 0)
            return [];
        end ??= len;
        if (pos < 0)
            pos = (-pos > len) ? 0 : (len+pos);
        end = (end > len) ? len : end;
        if (end < 0)
            end += len;
        if (end < 0)
            end = 0;
        if (pos >= len || end <= pos)
            return [];
        return Array.fromList(a._a.sublist(pos, end));
    }
}

final class Array<T> implements ArrayAccess<T> {
    
    public var length(default, null):Int = 0;

    var _a:dart.core.List<T>;

    @:nativeName("operator []")
    function opGetIndex(i:Int):T {
        return _a[i];
    }

    @:nativeName("operator []=")
    function opSetIndex(i:Int, value:T):Void {
        if (i >= length)
            _a.length = i+1;
        _a[i] = value;
        length = _a.length;
    }

    public function new() {
        _a = untyped __dart__("[]");
    }

    // @:native("Array.blank")
    // static inline function blank<T>():Array<T> {}

    static function fromList<T>(list:dart.core.List<T>):Array<T> {
        final a = new Array();
        a._a = list;
        a.length = list.length;
        return a;
    }

    public function concat(a:Array<T>):Array<T>
        return fromList(this._a.concat(a._a));

    public inline function join(sep:String):String
        return _a.join(sep);

    public inline function pop():Null<T>
        return ArrayImpl.pop(this);

    public inline function push(x:T):Int
        return ArrayImpl.push(this, x);

    public inline function reverse():Void
        _a = _a.reversed.toList();
    
    public inline function shift():Null<T>
        return ArrayImpl.shift(this);

    public inline function slice(pos:Int, ?end:Int):Array<T>
        return ArrayImpl.slice(this, pos, end);

    @:nativeName("_a.sort") public extern function sort(f:T->T->Int):Void;

    public function splice(pos:Int, len:Int):Array<T>
        return ArrayImpl.splice(this, pos, len);
    
    public inline function toString():String
        return untyped _a.toString();
    @:nativeFunctionCode("{this}._a.insert(0, {arg0})")
    public extern function unshift(x:T):Void;
    @:nativeName("_a.insert") public extern function insert(pos:Int, x:T):Void;
    @:nativeName("_a.remove") public extern function remove(x:T):Bool;

    @:pure public inline function contains( x : T ) : Bool
        return _a.contains(x);
    
    @:nativeName("_a.indexOf") public extern function indexOf(x:T, ?fromIndex:Int):Int;
    @:nativeName("_a.lastIndexOf") public extern function lastIndexOf(x:T, ?fromIndex:Int):Int;

    public function copy():Array<T> {
        return fromList(untyped __dart__("[...{0}._a]", this));
    }

    
    // public inline function iterator() {

    // }

    /**
        Returns an iterator of the Array values.
    **/
    @:runtime public inline function iterator():haxe.iterators.ArrayIterator<T> {
        return new haxe.iterators.ArrayIterator(this);
    }

    /**
        Returns an iterator of the Array indices and values.
    **/
    @:pure @:runtime public inline function keyValueIterator() : ArrayKeyValueIterator<T> {
        return new ArrayKeyValueIterator(this);
    }

    /**
        Creates a new Array by applying function `f` to all elements of `this`.

        The order of elements is preserved.

        If `f` is null, the result is unspecified.
    **/
    @:runtime public inline function map<S>(f:T->S):Array<S> {
        return [for (v in this) f(v)];
    }

    /**
        Returns an Array containing those elements of `this` for which `f`
        returned true.

        The individual elements are not duplicated and retain their identity.

        If `f` is null, the result is unspecified.
    **/
    @:runtime public inline function filter(f:T->Bool):Array<T> {
        return [for (v in this) if (f(v)) v];
    }

    /**
        Set the length of the Array.

        If `len` is shorter than the array's current size, the last
        `length - len` elements will be removed. If `len` is longer, the Array
        will be extended, with new elements set to a target-specific default
        value:

        - always null on dynamic targets
        - 0, 0.0 or false for Int, Float and Bool respectively on static targets
        - null for other types on static targets
    **/
    @:nativeFunctionCode("{this}._a.length = {arg0}")
    public extern function resize(len:Int):Void;
}

/**
    An Array is a storage for values. You can access it using indexes or
    with its API.

    @see https://haxe.org/manual/std-Array.html
    @see https://haxe.org/manual/lf-array-comprehension.html
**/

// import haxe.iterators.ArrayKeyValueIterator;

// @:coreApi
// @:native("List")
// extern class Array<T> {
    
// 	var length(default, null):Int;

// 	@:native("[]")
// 	function new();

//     @:nativeFunctionCode("({this} + {arg0})")
// 	inline function concat(a:Array<T>):Array<T>
// 		return untyped __dart__("({1} + {1})", this, a);

// 	function join(sep:String):String;

// 	inline function pop():Null<T>
//         return length > 0 ? untyped this.removeLast() : null;

// 	inline function push(x:T):Int {
//         untyped this.add(x);
//         return length;
//     }

//     @:nativeFunctionCode("{this} = {this}.reversed.toList()")
// 	function reverse():Void;
// 	inline function shift():Null<T>
// 		return untyped this.removeAt(0);
//     @:nativeName("sublist")
// 	function slice(pos:Int, ?end:Int):Array<T>;
// 	function sort(f:T->T->Int):Void;

// 	inline function splice(pos:Int, len:Int):Array<T> {
//         final result = slice(pos, pos+len);
//         untyped this.removeRange(pos, pos+len);
//         return result;
//     }
    
//     function toString():String;
//     @:nativeFunctionCode("{this}.insert(0, {arg0})")
// 	function unshift(x:T):Void;
// 	function insert(pos:Int, x:T):Void;
// 	function remove(x:T):Bool;
// 	@:pure function contains( x : T ) : Bool;
// 	function indexOf(x:T, ?fromIndex:Int):Int;
// 	function lastIndexOf(x:T, ?fromIndex:Int):Int;
//     @:nativeFunctionCode("[...{this}]")
// 	function copy():Array<T>;

// 	/**
// 		Returns an iterator of the Array values.
// 	**/
//     @:nativeName("hxiterator")
// 	@:runtime inline function iterator():haxe.iterators.ArrayIterator<T> {
// 		return new haxe.iterators.ArrayIterator(this);
// 	}

// 	/**
// 		Returns an iterator of the Array indices and values.
// 	**/
// 	@:pure @:runtime inline function keyValueIterator() : ArrayKeyValueIterator<T> {
// 		return new ArrayKeyValueIterator(this);
// 	}

// 	/**
// 		Creates a new Array by applying function `f` to all elements of `this`.

// 		The order of elements is preserved.

// 		If `f` is null, the result is unspecified.
// 	**/
// 	@:runtime inline function map<S>(f:T->S):Array<S> {
// 		return [for (v in this) f(v)];
// 	}

// 	/**
// 		Returns an Array containing those elements of `this` for which `f`
// 		returned true.

// 		The individual elements are not duplicated and retain their identity.

// 		If `f` is null, the result is unspecified.
// 	**/
// 	@:runtime inline function filter(f:T->Bool):Array<T> {
// 		return [for (v in this) if (f(v)) v];
// 	}

// 	/**
// 		Set the length of the Array.

// 		If `len` is shorter than the array's current size, the last
// 		`length - len` elements will be removed. If `len` is longer, the Array
// 		will be extended, with new elements set to a target-specific default
// 		value:

// 		- always null on dynamic targets
// 		- 0, 0.0 or false for Int, Float and Bool respectively on static targets
// 		- null for other types on static targets
// 	**/
//     @:nativeFunctionCode("{this}.length = {arg0}")
// 	function resize(len:Int):Void;
// }
