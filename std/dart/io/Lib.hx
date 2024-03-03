package dart.io;

@:dart.import("dart:io")
@:native("dart_io.stdout")
extern var stdout(default, never):Stdout;

@:dart.import("dart:io")
@:native("dart_io.systemEncoding")
extern var systemEncoding(default, never):dart.convert.Encoding;

@:dart.import("dart:io")
@:native("dart_io.exit")
extern function exit(code:Int):Void;

@:dart.import("dart:io")
@:native("dart_io.sleep")
extern function sleep(duration:dart.core.Duration):Void;