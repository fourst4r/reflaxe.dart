import dart.Lib.assert;

import unit.*;
import unit.spec.TestSpecification;

enum SomeEnum<T> {
	NoArguments;
	OneArgument(t:T);
}

function unspec( f : () -> Void, ?pos ) {
    try {
        f();
    } catch( e : Dynamic ) {
    }
}

@:nullSafety(Strict)
function main() {

    // is
    var known:Null<String> = null;
    assert((known is String) == false);

    var unknown = null;
    assert((unknown is String) == false);
    assert((null is String) == false);
    //("foo" is null) == false;

    assert(("" is String) == true);
    assert((false is Bool) == true);
    assert((1 is Int) == true);
    assert((1.5 is Int) == false);
    assert((1.5 is Float) == true);
    assert(([] is Array) == true);
    assert((cast unit.MyEnum.A is Array) == false);

    // isOfType
    var known:Null<String> = null;
    assert(Std.isOfType(known, String) == false);

    var unknown = null;
    assert(Std.isOfType(unknown, String) == false);
    assert(Std.isOfType(null, String) == false);
    //Std.isOfType("foo", null) == false;

    assert(Std.isOfType("", String) == true);
    assert(Std.isOfType(false, Bool) == true);
    assert(Std.isOfType(1, Int) == true);
    assert(Std.isOfType(1.5, Int) == false);
    assert(Std.isOfType(1.5, Float) == true);
    assert(Std.isOfType([], Array) == true);
    assert(Std.isOfType(cast unit.MyEnum.A, Array) == false);

    // instance
    #if !js
    assert(Std.downcast("", String) == "");
    #end
    var a = [];
    assert(Std.downcast(a, Array) == a);
    var parent:unit.MyClass.MyParent = new MyClass.MyChild1();
    Std.downcast(parent, unit.MyClass.MyChild1) != null;
    assert(Std.downcast(null, Array) == null);
    assert(Std.downcast(null, String) == null);

    var parent:unit.MyClass.IMyParent = new MyClass.MyChild1();
    Std.downcast(parent, unit.MyClass.IMyChild) != null;

    // string
    var cwts = new ClassWithToString();
    var cwtsc = new ClassWithToStringChild();
    var cwtsc2 = new ClassWithToStringChild2();

    assert(Std.string(cwts) == "ClassWithToString.toString()");
    assert(Std.string(cwtsc) == "ClassWithToString.toString()");
    assert(Std.string(cwtsc2) == "ClassWithToStringChild2.toString()");

    assert(Std.string(SomeEnum.NoArguments) == "NoArguments");
    assert(Std.string(SomeEnum.OneArgument("foo")) == "OneArgument(foo)");

    assert(Std.string(null) == "null");

    // int
    assert(Std.int(-1.7) == -1);
    assert(Std.int(-1.2) == -1);
    assert(Std.int(1.7) == 1);
    assert(Std.int(1.2) == 1);
    assert(Std.int(-0.7) == 0);
    assert(Std.int(-0.2) == 0);
    assert(Std.int(0.7) == 0);
    assert(Std.int(0.2) == 0);

    // parseInt

    // general
    assert(Std.parseInt("0") == 0);
    assert(Std.parseInt("-1") == -1);
    // preceeding zeroes
    assert(Std.parseInt("0001") == 1);
    assert(Std.parseInt("0010") == 10);
    // trailing text
    assert(Std.parseInt("100x123") == 100);
    assert(Std.parseInt("12foo13") == 12);
    assert(Std.parseInt("23e2") == 23);
    assert(Std.parseInt("0x10z") == 16);
    assert(Std.parseInt("0x10x123") == 16);
    assert(Std.parseInt("0xff\n") == 255);
    // hexadecimals
    assert(Std.parseInt("0xff") == 255);
    assert(Std.parseInt("0x123") == 291);
    assert(Std.parseInt("0XFF") == 255);
    assert(Std.parseInt("0X123") == 291);
    assert(Std.parseInt("0X01") == 1);
    assert(Std.parseInt("0x01") == 1);
    // signs
    assert(Std.parseInt("123") == 123);
    assert(Std.parseInt("+123") == 123);
    assert(Std.parseInt("-123") == -123);
    assert(Std.parseInt("0xa0") == 160);
    assert(Std.parseInt("+0xa0") == 160);
    assert(Std.parseInt("-0xa0") == -160);
    // whitespace: space, horizontal tab, newline, vertical tab, form feed, and carriage return
    assert(Std.parseInt("   5") == 5);
    assert(Std.parseInt(" \t\n\x0b\x0c\r16") == 16);
    assert(Std.parseInt(" \t\n\x0b\x0c\r0xa") == 10);
    // whitespace and signs
    assert(Std.parseInt('  	16') == 16);
    assert(Std.parseInt('  	-16') == -16);
    assert(Std.parseInt('  	+16') == 16);
    assert(Std.parseInt('  	0x10') == 16);
    assert(Std.parseInt('  	-0x10') == -16);
    assert(Std.parseInt('  	+0x10') == 16);
    // binary and octal unsupported
    assert(Std.parseInt("010") == 10);
    assert(Std.parseInt("0b10") == 0);
    // null
    // assert(Std.parseInt(null) == null);
    // no number
    assert(Std.parseInt("") == null);
    assert(Std.parseInt("abcd") == null);
    assert(Std.parseInt("a10") == null);
    // invalid use of signs
    assert(Std.parseInt("++123") == null);
    assert(Std.parseInt("+-123") == null);
    assert(Std.parseInt("-+123") == null);
    assert(Std.parseInt("--123") == null);
    assert(Std.parseInt("+ 123") == null);
    assert(Std.parseInt("- 123") == null);
    assert(Std.parseInt("++0x123") == null);
    assert(Std.parseInt("+-0x123") == null);
    assert(Std.parseInt("-+0x123") == null);
    assert(Std.parseInt("--0x123") == null);
    assert(Std.parseInt("+ 0x123") == null);
    assert(Std.parseInt("- 0x123") == null);
    // hexadecimal prefix with no number
    unspec(Std.parseInt.bind("0x"));
    unspec(Std.parseInt.bind("0x C"));
    unspec(Std.parseInt.bind("0x+A"));

    // parseFloat

    // general
    assert(Std.parseFloat("0") == 0.);
    assert(Std.parseFloat("0.0") == 0.);
    // preceeding zeroes
    assert(Std.parseFloat("0001") == 1.);
    assert(Std.parseFloat("0010") == 10.);
    // trailing text
    assert(Std.parseFloat("100x123") == 100.);
    assert(Std.parseFloat("12foo13") == 12.);
    assert(Std.parseFloat("5.3 ") == 5.3);
    assert(Std.parseFloat("5.3 1") == 5.3);
    // signs
    assert(Std.parseFloat("123.45") == 123.45);
    assert(Std.parseFloat("+123.45") == 123.45);
    assert(Std.parseFloat("-123.45") == -123.45);
    // whitespace: space, horizontal tab, newline, vertical tab, form feed, and carriage return
    assert(Std.parseFloat("   5.2") == 5.2);
    assert(Std.parseFloat(" \t\n\x0b\x0c\r1.6") == 1.6);
    // whitespace and signs
    assert(Std.parseFloat('  	1.6') == 1.6);
    assert(Std.parseFloat('  	-1.6') == -1.6);
    assert(Std.parseFloat('  	+1.6') == 1.6);
    // exponent
    assert(Std.parseFloat("2.426670815e12") == 2.426670815e12);
    assert(Std.parseFloat("2.426670815E12") == 2.426670815e12);
    assert(Std.parseFloat("2.426670815e+12") == 2.426670815e+12);
    assert(Std.parseFloat("2.426670815E+12") == 2.426670815e+12);
    assert(Std.parseFloat("2.426670815e-12") == 2.426670815e-12);
    assert(Std.parseFloat("2.426670815E-12") == 2.426670815e-12);
    #if !interp
    assert(Std.parseFloat("6e") == 6);
    assert(Std.parseFloat("6E") == 6);
    #end
    // null
    assert(Math.isNaN(Std.parseFloat(null)) == true);
    // no number
    assert(Math.isNaN(Std.parseFloat("")) == true);
    assert(Math.isNaN(Std.parseFloat("abcd")) == true);
    assert(Math.isNaN(Std.parseFloat("a10")) == true);
    // invalid use of signs
    assert(Math.isNaN(Std.parseFloat("++12.3")) == true);
    assert(Math.isNaN(Std.parseFloat("+-12.3")) == true);
    assert(Math.isNaN(Std.parseFloat("-+12.3")) == true);
    assert(Math.isNaN(Std.parseFloat("--12.3")) == true);
    assert(Math.isNaN(Std.parseFloat("+ 12.3")) == true);
    assert(Math.isNaN(Std.parseFloat("- 12.3")) == true);

    // random
    var x = Std.random(2);
    assert(x == 0 || x == 1);
    assert(Std.random(1) == 0);
    assert(Std.random(0) == 0);
    assert(Std.random(-100) == 0);

}