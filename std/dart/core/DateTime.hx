package dart.core;

@:native("DateTime")
extern class DateTime {
    static function fromMicrosecondsSinceEpoch(microsecondsSinceEpoch:Int, @:dart.named isUtc:Bool=false):DateTime;
    static function fromMillisecondsSinceEpoch(millisecondsSinceEpoch:Int, @:dart.named isUtc:Bool=false):DateTime;
    static function now():DateTime;
    static function timestamp():DateTime;
    static function utc(year:Int, month:Int=1, day:Int=1, hour:Int=0, minute:Int=0, second:Int=0, millisecond:Int=0, microsecond:Int=0):DateTime;
    static function parse(formattedString:String):DateTime;
    static function tryParse(formattedString:String):Null<DateTime>;
    function new(year:Int, month:Int=1, day:Int=1, hour:Int=0, minute:Int=0, second:Int=0, millisecond:Int=0, microsecond:Int=0);
    var day(default, never):Int;
    var hour(default, never):Int;
    var isUtc(default, never):Bool;
    var microsecond(default, never):Int;
    var microsecondsSinceEpoch(default, never):Int;
    var milliseconds(default, never):Int;
    var millisecondsSinceEpoch(default, never):Int;
    var minute(default, never):Int;
    var month(default, never):Int;
    var second(default, never):Int;
    var timeZoneName(default, never):String;
    var timeZoneOffset(default, never):Duration;
    var weekday(default, never):Int;
    var year(default, never):Int;
    function add(duration:Duration):DateTime;
    function difference(other:DateTime):Duration;
    function isAfter(other:DateTime):Bool;
    function isAtSameMomentAs(other:DateTime):Bool;
    function isBefore(other:DateTime):Bool;
    function subtract(duration:Duration):DateTime;
    function toIso8601String():String;
    function toLocal():DateTime;
    function toString():String;
    function toUtc():DateTime;
}