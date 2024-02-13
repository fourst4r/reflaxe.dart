package dartcompiler;

#if (macro || dart_runtime)

class PrinterTools {
    public static function eregMap(p:Printer, pattern:EReg, s:String, fn:String->Void) {
        if (pattern.match(s)) {
            var i = 1, pos;
            do {
                final matched = pattern.matched(i++);

                p.write(pattern.matchedLeft());
                fn(matched);
                
                pos = pattern.matchedPos();
            } while (pattern.matchSub(s, pos.pos+pos.len));
            p.write(s.substr(pos.pos+pos.len));
        } else {
            p.write(s);
        }
    }
}

#end