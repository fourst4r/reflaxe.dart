package;

import dart.core.DateTime;

/**
	The Date class provides a basic structure for date and time related
	information. Date instances can be created by

	- `new Date()` for a specific date,
	- `Date.now()` to obtain information about the current time,
	- `Date.fromTime()` with a given timestamp or
	- `Date.fromString()` by parsing from a String.

	There are some extra functions available in the `DateTools` class.

	In the context of Haxe dates, a timestamp is defined as the number of
	milliseconds elapsed since 1st January 1970 UTC.

	## Supported range

	Due to platform limitations, only dates in the range 1970 through 2038 are
	supported consistently. Some targets may support dates outside this range,
	depending on the OS at runtime. The `Date.fromTime` method will not work with
	timestamps outside the range on any target.
**/
@:coreApi class Date {
	var _date:DateTime;
	/**
		Creates a new date object from the given arguments.

		The behaviour of a Date instance is only consistent across platforms if
		the the arguments describe a valid date.

		- month: 0 to 11 (note that this is zero-based)
		- day: 1 to 31
		- hour: 0 to 23
		- min: 0 to 59
		- sec: 0 to 59
	**/
	public function new(year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int):Void {
		_date = DateTime.utc(year, month, day, hour, min, sec);
	}

	/**
		Returns the timestamp (in milliseconds) of `this` date.
		On cpp and neko, this function only has a second resolution, so the
		result will always be a multiple of `1000.0`, e.g. `1454698271000.0`.
		To obtain the current timestamp with better precision on cpp and neko,
		see the `Sys.time` API.

		For measuring time differences with millisecond accuracy on
		all platforms, see `haxe.Timer.stamp`.
	**/
	public function getTime():Float {
		return _date.millisecondsSinceEpoch;
	}

	/**
		Returns the hours of `this` Date (0-23 range) in the local timezone.
	**/
	public function getHours():Int {
		return _date.toLocal().hour;
	}

	/**
		Returns the minutes of `this` Date (0-59 range) in the local timezone.
	**/
	public function getMinutes():Int {
		return _date.toLocal().minute;
	}

	/**
		Returns the seconds of `this` Date (0-59 range) in the local timezone.
	**/
	public function getSeconds():Int {
		return _date.toLocal().second;
	}

	/**
		Returns the full year of `this` Date (4 digits) in the local timezone.
	**/
	public function getFullYear():Int {
		return _date.toLocal().year;
	}

	/**
		Returns the month of `this` Date (0-11 range) in the local timezone.
		Note that the month number is zero-based.
	**/
	public function getMonth():Int {
		return _date.toLocal().month-1;
	}

	/**
		Returns the day of `this` Date (1-31 range) in the local timezone.
	**/
	public function getDate():Int {
		return _date.toLocal().day;
	}

	/**
		Returns the day of the week of `this` Date (0-6 range, where `0` is Sunday)
		in the local timezone.
	**/
	public function getDay():Int {
		return (_date.toLocal().weekday + 5) % 7;
	}

	/**
		Returns the hours of `this` Date (0-23 range) in UTC.
	**/
	public function getUTCHours():Int {
		return _date.hour;
	}

	/**
		Returns the minutes of `this` Date (0-59 range) in UTC.
	**/
	public function getUTCMinutes():Int {
		return _date.minute;
	}

	/**
		Returns the seconds of `this` Date (0-59 range) in UTC.
	**/
	public function getUTCSeconds():Int {
		return _date.second;
	}

	/**
		Returns the full year of `this` Date (4 digits) in UTC.
	**/
	public function getUTCFullYear():Int {
		return _date.year;
	}

	/**
		Returns the month of `this` Date (0-11 range) in UTC.
		Note that the month number is zero-based.
	**/
	public function getUTCMonth():Int {
		return _date.month-1;
	}

	/**
		Returns the day of `this` Date (1-31 range) in UTC.
	**/
	public function getUTCDate():Int {
		return _date.day;
	}

	/**
		Returns the day of the week of `this` Date (0-6 range, where `0` is Sunday)
		in UTC.
	**/
	public function getUTCDay():Int {
		return (_date.weekday + 5) % 7;
	}

	/**
		Returns the time zone difference of `this` Date in the current locale
		to UTC, in minutes.

		Assuming the function is executed on a machine in a UTC+2 timezone,
		`Date.now().getTimezoneOffset()` will return `-120`.
	**/
	public function getTimezoneOffset():Int {
		return _date.timeZoneOffset.inMinutes;
	}

	/**
		Returns a string representation of `this` Date in the local timezone
		using the standard format `YYYY-MM-DD HH:MM:SS`. See `DateTools.format` for
		other formatting rules.
	**/
	public function toString():String {
		return _date.toString();
	}

	/**
		Returns a Date representing the current local time.
	**/
	public static function now():Date {
		final d = new Date(0, 0, 0, 0, 0, 0);
		d._date = DateTime.now();
		return d;
	}

	/**
		Creates a Date from the timestamp (in milliseconds) `t`.
	**/
	public static function fromTime(t:Float):Date {
		final d = new Date(0, 0, 0, 0, 0, 0);
		d._date = DateTime.fromMillisecondsSinceEpoch(Std.int(t));
		return d; 
	}

	/**
		Creates a Date from the formatted string `s`. The following formats are
		accepted by the function:

		- `"YYYY-MM-DD hh:mm:ss"`
		- `"YYYY-MM-DD"`
		- `"hh:mm:ss"`

		The first two formats expressed a date in local time. The third is a time
		relative to the UTC epoch.
	**/
	public static function fromString(s:String):Date {
		final d = new Date(0, 0, 0, 0, 0, 0);
		d._date = DateTime.parse(s);
		return d;
	}
}
