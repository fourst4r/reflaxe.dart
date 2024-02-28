package dart.io;

@:dart.import("dart:io")
extern class Stdout {
    function write(object:Dynamic):Void;
    function writeCharCode(charCode:Int):Void;
    function writeln(object:Dynamic = ""):Void;
}