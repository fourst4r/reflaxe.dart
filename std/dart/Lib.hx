package dart;

extern inline function assert(condition:Bool, ?message:String)
    return untyped __dart__("assert({0}, {1})", condition, message);