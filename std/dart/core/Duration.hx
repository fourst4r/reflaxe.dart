package dart.core;

@:native("Duration")
extern class Duration {
    function new(
        @:dart.named days:Int = 0,
        @:dart.named hours:Int = 0,
        @:dart.named minutes:Int = 0,
        @:dart.named seconds:Int = 0,
        @:dart.named milliseconds:Int = 0,
        @:dart.named microseconds:Int = 0,
    );
    var inDays(default, never):Int;
    var inHours(default, never):Int;
    var inMicroseconds(default, never):Int;
    var inMilliseconds(default, never):Int;
    var inMinutes(default, never):Int;
    var inSeconds(default, never):Int;
    var isNegative(default, never):Bool;
    
}