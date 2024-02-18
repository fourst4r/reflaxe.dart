package;

import dart.math.Math as DMath;

@:coreApi
@:publicFields
class Math {
    static var PI(default, null):Float = DMath.pi;
    static var NEGATIVE_INFINITY(default, null):Float = untyped __dart__("double.negativeInfinity");
    static var POSITIVE_INFINITY(default, null):Float = untyped __dart__("double.infinity");
    static var NaN(default, null):Float = untyped __dart__("double.nan");

    static inline function abs(v:Float):Float return untyped v.abs();
    static inline function min(a:Float, b:Float):Float return DMath.min(a, b);
    static inline function max(a:Float, b:Float):Float return DMath.max(a, b);
    static inline function sin(v:Float):Float return DMath.sin(v);
    static inline function cos(v:Float):Float return DMath.cos(v);
    static inline function tan(v:Float):Float return DMath.tan(v);
    extern static function asin(v:Float):Float;
    extern static function acos(v:Float):Float;
    extern static function atan(v:Float):Float;
    extern static function atan2(y:Float, x:Float):Float;
    extern static function exp(v:Float):Float;
    extern static function log(v:Float):Float;
    extern static function pow(v:Float, exp:Float):Float;
    extern static function sqrt(v:Float):Float;

    static inline function round(v:Float):Int return untyped __dart__("{0}.round()", v);
    static inline function floor(v:Float):Int return untyped __dart__("{0}.floor()", v);
    static inline function ceil(v:Float):Int return untyped __dart__("{0}.ceil()", v);

    static function random():Float return _rand.nextDouble();
    private static var _rand = new dart.math.Random();


    static inline function ffloor(v:Float):Float return untyped __dart__("{0}.floorToDouble()", v);
    static inline function fceil(v:Float):Float return untyped __dart__("{0}.ceilToDouble()", v);
    static inline function fround(v:Float):Float return untyped __dart__("{0}.roundToDouble()", v);
    static inline function isFinite(f:Float):Bool return untyped __dart__("{0}.isFinite", v);
    static inline function isNaN(f:Float):Bool return untyped __dart__("{0}.isNaN", v);
}
