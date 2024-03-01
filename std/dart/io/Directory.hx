package dart.io;

@:dart.import("dart:io")
extern class Directory {
    static var current(default, default):Directory;
    function new(path:String);
    var absolute(default, never):Directory;
    var path(default, never):String;
    var parent(default, never):Directory;
}