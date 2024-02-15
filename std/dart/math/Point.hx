package dart.math;

@:dart.import("dart:math")
extern class Point<T:Float> {
    function new(x:T, y:T);
    var x(default, never):T;
    var y(default, never):T;
    var magnitude(default, never):Float;
    function distanceTo(other:Point<T>):Float;
    function squaredDistanceTo(other:Point<T>):T;
    inline function mul(factor:T) return untyped __dart__("({0} * {1})", this, factor);
}