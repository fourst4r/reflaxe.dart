package;

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

    public static function indexOf<T>(a:Array<T>, x:T, ?fromIndex:Int):Int {
        var start:Int;
        if (fromIndex != null) {
            start = fromIndex;
            if (start < 0)
                start += a.length;
            if (start < 0)
                start = 0;
            else if (start >= a.length)
                return -1;
        } else {
            start = 0;
        }
        return a._a.indexOf(x, start);
    }

    public static function lastIndexOf<T>(a:Array<T>, x:T, ?fromIndex:Int):Int {
        var start:Int;
        if (fromIndex != null) {
            start = fromIndex;
            if (start < 0)
                start += a.length;
            if (start >= a.length)
                start = a.length-1;
        } else {
            start = a.length-1;
        }
        if (start < 0)
            return -1;
        return a._a.lastIndexOf(x, start);
    }

    public static function insert<T>(a:Array<T>, pos:Int, x:T):Void {
        if (pos > a.length)
            pos = a.length;
        else {
            if (pos < 0)
                pos += a.length;
            if (pos < 0)
                pos = 0;
        }
        a._a.insert(pos, x);
        a.length = a._a.length;
    }

    public static function resize<T>(a:Array<T>, len:Int):Void {
        a.length = a._a.length = len;
    }

    public static function remove<T>(a:Array<T>, x:T):Bool {
        final result = a._a.remove(x);
        a.length = a._a.length;
        return result;
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

    public inline function splice(pos:Int, len:Int):Array<T>
        return ArrayImpl.splice(this, pos, len);
    
    public inline function toString():String
        return untyped _a.toString();

    public inline function unshift(x:T):Void
        return _a.insert(0, x);

    public inline function insert(pos:Int, x:T):Void
        ArrayImpl.insert(this, pos, x);
    
    public inline function remove(x:T):Bool
        return ArrayImpl.remove(this, x);

    @:pure public inline function contains( x : T ) : Bool
        return _a.contains(x);
    
    public inline function indexOf(x:T, ?fromIndex:Int):Int
        return ArrayImpl.indexOf(this, x, fromIndex);

    public inline function lastIndexOf(x:T, ?fromIndex:Int):Int
        return ArrayImpl.lastIndexOf(this, x, fromIndex);

    public function copy():Array<T> {
        return fromList(untyped __dart__("[...{0}._a]", this));
    }

    @:runtime public inline function iterator():haxe.iterators.ArrayIterator<T> {
        return new haxe.iterators.ArrayIterator(this);
    }

    @:pure @:runtime public inline function keyValueIterator() : ArrayKeyValueIterator<T> {
        return new ArrayKeyValueIterator(this);
    }

    @:runtime public inline function map<S>(f:T->S):Array<S> {
        return [for (v in this) f(v)];
    }

    @:runtime public inline function filter(f:T->Bool):Array<T> {
        return [for (v in this) if (f(v)) v];
    }

    public inline function resize(len:Int):Void
        ArrayImpl.resize(this, len);
}