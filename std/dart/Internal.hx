package dart;

import dart.core.Function;

/** Typed interface for the internal Class<T> structure. **/
typedef ClassInternal<T> = {
    final name:String;
    final superName:Null<String>;
    final classFields:Array<String>;
    final instanceFields:Array<String>;
    final createInstance:Function;
    final createEmptyInstance:Function;
}

/** Typed interface for the internal Enum<T> structure. **/
typedef EnumInternal<T> = {
    final name:String;
    final constructs:Array<String>;
    final enums:Array<EnumValue>;
    final createEnum:Function;
    final createEnumIndex:Function;
}

