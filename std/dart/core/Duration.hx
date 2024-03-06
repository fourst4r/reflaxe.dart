package dart.core;

@:native("Duration")
extern class Duration {
    @:dart.argMeta(@:dart.named [days, hours, minutes, seconds, milliseconds, microseconds])
    @:argMeta(0, dart_named("days"))
    @:argMeta(1, dart_named("hours"))
    @:argMeta(2, dart_named("minutes"))
    @:argMeta(3, dart_named("seconds"))
    @:argMeta(4, dart_named("milliseconds"))
    @:argMeta(5, dart_named("microseconds"))
    function new(
        days:Int = 0,
        hours:Int = 0,
        minutes:Int = 0,
        seconds:Int = 0,
        milliseconds:Int = 0,
        microseconds:Int = 0,
    );
    var inDays(default, never):Int;
    var inHours(default, never):Int;
    var inMicroseconds(default, never):Int;
    var inMilliseconds(default, never):Int;
    var inMinutes(default, never):Int;
    var inSeconds(default, never):Int;
    var isNegative(default, never):Bool;
    
}