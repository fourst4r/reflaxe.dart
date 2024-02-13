@:native("assert")
extern function assert(cond:Bool):Void;

class MyStringIterator {
    var s:String;
    var i:Int;
  
    public function new(s:String) {
      this.s = s;
      i = 0;
    }
  
    public function hasNext() {
      return i < s.length;
    }
  
    public function next() {
      return s.charAt(i++);
    }
  }
  

@:nullSafety(StrictThreaded)
function main() {

    var myIt = new MyStringIterator("string");
    for (chr in myIt) {
      trace(chr);
    }


    var a = [];

    for (e in a) {
        trace(e);
    }

    // new
    var str = "foo";
    str += "1";
    var str2 = new String(str);
    assert(str == str2);

    // toUpperCase
    assert("foo".toUpperCase() == "FOO");
    assert("_bar".toUpperCase() == "_BAR");
    assert("123b".toUpperCase() == "123B");
    assert("".toUpperCase() == "");
    assert("A".toUpperCase() == "A");

    // toLowerCase
    assert("FOO".toLowerCase() == "foo");
    assert("_BAR".toLowerCase() == "_bar");
    assert("123B".toLowerCase() == "123b");
    assert("".toLowerCase() == "");
    assert("a".toLowerCase() == "a");

    // charAt
    var s = "foo1bar";
    assert(s.charAt(0) == "f");
    assert(s.charAt(1) == "o");
    assert(s.charAt(2) == "o");
    assert(s.charAt(3) == "1");
    assert(s.charAt(4) == "b");
    assert(s.charAt(5) == "a");
    assert(s.charAt(6) == "r");
    assert(s.charAt(7) == "");
    assert(s.charAt( -1) == "");
    assert("".charAt(0) == "");
    assert("".charAt(1) == "");
    assert("".charAt( -1) == "");

    // charCodeAt
    var s = "foo1bar";
    assert(s.charCodeAt(0) == 102);
    assert(s.charCodeAt(1) == 111);
    assert(s.charCodeAt(2) == 111);
    assert(s.charCodeAt(3) == 49);
    assert(s.charCodeAt(4) == 98);
    assert(s.charCodeAt(5) == 97);
    assert(s.charCodeAt(6) == 114);
    assert(s.charCodeAt(7) == null);
    assert(s.charCodeAt( -1) == null);

    // code
    assert("f".code == 102);
    assert("o".code == 111);
    assert("1".code == 49);
    assert("b".code == 98);
    assert("a".code == 97);
    assert("r".code == 114);

    // indexOf
    var s = "foo1bar";
    assert(s.indexOf("") == 0);
    assert(s.indexOf("f") == 0);
    assert(s.indexOf("o") == 1);
    assert(s.indexOf("1") == 3);
    assert(s.indexOf("b") == 4);
    assert(s.indexOf("a") == 5);
    assert(s.indexOf("r") == 6);
    assert(s.indexOf("z") == -1);
    //s.indexOf(null) == -1;
    //s.indexOf(null, 1) == -1;
    //s.indexOf(null, -1) == -1;
    assert(s.indexOf("foo") == 0);
    assert(s.indexOf("oo") == 1);
    //s.indexOf("bart") == -1;
    //s.indexOf("r", -1) == -1;
    //s.indexOf("r", -10) == -1;
    assert(s.indexOf("", 2) == 2);
    assert(s.indexOf("", 200) == s.length);
    assert(s.indexOf("o", 1) == 1);
    assert(s.indexOf("o", 2) == 2);
    assert(s.indexOf("o", 3) == -1);
    //s.indexOf("", -10) == 0;
    //s.indexOf("", 7) == 7; // see #8117
    //s.indexOf("", 8) == -1; // see #8117
    assert(s.indexOf("r", 7) == -1);
    assert(s.indexOf("r", 8) == -1);

    // lastIndexOf
    var s = "foofoofoobarbar";
    assert(s.lastIndexOf("") == s.length);
    assert(s.lastIndexOf("r") == 14);
    assert(s.lastIndexOf("a") == 13);
    assert(s.lastIndexOf("b") == 12);
    assert(s.lastIndexOf("bar") == 12);
    assert(s.lastIndexOf("foo") == 6);
    assert(s.lastIndexOf("foofoo") == 3);
    assert(s.lastIndexOf("f") == 6);
    assert(s.lastIndexOf("barb") == 9);
    assert(s.lastIndexOf("barb", 12) == 9);
    assert(s.lastIndexOf("barb", 13) == 9);
    assert(s.lastIndexOf("z") == -1);
    //s.lastIndexOf(null) == -1;
    //s.lastIndexOf(null, 1) == -1;
    //s.lastIndexOf(null, 14) == -1;
    assert(s.lastIndexOf("", 2) == 2);
    assert(s.lastIndexOf("", 200) == s.length);
    assert(s.lastIndexOf("r", 14) == 14);
    assert(s.lastIndexOf("r", 13) == 11);
    assert(s.lastIndexOf("a", 14) == 13);
    assert(s.lastIndexOf("a", 13) == 13);
    assert(s.lastIndexOf("a", 12) == 10);
    assert(s.lastIndexOf("bar", 12) == 12);
    assert(s.lastIndexOf("bar", 11) == 9);
    assert(s.lastIndexOf("bar", 9) == 9);
    assert(s.lastIndexOf("bar", 8) == -1);
    assert(s.lastIndexOf("a", s.length) == 13);
    assert(s.lastIndexOf("a", s.length + 9000) == 13);

    // split
    var s = "xfooxfooxxbarxbarxx";
    assert(s.split("x").toString() == ["", "foo", "foo", "", "bar", "bar", "",""].toString());
    assert(s.split("xx").toString() == ["xfooxfoo","barxbar",""].toString());
    assert(s.split("").toString() == ["x", "f", "o", "o", "x", "f", "o", "o", "x", "x", "b", "a", "r", "x", "b", "a", "r", "x", "x"].toString());
    assert(s.split("z").toString() == ["xfooxfooxxbarxbarxx"].toString());

    // substr
    var s = "xfooxfooxxbarxbarxx";
    assert(s.substr(0) == "xfooxfooxxbarxbarxx");
    assert(s.substr(1) == "fooxfooxxbarxbarxx");
    assert(s.substr(19) == "");
    assert(s.substr(18) == "x");
    assert(s.substr(17) == "xx");
    assert(s.substr(-1) == "x");
    assert(s.substr(-2) == "xx");
    assert(s.substr(-18) == "fooxfooxxbarxbarxx");
    assert(s.substr(-19) == "xfooxfooxxbarxbarxx");
    assert(s.substr( -100) == "xfooxfooxxbarxbarxx");
    assert(s.substr(0, 0) == "");
    assert(s.substr(0, 1) == "x");
    assert(s.substr(0, 2) == "xf");
    assert(s.substr(0, 100) == "xfooxfooxxbarxbarxx");
    assert(s.substr(0, -1) == "xfooxfooxxbarxbarx");
    assert(s.substr(0, -2) == "xfooxfooxxbarxbar");
    //s.substr(1, -2) == "fooxfooxxbarxbar";
    //s.substr(2, -2) == "ooxfooxxbarxbar";
    assert(s.substr(0, -100) == "");

    // substring
    var s = "xfooxfooxxbarxbarxx";
    assert(s.substring(0, 0) == "");
    assert(s.substring(0, 1) == "x");
    assert(s.substring(1, 0) == "x");
    assert(s.substring(0, 2) == "xf");
    assert(s.substring(2, 0) == "xf");
    assert(s.substring(-1, 0) == "");
    assert(s.substring(0, -1) == "");
    assert(s.substring(-1, -1) == "");
    assert(s.substring(-1, 1) == "x");
    assert(s.substring(1, -1) == "x");
    assert(s.substring(-1, 2) == "xf");
    assert(s.substring(2, -1) == "xf");
    assert(s.substring(0) == "xfooxfooxxbarxbarxx");
    assert(s.substring(1) == "fooxfooxxbarxbarxx");
    assert(s.substring(2) == "ooxfooxxbarxbarxx");
    assert(s.substring(20, 0) == "xfooxfooxxbarxbarxx");
    assert(s.substring(0, 100) == "xfooxfooxxbarxbarxx");
    assert(s.substring(100, 120) == "");
    assert(s.substring(100, 0) == "xfooxfooxxbarxbarxx");
    assert(s.substring(120, 100) == "");
    assert(s.substring(5, 8) == "foo");
    assert(s.substring(8, 5) == "foo");

    // fromCharCode
    assert(String.fromCharCode(65) == "A");

    // ensure int strings compared as strings, not parsed ints (issue #3734)
    assert(("3" > "11") == true);
    assert((" 3" < "3") == true);

    // string comparison (see #8332)
    assert(("a" < "b") == true);
    assert(("a" <= "b") == true);
    assert(("a" > "b") == false);
    assert(("a" >= "b") == false);

    #if target.unicode
    // assert(("𠜎zя" > "abя") == true);
    // assert(("𠜎zя" >= "abя") == true);
    // assert(("𠜎zя" < "abя") == false);
    // assert(("𠜎zя" <= "abя") == false);

    #if target.utf16
    // since U+10002 in UTF16 is D800 DC02
    // assert(("\u{FF61}" < "\u{10002}") == false);
    #else
    // assert(("\u{FF61}" < "\u{10002}") == true);
    #end

    #end
}