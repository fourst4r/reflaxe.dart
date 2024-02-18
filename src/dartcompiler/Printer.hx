package dartcompiler;

#if (macro || dart_runtime)

class Printer {
    var _level:Int;
    var _buf:StringBuf;
    var _beginLine:Bool;
    final _indent:String;
    final _newline:String;

    public function new(indent:String, newline:String) {
        _indent = indent;
        _newline = newline;
        _beginLine = false;
        clear();
    }

    public inline function indent()
        _level++;

    public inline function unindent()
        _level--;

    public function write(s:String) {
        if (_beginLine) {
            tab();
            _beginLine = false;
        }
        _buf.add(s);
    }

    public function writeln(s:String = "") {
        write(s);
        newline();
    }

    function newline() {
        _buf.add(_newline);
        _beginLine = true;
    }

    public function tab() {
        for (_ in 0..._level)
            _buf.add(_indent);
    }

    public inline function clear() {
        _level = 0;
        _buf = new StringBuf();
    }

    public function toString()
        return _buf.toString();
}

#end