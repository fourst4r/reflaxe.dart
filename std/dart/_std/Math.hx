package;


@:coreApi
@:publicFields
class Math {
    @:nativeName("pi")
    static var PI(default, null):Float;
    static var NEGATIVE_INFINITY(default, null):Float = untyped __dart__("double.negativeInfinity");
    static var POSITIVE_INFINITY(default, null):Float = untyped __dart__("double.infinity");
    static var NaN(default, null):Float = untyped __dart__("double.nan");

    static inline function abs(v:Float):Float
        return untyped __dart__("{0}.abs()", v);

    static inline function min(a:Float, b:Float):Float
        return dart.math.Math.min(a, b);
    extern static function max(a:Float, b:Float):Float;
    extern static function sin(v:Float):Float;
    extern static function cos(v:Float):Float;
    extern static function tan(v:Float):Float;
    extern static function asin(v:Float):Float;
    extern static function acos(v:Float):Float;
    extern static function atan(v:Float):Float;
    extern static function atan2(y:Float, x:Float):Float;
    extern static function exp(v:Float):Float;
    extern static function log(v:Float):Float;
    extern static function pow(v:Float, exp:Float):Float;
    extern static function sqrt(v:Float):Float;

    static function round(v:Float):Int
        return untyped __dart__("{0}.round()", v);

    static function floor(v:Float):Int
        return untyped __dart__("{0}.floor()", v);

    static function ceil(v:Float):Int
        return untyped __dart__("{0}.ceil()", v);

    extern static function random():Float; // impl

    static function ffloor(v:Float):Float
        return untyped __dart__("{0}.floorToDouble()", v);

    static function fceil(v:Float):Float
        return untyped __dart__("{0}.ceilToDouble()", v);

    static function fround(v:Float):Float
        return untyped __dart__("{0}.roundToDouble()", v);

    static function isFinite(f:Float):Bool
        return untyped __dart__("{0}.isFinite", v);

    static function isNaN(f:Float):Bool
        return untyped __dart__("{0}.isNaN", v);
}
