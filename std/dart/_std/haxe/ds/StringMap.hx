package haxe.ds;

@:coreApi class StringMap<T> implements haxe.Constraints.IMap<String, T> {
    var _m:dart.core.Map<String, T>;

	public inline function new()
        _m = new dart.core.Map();

    @:native("StringMap.blank")
    static inline function blank():StringMap<T> {}


	public inline function set(key:String, value:T):Void
        untyped _m[key] = value;

	public inline function get(key:String):Null<T>
        return untyped _m[key];

	public inline function exists(key:String):Bool
        return _m.containsKey(key);

	public inline function remove(key:String):Bool
        return _m.remove(key) != null;

	public inline function keys():Iterator<String>
        return new dart.HaxeIterator(_m.keys.iterator);

	public inline function iterator():Iterator<T>
        return new dart.HaxeIterator(_m.values.iterator);

	public inline function keyValueIterator():KeyValueIterator<String, T>
        return new haxe.iterators.MapKeyValueIterator(this);

	public inline function copy():StringMap<T> {
        final result = new StringMap();
        result._m = dart.core.Map.of(_m);
        return result;
    }

	public inline function toString():String
        return untyped _m.toString();

	public inline function clear():Void
        return _m.clear();
}
