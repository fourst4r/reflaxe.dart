package dart.core;

@:dart.mixin
@:native("Iterable")
extern interface Iterable<E> {
    var first(default, never):E;
    var iterator(default, never):dart.core.Iterator<E>;
    var isEmpty(default, never):Bool;
    var isNotEmpty(default, never):Bool;
    var last(default, never):E;
    var length(default, never):Int;
    var single(default, never):E;
    function contains(element:Dynamic):Bool;
    function join(separator:String = ""):String;
    function map<T>(toElement:E->T):dart.core.Iterable<T>;
    function toList(growable:Bool = true):List<E>;
}