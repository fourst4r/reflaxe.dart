package dart.core;

@:native("List")
extern class List<E> implements ArrayAccess<E> implements dart.core.Iterable<E> {
    var reversed(default, never):dart.core.Iterable<E>;
    function new();
    function add(value:E):Void;
    // function addAll(value:E):Void;
    // @:nativeFunctionCode("{this} + {arg0}")
    inline function concat(l:List<E>):List<E>
        return untyped __dart__("({0} + {1})", this, l);
    function fillRange(start:Int, end:Int, ?fillValue:E):Void;
    function indexOf(element:E, start:Int = 0):Int;
    function remove(value:Dynamic):Bool;
    function removeLast():E;
    function removeRange(start:Int, end:Int):Void;
    function sublist(start:Int, ?end:Int):List<E>;

    // Iterable mixin
    var first(default, never):E;
    var iterator(default, never):dart.core.Iterator<E>;
    var isEmpty(default, never):Bool;
    var isNotEmpty(default, never):Bool;
    var last(default, never):E;
    var length(default, default):Int;
    var single(default, never):E;
    function contains(element:Dynamic):Bool;
    function join(separator:String = ""):String;
    function map<T>(toElement:E->T):dart.core.Iterable<T>;
    function toList(growable:Bool = true):List<E>;
}