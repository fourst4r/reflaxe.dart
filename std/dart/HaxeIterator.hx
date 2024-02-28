package dart;

@:nullSafety(Strict)
final class HaxeIterator<E> {
    var _it:dart.core.Iterator<E>;
    var _hasNext:Null<Bool>;
    
    public function new(it:dart.core.Iterator<E>) 
        _it = it;
    
    public function hasNext():Bool
        return _hasNext ??= _it.moveNext();

    public function next():E {
        if (_hasNext ??= _it.moveNext()) {
            _hasNext = null;
            return _it.current;
        }
        throw "no more elements";
    }
}