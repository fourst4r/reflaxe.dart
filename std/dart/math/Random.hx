package dart.math;

@:dart.import("dart:math")
extern class Random {
    function new(?seed:Int);
    static function secure():Random;
    function nextBool():Bool;
    function nextDouble():Float;
    function nextInt(max:Int):Int;
}