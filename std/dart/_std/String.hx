package;

@:nullSafety(StrictThreaded)
private class StringImpl {
	public static function indexOf(s:String, str:String, ?startIndex:Int):Int {
		var start:Int = 0;
		if (startIndex != null && startIndex > 0) {
			if (startIndex >= s.length)
				return str == '' ? s.length : -1;
			start = startIndex;
		}
		return (cast s).indexOf(str, start);
	}

	public static function lastIndexOf(s:String, str:String, ?startIndex:Int):Int {
		var max = s.length;
		if (startIndex != null) {
			max = startIndex + str.length;
			if (max < 0)
				max = 0;
			if (max > s.length)
				max = s.length;
		}
		var pos = max - str.length;
		return (cast s).lastIndexOf(str, pos);
	}

	public static function substr(s:String, pos:Int, ?len:Int):String {
		var sl = s.length;
		var len:Int = len ?? sl;
		if (len == 0)
			return "";
		if (pos < 0) {
			pos = sl + pos;
			if (pos < 0)
				pos = 0;
		} else if (len < 0) {
			len = sl + len - pos;
			if (len < 0)
				return "";
		}
		if ((pos + len) > sl)
			len = sl - pos;
		if (pos < 0 || len <= 0)
			return "";

		return (cast s).substring(pos, pos+len);
	}

	public static function substring(s:String, startIndex:Int, ?endIndex:Int):String {
		var end:Int;
		if (endIndex == null)
			end = s.length;
		else {
			end = endIndex;
			if (end < 0)
				end = 0;
			else if (end > s.length)
				end = s.length;
		}
		if (startIndex < 0)
			startIndex = 0;
		else if (startIndex > s.length)
			startIndex = s.length;
		if (startIndex > end) {
			var tmp = startIndex;
			startIndex = end;
			end = tmp;
		}
		return (cast s).substring(startIndex, end);
	}
}

@:access(Array)
@:coreApi extern class String {
	public var length(default, null):Int;

	@:nativeFunctionCode("String.fromCharCodes({arg0}.codeUnits)")
	public function new(string:String);

	function toUpperCase():String;
	function toLowerCase():String;
	public inline function charAt(index:Int):String {
		if (index < 0 || index >= length) return "";
		return untyped __dart__("{0}[{1}]", this, index);
	}
	inline function charCodeAt(index:Int):Null<Int> {
		if (index < 0 || index >= length) return null;
		return untyped this.codeUnitAt(index);
	}
	inline function indexOf(str:String, ?startIndex:Int):Int
		return StringImpl.indexOf(this, str, startIndex);
	inline function lastIndexOf(str:String, ?startIndex:Int):Int
		return StringImpl.lastIndexOf(this, str, startIndex);
	inline function split(delimiter:String):Array<String>
		// return inline Array.fromList(untyped this.split(delimiter));
		return Array.fromList(untyped __dart__("{0}.split({1})", this, delimiter));
		// return cast(this).split(delimiter);
		// return @:privateAccess Array.fromList(cast(this).split(delimiter));
	inline function substr(pos:Int, ?len:Int):String
		return StringImpl.substr(this, pos, len);
	inline function substring(startIndex:Int, ?endIndex:Int):String
		return StringImpl.substring(this, startIndex, endIndex);
	function toString():String;

	// for StringTools.(unsafe|fast)CodeAt
	private inline function cca(i:Int):Int return charCodeAt(i) ?? -1;

	@:pure static function fromCharCode(code:Int):String;
}
