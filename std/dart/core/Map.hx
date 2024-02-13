package dart.core;

import dart.core.Iterable as DartIterable;

@:native("Map")
extern class Map<K, V> implements ArrayAccess<V> {
    static function of<K, V>(other:Map<K, V>):Map<K, V>;
    var keys(default, never):DartIterable<K>;
    var values(default, never):DartIterable<V>;
    function new();
    function clear():Void;
    function containsKey(key:K):Bool;
    function containsValue(value:V):Bool;
    function remove(key:K):Null<V>;
}