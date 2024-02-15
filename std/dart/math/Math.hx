package dart.math;

@:dart.import("dart:math")
@:dart.topLevel
extern class Math {
    static final e:Float;
    static final ln10:Float;
    static final ln2:Float;
    static final log10e:Float;
    static final log2e:Float;
    static final pi:Float;
    static final sqrt1_2:Float;
    static final sqrt2:Float;
    static function acos(x:Float):Float;
    static function asin(x:Float):Float;
    static function atan(x:Float):Float;
    static function atan2(a:Float, b:Float):Float;
    static function cos(radians:Float):Float;
    static function exp(x:Float):Float;
    static function log(x:Float):Float;
    static function max<T:Float>(a:T, b:T):T;
    static function min<T:Float>(a:T, b:T):T;
    static function pow(x:Float, exponent:Float):Float;
    static function sin(radians:Float):Float;
    static function sqrt(x:Float):Float;
    static function tan(radians:Float):Float;
}