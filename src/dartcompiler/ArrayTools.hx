package dartcompiler;

class ArrayTools {
    public static inline function first<T>(a:Array<T>)
        return a.length > 0 ? a[0] : null;
}