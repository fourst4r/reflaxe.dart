package;

import dart.core.DateTime;

@:coreApi class Date {
    var _date:DateTime;

    public function new(year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int)
        _date = new DateTime(year, month+1, day, hour, min, sec);

    public function getTime():Float
        return _date.millisecondsSinceEpoch;

    public function getHours():Int 
        return _date.hour;

    public function getMinutes():Int
        return _date.minute;

    public function getSeconds():Int
        return _date.second;

    public function getFullYear():Int
        return _date.year;

    public function getMonth():Int
        return _date.month-1;

    public function getDate():Int
        return _date.day;

    public function getDay():Int
        return _date.weekday % 7;

    public function getUTCHours():Int
        return _date.toUtc().hour;

    public function getUTCMinutes():Int
        return _date.toUtc().minute;

    public function getUTCSeconds():Int
        return _date.toUtc().second;

    public function getUTCFullYear():Int
        return _date.toUtc().year;

    public function getUTCMonth():Int
        return _date.toUtc().month-1;

    public function getUTCDate():Int
        return _date.toUtc().day;

    public function getUTCDay():Int
        return _date.toUtc().weekday % 7;

    public function getTimezoneOffset():Int
        return _date.timeZoneOffset.inMinutes;

    public function toString():String {
        var m = getMonth() + 1;
        var d = getDate();
        var h = getHours();
        var mi = getMinutes();
        var s = getSeconds();
        return getFullYear() + "-" + (if (m < 10) "0" + m else "" + m) + "-" + (if (d < 10) "0" + d else "" + d) + " "
            + (if (h < 10) "0" + h else "" + h) + ":" + (if (mi < 10) "0" + mi else "" + mi) + ":" + (if (s < 10) "0" + s else "" + s);
    }

    public static function now():Date {
        final d = new Date(0, 0, 0, 0, 0, 0);
        d._date = DateTime.now();
        return d;
    }

    public static function fromTime(t:Float):Date {
        final d = new Date(0, 0, 0, 0, 0, 0);
        d._date = DateTime.fromMillisecondsSinceEpoch(Std.int(t));
        return d; 
    }

    public static function fromString(s:String):Date {
        function pi(si) {
            return Std.parseInt(si) ?? throw "Invalid date format : " + s;
        }
        switch (s.length) {
            case 8: // hh:mm:ss
                switch (s.split(":")) {
                    case [pi(_) => hh, pi(_) => mm, pi(_) => ss]:
                        return Date.fromTime(hh*3600000. + mm*60000. + ss*1000.);
                    default:
                }
            case 10: // YYYY-MM-DD
                switch (s.split("-")) {
                    case [pi(_) => var YYYY, pi(_) => var MM, pi(_) => var DD]:
                        return new Date(YYYY, MM - 1, DD, 0, 0, 0);
                    default:
                }
            case 19: // YYYY-MM-DD hh:mm:ss
                switch (s.split(" ")) {
                    case [_.split("-") => [pi(_) => var YYYY, pi(_) => var MM, pi(_) => var DD], 
                          _.split(":") => [pi(_) => hh, pi(_) => mm, pi(_) => ss]]:
                        return new Date(YYYY, MM - 1, DD, hh, mm, ss);
                    default:
                }
            default:
        }
        throw "Invalid date format : " + s;
    }
}
