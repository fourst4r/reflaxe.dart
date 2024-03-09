package dartcompiler;

class ArrayTools {
    public static inline function first<T>(a:Array<T>):Null<T>
        return a.length > 0 ? a[0] : null;

    public static function equalTo<T>(a:Array<T>, b:Array<T>):Bool {
        if (a.length != b.length)
            return false;
        for (i in 0...a.length)
            if (a[i] != b[i])
                return false;
        return true;
    }
}