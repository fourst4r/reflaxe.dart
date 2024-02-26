package haxe.ds;

@:coreApi class IntMap<T> implements haxe.Constraints.IMap<Int, T> {
    var _m:dart.core.Map<Int, T>;

    public function new()
        _m = new dart.core.Map();

    public function set(key:Int, value:T):Void
        untyped _m[key] = value;

    public function get(key:Int):Null<T>
        return untyped _m[key];

    public function exists(key:Int):Bool
        return _m.containsKey(key);

    public function remove(key:Int):Bool
        return _m.remove(key) != null;

    public function keys():Iterator<Int>
        return new dart.HaxeIterator(_m.keys.iterator);

    public function iterator():Iterator<T>
        return new dart.HaxeIterator(_m.values.iterator);

    public function keyValueIterator():KeyValueIterator<Int, T>
        return new haxe.iterators.MapKeyValueIterator(this);

    public function copy():IntMap<T> {
        final result = new IntMap();
        result._m = dart.core.Map.of(_m);
        return result;
    }

    public function toString():String
        return untyped _m.toString();

    public function clear():Void
        return _m.clear();
}