
import dart.Lib.assert;

function aeq(a, b) {
    for (i in 0...a.length) {
        assert(a[i] == b[i]);
    }
}

function main() {
// htmlEscape
var str = "<foo> & <bar> = 'invalid\"'";
var strEsc = "&lt;foo&gt; &amp; &lt;bar&gt; = 'invalid\"'";
var strEscQuotes = "&lt;foo&gt; &amp; &lt;bar&gt; = &#039;invalid&quot;&#039;";
assert(StringTools.htmlEscape(str, false) == strEsc);
assert(StringTools.htmlEscape(str, true) == strEscQuotes);

// htmlUnescape
assert(StringTools.htmlUnescape(strEsc) == str);
assert(StringTools.htmlUnescape(strEscQuotes) == str);

// startsWith
assert(StringTools.startsWith("foo", "f") == true);
assert(StringTools.startsWith("foo", "fo") == true);
assert(StringTools.startsWith("foo", "foo") == true);
assert(StringTools.startsWith("foo", "fooo") == false);
assert(StringTools.startsWith("foo", "") == true);
assert(StringTools.startsWith("", "") == true);

// endsWith
assert(StringTools.endsWith("foo", "o") == true);
assert(StringTools.endsWith("foo", "oo") == true);
assert(StringTools.endsWith("foo", "foo") == true);
assert(StringTools.endsWith("foo", "fooo") == false);
assert(StringTools.endsWith("foo", "") == true);
assert(StringTools.endsWith("", "") == true);
assert(StringTools.endsWith("μου\n","\n") == true);

// isSpace
assert(StringTools.isSpace("", 0) == false);
assert(StringTools.isSpace("", 1) == false);
assert(StringTools.isSpace(" ", -1) == false);
assert(StringTools.isSpace("a", 0) == false);
assert(StringTools.isSpace("  ", 0) == true);
assert(StringTools.isSpace(" ", 0) == true);
assert(StringTools.isSpace(" a", 0) == true);
assert(StringTools.isSpace(String.fromCharCode(9), 0) == true);
assert(StringTools.isSpace(String.fromCharCode(10), 0) == true);
assert(StringTools.isSpace(String.fromCharCode(11), 0) == true);
assert(StringTools.isSpace(String.fromCharCode(12), 0) == true);
assert(StringTools.isSpace(String.fromCharCode(13), 0) == true);

// ltrim
assert(StringTools.ltrim("a") == "a");
assert(StringTools.ltrim("  a") == "a");
assert(StringTools.ltrim("  a b") == "a b");
assert(StringTools.ltrim("    ") == "");
assert(StringTools.ltrim("") == "");

// rtrim
assert(StringTools.rtrim("a") == "a");
assert(StringTools.rtrim("a  ") == "a");
assert(StringTools.rtrim("a b  ") == "a b");
assert(StringTools.rtrim("    ") == "");
assert(StringTools.rtrim("") == "");

// trim
assert(StringTools.trim("a") == "a");
assert(StringTools.trim("a  ") == "a");
assert(StringTools.trim("a b  ") == "a b");
assert(StringTools.trim("    ") == "");
assert(StringTools.trim("") == "");
assert(StringTools.trim("  a") == "a");
assert(StringTools.trim("  a b") == "a b");
assert(StringTools.trim("  a b  ") == "a b");

// lpad
assert(StringTools.lpad("", "", 2) == "");
assert(StringTools.lpad("", "a", 0) == "");
assert(StringTools.lpad("b", "a", 0) == "b");
assert(StringTools.lpad("b", "", 2) == "b");
assert(StringTools.lpad("", "a", 2) == "aa");
assert(StringTools.lpad("b", "a", 0) == "b");
assert(StringTools.lpad("b", "a", 1) == "b");
assert(StringTools.lpad("b", "a", 2) == "ab");
assert(StringTools.lpad("b", "a", 3) == "aab");
assert(StringTools.lpad("b", "a", 4) == "aaab");
assert(StringTools.lpad("b", "abcdef", 4) == "abcdefb");

// rpad
assert(StringTools.rpad("", "", 2) == "");
assert(StringTools.rpad("", "a", 0) == "");
assert(StringTools.rpad("b", "a", 0) == "b");
assert(StringTools.rpad("b", "", 2) == "b");
assert(StringTools.rpad("", "a", 2) == "aa");
assert(StringTools.rpad("b", "a", 0) == "b");
assert(StringTools.rpad("b", "a", 1) == "b");
assert(StringTools.rpad("b", "a", 2) == "ba");
assert(StringTools.rpad("b", "a", 3) == "baa");
assert(StringTools.rpad("b", "a", 4) == "baaa");
assert(StringTools.rpad("b", "abcdef", 4) == "babcdef");

// replace
var s = "xfooxfooxxbarxbarxx";
assert(StringTools.replace(s, "x", "") == "foofoobarbar");
assert(StringTools.replace(s, "", "") == "xfooxfooxxbarxbarxx");
assert(StringTools.replace(s, "", "x") == "xxfxoxoxxxfxoxoxxxxxbxaxrxxxbxaxrxxxx");

// hex
assert(StringTools.hex(0, 0) == "0");
assert(StringTools.hex(0, 1) == "0");
assert(StringTools.hex(0, 2) == "00");
assert(StringTools.hex(1, 2) == "01");
assert(StringTools.hex(4564562) == "45A652");
assert(StringTools.hex(4564562, 0) == "45A652");
assert(StringTools.hex(4564562, 1) == "45A652");
// assert(StringTools.hex( -1) == "FFFFFFFF");
// assert(StringTools.hex( -2) == "FFFFFFFE");
assert(StringTools.hex(0xABCDEF, 7) == "0ABCDEF");
// assert(StringTools.hex( -1, 8) == "FFFFFFFF");
// assert(StringTools.hex( -481400000, 8) == "E34E6B40");

// contains
var s = "foo1bar";
assert(StringTools.contains(s, '') == true);
assert(StringTools.contains(s, 'bar') == true);
assert(StringTools.contains(s, 'test') == false);

// fastCodeAt
var s = "foo1bar";
assert(StringTools.fastCodeAt(s, 0) == 102);
assert(StringTools.fastCodeAt(s, 1) == 111);
assert(StringTools.fastCodeAt(s, 2) == 111);
assert(StringTools.fastCodeAt(s, 3) == 49);
assert(StringTools.fastCodeAt(s, 4) == 98);
assert(StringTools.fastCodeAt(s, 5) == 97);
assert(StringTools.fastCodeAt(s, 6) == 114);
var str = "abc";
assert(StringTools.fastCodeAt(str, 0) == "a".code);
assert(StringTools.fastCodeAt(str, 1) == "b".code);
assert(StringTools.fastCodeAt(str, 2) == "c".code);
assert(StringTools.fastCodeAt(String.fromCharCode(128), 0) == 128);
assert(StringTools.fastCodeAt(String.fromCharCode(255), 0) == 255);
// assert(StringTools.isEof(StringTools.fastCodeAt(str, 0)) == false);
// assert(StringTools.isEof(StringTools.fastCodeAt(str, 1)) == false);
// assert(StringTools.isEof(StringTools.fastCodeAt(str, 2)) == false);
// assert(StringTools.isEof(StringTools.fastCodeAt(str, 3)) == true);
// assert(StringTools.isEof(StringTools.fastCodeAt(str, 2)) == false);
// assert(StringTools.isEof(StringTools.fastCodeAt(str, 3)) == true);
// assert(StringTools.isEof(StringTools.fastCodeAt("", 0)) == true);

// isEOF
#if (neko || lua || eval)
assert(StringTools.isEof(null) == true);
#elseif (cs || java || python)
assert(StringTools.isEof( -1) == true);
#elseif js
// how do I test this here?
#else
// assert(StringTools.isEof(0) == true);
#end

// iterators via @:using
var s = 'zя𠜎';
#if !(target.unicode)
var expectedCodes = [122, 209, 143, 240, 160, 156, 142];
#elseif utf16
var expectedCodes = [122, 1103, 55361, 57102];
#else
var expectedCodes = [122, 1103, 132878];
#end
var expectedKeys = [for(i in 0...expectedCodes.length) i];
// iterator()
aeq(expectedCodes, [for(c in StringTools.iterator(s)) c]);
// keyValueIterator()
var keyCodes = [for(i => c in StringTools.keyValueIterator(s)) [i, c]];
aeq(expectedKeys, keyCodes.map(a -> a[0]));
aeq(expectedCodes, keyCodes.map(a -> a[1]));

}