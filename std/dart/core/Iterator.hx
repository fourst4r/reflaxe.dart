package dart.core;

@:native("Iterator")
extern class Iterator<E> {
    var current:E;
    function moveNext():Bool;
}