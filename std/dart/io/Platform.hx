package dart.io;

@:dart.import("dart:io")
extern class Platform {
    var environment(default, never):dart.core.Map<String, String>;
    var executableArguments(default, never):dart.core.List<String>;
    var isAndroid(default, never):Bool;
    var isFuchsia(default, never):Bool;
    var isIOS(default, never):Bool;
    var isLinux(default, never):Bool;
    var isMacOS(default, never):Bool;
    var isWindows(default, never):Bool;
    var operatingSystem(default, never):String;
    var resolvedExecutable(default, never):String;
    var script(default, never):dart.core.Uri;
}