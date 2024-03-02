package dart.io;

@:dart.import("dart:io")
extern class Platform {
    static var environment(default, never):dart.core.Map<String, String>;
    static var executableArguments(default, never):dart.core.List<String>;
    static var isAndroid(default, never):Bool;
    static var isFuchsia(default, never):Bool;
    static var isIOS(default, never):Bool;
    static var isLinux(default, never):Bool;
    static var isMacOS(default, never):Bool;
    static var isWindows(default, never):Bool;
    static var operatingSystem(default, never):String;
    static var resolvedExecutable(default, never):String;
    static var script(default, never):dart.core.Uri;
}