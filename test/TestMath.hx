import dart.Lib.assert;

function feq(expected:Float, value:Float, ?approx:Float) {
    if (Math.isNaN(expected))
        return Math.isNaN(value);
    else if (Math.isNaN(value))
        return false;
    else if (!Math.isFinite(expected) && !Math.isFinite(value))
        return (expected > 0) == (value > 0);
    if (null == approx)
        approx = 1e-5;
    return Math.abs(value-expected) <= approx;
}

function main() {
    // constants
    var zero = 0.0;
    var one = 1.0;
    //1.0 / zero == Math.POSITIVE_INFINITY;
    //-1.0 / zero == Math.NEGATIVE_INFINITY;
    assert((Math.NaN == Math.NaN) == false);
    assert(Math.isNaN(Math.NaN) == true);
    assert(Math.isNaN(Math.sqrt( -1)) == true);
    assert(Math.NEGATIVE_INFINITY == Math.NEGATIVE_INFINITY);
    assert(Math.POSITIVE_INFINITY == Math.POSITIVE_INFINITY);
    #if !python
    assert(Math.isNaN(0/0) == true);
    #end
    // +
    assert(Math.POSITIVE_INFINITY + Math.POSITIVE_INFINITY == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY + Math.NEGATIVE_INFINITY == Math.NEGATIVE_INFINITY);
    assert(Math.POSITIVE_INFINITY + one == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY + one == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.POSITIVE_INFINITY + Math.NEGATIVE_INFINITY) == true);
    assert(Math.isNaN(Math.POSITIVE_INFINITY + Math.NaN) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY + Math.NaN) == true);
    // -
    assert(one - Math.POSITIVE_INFINITY == Math.NEGATIVE_INFINITY);
    assert(one - Math.NEGATIVE_INFINITY == Math.POSITIVE_INFINITY);
    assert(-Math.POSITIVE_INFINITY == Math.NEGATIVE_INFINITY);
    assert(-Math.NEGATIVE_INFINITY == Math.POSITIVE_INFINITY);
    assert(Math.POSITIVE_INFINITY - one == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY - one == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.POSITIVE_INFINITY - Math.POSITIVE_INFINITY ) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY - Math.NEGATIVE_INFINITY) == true);
    assert(Math.POSITIVE_INFINITY - Math.NEGATIVE_INFINITY == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY - Math.POSITIVE_INFINITY == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.POSITIVE_INFINITY - Math.NaN) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY - Math.NaN) == true);
    assert(Math.isNaN(Math.NaN - Math.POSITIVE_INFINITY) == true);
    assert(Math.isNaN(Math.NaN - Math.NEGATIVE_INFINITY) == true);
    // *
    assert(Math.POSITIVE_INFINITY * one == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY * one == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.POSITIVE_INFINITY * zero) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY * zero) == true);
    assert(Math.POSITIVE_INFINITY * Math.POSITIVE_INFINITY == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY * Math.NEGATIVE_INFINITY  == Math.POSITIVE_INFINITY);
    assert(Math.POSITIVE_INFINITY * Math.NEGATIVE_INFINITY == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.POSITIVE_INFINITY * Math.NaN) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY * Math.NaN) == true);
    // /
    assert(Math.POSITIVE_INFINITY / one == Math.POSITIVE_INFINITY);
    assert(Math.NEGATIVE_INFINITY / one == Math.NEGATIVE_INFINITY);
    //Math.POSITIVE_INFINITY / zero == Math.POSITIVE_INFINITY);
    //Math.NEGATIVE_INFINITY / zero == Math.NEGATIVE_INFINITY;
    assert(Math.isNaN(Math.POSITIVE_INFINITY / Math.POSITIVE_INFINITY) == true);
    assert(Math.isNaN(Math.POSITIVE_INFINITY / Math.NEGATIVE_INFINITY) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY / Math.POSITIVE_INFINITY) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY / Math.NEGATIVE_INFINITY) == true);
    assert(Math.isNaN(Math.NaN / Math.POSITIVE_INFINITY) == true);
    assert(Math.isNaN(Math.POSITIVE_INFINITY / Math.NaN) == true);
    assert(Math.isNaN(Math.NaN / Math.POSITIVE_INFINITY) == true);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY / Math.NaN) == true);

    // %
    // var izero = 0;
    // Math.isNaN(1%izero) == true;
    // abs
    assert(Math.abs(-1.223) == 1.223);
    assert(Math.abs(1.223) == 1.223);
    assert(Math.abs(0) == 0);
    assert(Math.isNaN(Math.abs(Math.NaN)) == true);
    assert(Math.abs(Math.NEGATIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.abs(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);

    // min
    assert(Math.min(0.0, 1.0) == 0.0);
    assert(Math.min(0.0, -1.0) == -1.0);
    assert(Math.min(0.0, 0.0) == 0.0);
    assert(Math.min(1.0, 1.0) == 1.0);
    assert(Math.min(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY) == Math.NEGATIVE_INFINITY);
    assert(Math.min(Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY) == Math.NEGATIVE_INFINITY);
    assert(Math.min(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.min(Math.POSITIVE_INFINITY, zero) == zero);
    assert(Math.min(Math.NEGATIVE_INFINITY, zero) == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.min(Math.NEGATIVE_INFINITY, Math.NaN)) == true);
    assert(Math.isNaN(Math.min(Math.POSITIVE_INFINITY, Math.NaN)) == true);
    assert(Math.isNaN(Math.min(Math.NaN, Math.NaN)) == true);
    assert(Math.isNaN(Math.min(one, Math.NaN)) == true);
    assert(Math.isNaN(Math.min(zero, Math.NaN)) == true);
    assert(Math.isNaN(Math.min(Math.NaN, Math.NEGATIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.min(Math.NaN,Math.POSITIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.min(Math.NaN, one)) == true);
    assert(Math.isNaN(Math.min(Math.NaN, zero)) == true);

    // max
    assert(Math.max(0.0, 1.0) == 1.0);
    assert(Math.max(0.0, -1.0) == 0.0);
    assert(Math.max(0.0, 0.0) == 0.0);
    assert(Math.max(1.0, 1.0) == 1.0);
    assert(Math.max(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY) == Math.NEGATIVE_INFINITY);
    assert(Math.max(Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.max(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.max(Math.POSITIVE_INFINITY, zero) == Math.POSITIVE_INFINITY);
    assert(Math.max(Math.NEGATIVE_INFINITY, zero) == 0);
    assert(Math.isNaN(Math.max(Math.NEGATIVE_INFINITY, Math.NaN)) == true);
    assert(Math.isNaN(Math.max(Math.POSITIVE_INFINITY, Math.NaN)) == true);
    assert(Math.isNaN(Math.max(Math.NaN, Math.NaN)) == true);
    assert(Math.isNaN(Math.max(one, Math.NaN)) == true);
    assert(Math.isNaN(Math.max(zero, Math.NaN)) == true);
    assert(Math.isNaN(Math.max(Math.NaN, Math.NEGATIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.max(Math.NaN,Math.POSITIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.max(Math.NaN, one)) == true);
    assert(Math.isNaN(Math.max(Math.NaN, zero)) == true);

    // sin
    assert(Math.sin(0.0) == 0.0);
    assert(Math.sin(Math.PI / 2) == 1.0);
    // assert(Math.sin(Math.PI) == 0.0); <-- (4*): not true on javascript either
    assert(Math.sin(Math.PI * 3 / 2) == -1.0);
    assert(Math.isNaN(Math.sin(Math.POSITIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.sin(Math.NEGATIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.sin(Math.NaN)) == true);

    // cos
    assert(Math.cos(0.0) == 1.0);
    // assert(Math.cos(Math.PI / 2) == 0.0); <-- (4*): not true on javascript either
    assert(Math.cos(Math.PI) == -1.0);
    // assert(Math.cos(Math.PI * 3 / 2) == 0.0); <-- (4*): not true on javascript either
    assert(Math.isNaN(Math.cos(Math.POSITIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.cos(Math.NEGATIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.cos(Math.NaN)) == true);

    // exp
    assert(Math.exp(0.0) == 1.0);
    assert(Math.exp(1.0) == 2.7182818284590452353602874713527);
    assert(Math.exp(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.exp(Math.NEGATIVE_INFINITY) == 0.0);
    assert(Math.isNaN(Math.exp(Math.NaN)) == true);

    // log
    assert(Math.log(0.0) == Math.NEGATIVE_INFINITY);
    assert(Math.log(2.7182818284590452353602874713527) == 1.0);
    assert(Math.isNaN(Math.log( -1.0)) == true);
    assert(Math.isNaN(Math.log(Math.NaN)) == true);
    assert(Math.isNaN(Math.log(Math.NEGATIVE_INFINITY)) == true);
    assert(Math.log(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);

    // exp + log
    var floats = [1.33, 12.0, -112.999992, 0.0, Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY];
    for (f in floats) {
        feq(Math.log(Math.exp(f)), f);
    }

    // sqrt
    assert(Math.sqrt(4.0) == 2);
    assert(Math.sqrt(0.0) == 0.0);
    assert(Math.sqrt(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.isNaN(Math.sqrt(Math.NEGATIVE_INFINITY)) == true);
    assert(Math.isNaN(Math.sqrt(Math.NaN)) == true);
    assert(Math.isNaN(Math.sqrt( -1.0)) == true);

    // round
    assert(Math.round(0.0) == 0);
    assert(Math.round(0.1) == 0);
    assert(Math.round(0.4999) == 0);
    assert(Math.round(0.5) == 1);
    assert(Math.round(1.0) == 1);
    assert(Math.round(1.499) == 1);
    assert(Math.round(-0.1) == 0);
    assert(Math.round(-0.4999) == 0);
    assert(Math.round(-0.5) == 0);
    assert(Math.round(-0.50001) == -1);
    assert(Math.round(-1.0) == -1);
    assert(Math.round(-1.499) == -1);
    assert(Math.round(-1.5) == -1);
    assert(Math.round( -1.50001) == -2);
    assert(Math.fround(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.fround(Math.NEGATIVE_INFINITY) == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.fround(Math.NaN)) == true);
    assert(Math.fround(0.0) == 0.0);
    assert(Math.fround(0.1) == 0.0);
    assert(Math.fround(0.4999) == 0.0);
    assert(Math.fround(0.5) == 1.0);
    assert(Math.fround(1.0) == 1.0);
    assert(Math.fround(1.499) == 1.0);
    assert(Math.fround(1.5) == 2.0);
    assert(Math.fround(-0.1) == -0.0);
    assert(Math.fround(-0.4999) == -0.0);
    assert(Math.fround(-0.5) == -0.0);
    assert(Math.fround(-0.50001) == -1.0);
    assert(Math.fround(-1.0) == -1.0);
    assert(Math.fround(-1.499) == -1.0);
    assert(Math.fround(-1.5) == -1.0);
    assert(Math.fround( -1.50001) == -2.0);

    // floor
    assert(Math.floor(0.0) == 0);
    assert(Math.floor(0.9999) == 0);
    assert(Math.floor(1.0) == 1);
    assert(Math.floor( -0.0001) == -1);
    assert(Math.floor( -1.0) == -1);
    assert(Math.floor( -1.0001) == -2);
    assert(Math.ffloor(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.ffloor(Math.NEGATIVE_INFINITY) == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.ffloor(Math.NaN)) == true);

    // ceil
    assert(Math.ceil(0.0) == 0);
    assert(Math.ceil(-0.9999) == 0);
    assert(Math.ceil(-1.0) == -1);
    assert(Math.ceil( 0.0001) == 1);
    assert(Math.ceil( 1.0) == 1);
    assert(Math.ceil( 1.0001) == 2);
    assert(Math.fceil(Math.POSITIVE_INFINITY) == Math.POSITIVE_INFINITY);
    assert(Math.fceil(Math.NEGATIVE_INFINITY) == Math.NEGATIVE_INFINITY);
    assert(Math.isNaN(Math.fceil(Math.NaN)) == true);

    // random
    // not much to test here...

    // isFinite
    assert(Math.isFinite(Math.POSITIVE_INFINITY) == false);
    assert(Math.isFinite(Math.NEGATIVE_INFINITY) == false);
    assert(Math.isFinite(Math.NaN) == false);
    assert(Math.isFinite(0.0) == true);

    // isNaN
    assert(Math.isNaN(Math.POSITIVE_INFINITY) == false);
    assert(Math.isNaN(Math.NEGATIVE_INFINITY) == false);
    assert(Math.isNaN(Math.NaN) == true);
    assert(Math.isNaN(0.0) == false);


    // Dynamic version
    var math = Math;


    //1.0 / zero == math.POSITIVE_INFINITY;
    //-1.0 / zero == math.NEGATIVE_INFINITY;
    assert((math.NaN == math.NaN) == false);
    assert(math.isNaN(math.NaN) == true);
    assert(math.isNaN(math.sqrt( -1)) == true);
    assert(math.NEGATIVE_INFINITY == math.NEGATIVE_INFINITY);
    assert(math.POSITIVE_INFINITY == math.POSITIVE_INFINITY);
    // +
    assert(math.POSITIVE_INFINITY + math.POSITIVE_INFINITY == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY + math.NEGATIVE_INFINITY == math.NEGATIVE_INFINITY);
    assert(math.POSITIVE_INFINITY + one == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY + one == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.POSITIVE_INFINITY + math.NEGATIVE_INFINITY) == true);
    assert(math.isNaN(math.POSITIVE_INFINITY + math.NaN) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY + math.NaN) == true);
    // -
    assert(one - math.POSITIVE_INFINITY == math.NEGATIVE_INFINITY);
    assert(one - math.NEGATIVE_INFINITY == math.POSITIVE_INFINITY);
    assert(-math.POSITIVE_INFINITY == math.NEGATIVE_INFINITY);
    assert(-math.NEGATIVE_INFINITY == math.POSITIVE_INFINITY);
    assert(math.POSITIVE_INFINITY - one == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY - one == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.POSITIVE_INFINITY - math.POSITIVE_INFINITY ) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY - math.NEGATIVE_INFINITY) == true);
    assert(math.POSITIVE_INFINITY - math.NEGATIVE_INFINITY == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY - math.POSITIVE_INFINITY == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.POSITIVE_INFINITY - math.NaN) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY - math.NaN) == true);
    assert(math.isNaN(math.NaN - math.POSITIVE_INFINITY) == true);
    assert(math.isNaN(math.NaN - math.NEGATIVE_INFINITY) == true);
    // *
    assert(math.POSITIVE_INFINITY * one == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY * one == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.POSITIVE_INFINITY * zero) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY * zero) == true);
    assert(math.POSITIVE_INFINITY * math.POSITIVE_INFINITY == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY * math.NEGATIVE_INFINITY  == math.POSITIVE_INFINITY);
    assert(math.POSITIVE_INFINITY * math.NEGATIVE_INFINITY == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.POSITIVE_INFINITY * math.NaN) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY * math.NaN) == true);
    // /
    assert(math.POSITIVE_INFINITY / one == math.POSITIVE_INFINITY);
    assert(math.NEGATIVE_INFINITY / one == math.NEGATIVE_INFINITY);
    //math.POSITIVE_INFINITY / zero == math.POSITIVE_INFINITY;
    //math.NEGATIVE_INFINITY / zero == math.NEGATIVE_INFINITY;
    assert(math.isNaN(math.POSITIVE_INFINITY / math.POSITIVE_INFINITY) == true);
    assert(math.isNaN(math.POSITIVE_INFINITY / math.NEGATIVE_INFINITY) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY / math.POSITIVE_INFINITY) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY / math.NEGATIVE_INFINITY) == true);
    assert(math.isNaN(math.NaN / math.POSITIVE_INFINITY) == true);
    assert(math.isNaN(math.POSITIVE_INFINITY / math.NaN) == true);
    assert(math.isNaN(math.NaN / math.POSITIVE_INFINITY) == true);
    assert(math.isNaN(math.NEGATIVE_INFINITY / math.NaN) == true);

    // abs
    assert(math.abs(-1.223) == 1.223);
    assert(math.abs(1.223) == 1.223);
    assert(math.abs(0) == 0);
    assert(math.isNaN(math.abs(math.NaN)) == true);
    assert(math.abs(math.NEGATIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.abs(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);

    // min
    assert(math.min(0.0, 1.0) == 0.0);
    assert(math.min(0.0, -1.0) == -1.0);
    assert(math.min(0.0, 0.0) == 0.0);
    assert(math.min(1.0, 1.0) == 1.0);
    assert(math.min(math.NEGATIVE_INFINITY, math.NEGATIVE_INFINITY) == math.NEGATIVE_INFINITY);
    assert(math.min(math.NEGATIVE_INFINITY, math.POSITIVE_INFINITY) == math.NEGATIVE_INFINITY);
    assert(math.min(math.POSITIVE_INFINITY, math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.min(math.POSITIVE_INFINITY, zero) == zero);
    assert(math.min(math.NEGATIVE_INFINITY, zero) == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.min(math.NEGATIVE_INFINITY, math.NaN)) == true);
    assert(math.isNaN(math.min(math.POSITIVE_INFINITY, math.NaN)) == true);
    assert(math.isNaN(math.min(math.NaN, math.NaN)) == true);
    assert(math.isNaN(math.min(one, math.NaN)) == true);
    assert(math.isNaN(math.min(zero, math.NaN)) == true);
    assert(math.isNaN(math.min(math.NaN, math.NEGATIVE_INFINITY)) == true);
    assert(math.isNaN(math.min(math.NaN,math.POSITIVE_INFINITY)) == true);
    assert(math.isNaN(math.min(math.NaN, one)) == true);
    assert(math.isNaN(math.min(math.NaN, zero)) == true);

    // max
    assert(math.max(0.0, 1.0) == 1.0);
    assert(math.max(0.0, -1.0) == 0.0);
    assert(math.max(0.0, 0.0) == 0.0);
    assert(math.max(1.0, 1.0) == 1.0);
    assert(math.max(math.NEGATIVE_INFINITY, math.NEGATIVE_INFINITY) == math.NEGATIVE_INFINITY);
    assert(math.max(math.NEGATIVE_INFINITY, math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.max(math.POSITIVE_INFINITY, math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.max(math.POSITIVE_INFINITY, zero) == math.POSITIVE_INFINITY);
    assert(math.max(math.NEGATIVE_INFINITY, zero) == 0);
    assert(math.isNaN(math.max(math.NEGATIVE_INFINITY, math.NaN)) == true);
    assert(math.isNaN(math.max(math.POSITIVE_INFINITY, math.NaN)) == true);
    assert(math.isNaN(math.max(math.NaN, math.NaN)) == true);
    assert(math.isNaN(math.max(one, math.NaN)) == true);
    assert(math.isNaN(math.max(zero, math.NaN)) == true);
    assert(math.isNaN(math.max(math.NaN, math.NEGATIVE_INFINITY)) == true);
    assert(math.isNaN(math.max(math.NaN,math.POSITIVE_INFINITY)) == true);
    assert(math.isNaN(math.max(math.NaN, one)) == true);
    assert(math.isNaN(math.max(math.NaN, zero)) == true);

    // sin
    assert(math.sin(0.0) == 0.0);
    assert(math.sin(math.PI / 2) == 1.0);
    // assert(math.sin(math.PI) == 0.0); <-- (4*): not true on javascript either
    assert(math.sin(math.PI * 3 / 2) == -1.0);
    assert(math.isNaN(math.sin(math.POSITIVE_INFINITY)) == true);
    assert(math.isNaN(math.sin(math.NEGATIVE_INFINITY)) == true);
    assert(math.isNaN(math.sin(math.NaN)) == true);

    // cos
    assert(math.cos(0.0) == 1.0);
    // assert(math.cos(math.PI / 2) == 0.0); <-- (4*): not true on javascript either
    assert(math.cos(math.PI) == -1.0);
    // assert(math.cos(math.PI * 3 / 2) == 0.0); <-- (4*): not true on javascript either
    assert(math.isNaN(math.cos(math.POSITIVE_INFINITY)) == true);
    assert(math.isNaN(math.cos(math.NEGATIVE_INFINITY)) == true);
    assert(math.isNaN(math.cos(math.NaN)) == true);

    // exp
    assert(math.exp(0.0) == 1.0);
    assert(math.exp(1.0) == 2.7182818284590452353602874713527);
    assert(math.exp(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.exp(math.NEGATIVE_INFINITY) == 0.0);
    assert(math.isNaN(math.exp(math.NaN)) == true);

    // log
    assert(math.log(0.0) == math.NEGATIVE_INFINITY);
    assert(math.log(2.7182818284590452353602874713527) == 1.0);
    assert(math.isNaN(math.log( -1.0)) == true);
    assert(math.isNaN(math.log(math.NaN)) == true);
    assert(math.isNaN(math.log(math.NEGATIVE_INFINITY)) == true);
    assert(math.log(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);

    // exp + log
    var floats = [1.33, 12.0, -112.999992, 0.0, math.NEGATIVE_INFINITY, math.POSITIVE_INFINITY];
    for (f in floats) {
        feq(math.log(math.exp(f)), f);
    }

    // sqrt
    assert(math.sqrt(4.0) == 2);
    assert(math.sqrt(0.0) == 0.0);
    assert(math.sqrt(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.isNaN(math.sqrt(math.NEGATIVE_INFINITY)) == true);
    assert(math.isNaN(math.sqrt(math.NaN)) == true);
    assert(math.isNaN(math.sqrt( -1.0)) == true);

    // round
    assert(math.round(0.0) == 0);
    assert(math.round(0.1) == 0);
    assert(math.round(0.4999) == 0);
    assert(math.round(0.5) == 1);
    assert(math.round(1.0) == 1);
    assert(math.round(1.499) == 1);
    assert(math.round(-0.1) == 0);
    assert(math.round(-0.4999) == 0);
    assert(math.round(-0.5) == 0);
    assert(math.round(-0.50001) == -1);
    assert(math.round(-1.0) == -1);
    assert(math.round(-1.499) == -1);
    assert(math.round(-1.5) == -1);
    assert(math.round( -1.50001) == -2);
    assert(math.fround(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.fround(math.NEGATIVE_INFINITY) == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.fround(math.NaN)) == true);

    // floor
    assert(math.floor(0.0) == 0);
    assert(math.floor(0.9999) == 0);
    assert(math.floor(1.0) == 1);
    assert(math.floor( -0.0001) == -1);
    assert(math.floor( -1.0) == -1);
    assert(math.floor( -1.0001) == -2);
    assert(math.ffloor(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.ffloor(math.NEGATIVE_INFINITY) == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.ffloor(math.NaN)) == true);

    // ceil
    assert(math.ceil(0.0) == 0);
    assert(math.ceil(-0.9999) == 0);
    assert(math.ceil(-1.0) == -1);
    assert(math.ceil( 0.0001) == 1);
    assert(math.ceil( 1.0) == 1);
    assert(math.ceil( 1.0001) == 2);
    assert(math.fceil(math.POSITIVE_INFINITY) == math.POSITIVE_INFINITY);
    assert(math.fceil(math.NEGATIVE_INFINITY) == math.NEGATIVE_INFINITY);
    assert(math.isNaN(math.fceil(math.NaN)) == true);

    // random
    // not much to test here...

    // isFinite
    assert(math.isFinite(math.POSITIVE_INFINITY) == false);
    assert(math.isFinite(math.NEGATIVE_INFINITY) == false);
    assert(math.isFinite(math.NaN) == false);
    assert(math.isFinite(0.0) == true);

    // isNaN
    assert(math.isNaN(math.POSITIVE_INFINITY) == false);
    assert(math.isNaN(math.NEGATIVE_INFINITY) == false);
    assert(math.isNaN(math.NaN) == true);
    assert(math.isNaN(0.0) == false);

    // atan2
    assert(math.atan2(0,1) == 0);
    assert(math.atan2(0,1000) == 0);
    assert(math.atan2(1,0) == Math.PI/2);
    assert(math.atan2(-1,0) == -Math.PI/2);
    assert(math.atan2(0,0) == 0);
}