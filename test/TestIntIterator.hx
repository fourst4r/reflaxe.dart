import dart.Lib.assert;

function aeq<T>(a:Array<T>, b:Array<T>) {
    for (i in 0...a.length) {
        assert(a[i] == b[i]);
    }
}

function main() {
    var ii = new IntIterator(0, 2);
    assert(ii.hasNext() == true);
    assert(ii.next() == 0);
    assert(ii.hasNext() == true);
    assert(ii.next() == 1);
    assert(ii.hasNext() == false);
    var ii = new IntIterator(0, 2);
    var r = [];
    for (i in ii)
        r.push(i);
    (aeq(r,[0, 1]));
    for (i in ii)
        r.push(i);
    (aeq(r, [0, 1]));
}