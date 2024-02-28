package haxe.ds;

@:coreApi class ObjectMap<K:{}, V> implements haxe.Constraints.IMap<K, V> {
    var _m:dart.core.Map<K, V>;

    public function new()
        _m = new dart.core.Map();

    public function set(key:K, value:V):Void
        untyped _m[key] = value;

    public function get(key:K):Null<V>
        return untyped _m[key];

    public function exists(key:K):Bool
        return _m.containsKey(key);

    public function remove(key:K):Bool
        return _m.remove(key) != null;

    public function keys():Iterator<K>
        return new dart.HaxeIterator(_m.keys.iterator);

    public function iterator():Iterator<V>
        return new dart.HaxeIterator(_m.values.iterator);

    public function keyValueIterator():KeyValueIterator<K, V>
        return new haxe.iterators.MapKeyValueIterator(this);

    public function copy():ObjectMap<K,V> {
        final result = new ObjectMap();
        result._m = dart.core.Map.of(_m);
        return result;
    }

    public function toString():String
        return untyped _m.toString();

    public function clear():Void
        return _m.clear();
}