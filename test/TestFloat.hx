import dart.Lib.assert;

function main() {
var nan = Math.NaN;
var pinf = Math.POSITIVE_INFINITY;
var ninf = Math.NEGATIVE_INFINITY;
var fl:Float = 0.0;
trace(Math.min(1, 2));
assert(fl > nan == false);
assert(fl < nan == false);
assert(fl >= nan == false);
assert(fl <= nan == false);
assert(fl == nan == false);
assert(fl != nan == true);

assert(nan > nan == false);
assert(nan < nan == false);
assert(nan >= nan == false);
assert(nan <= nan == false);
assert(nan == nan == false);
assert(nan != nan == true);

assert(pinf > nan == false);
assert(pinf < nan == false);
assert(pinf >= nan == false);
assert(pinf <= nan == false);
assert(pinf == nan == false);
assert(pinf != nan == true);

assert(ninf > nan == false);
assert(ninf < nan == false);
assert(ninf >= nan == false);
assert(ninf <= nan == false);
assert(ninf == nan == false);
assert(ninf != nan == true);

assert(nan > fl == false);
assert(nan < fl == false);
assert(nan >= fl == false);
assert(nan <= fl == false);
assert(nan == fl == false);
assert(nan != fl == true);

assert(nan > pinf == false);
assert(nan < pinf == false);
assert(nan >= pinf == false);
assert(nan <= pinf == false);
assert(nan == pinf == false);
assert(nan != pinf == true);

assert(nan > ninf == false);
assert(nan < ninf == false);
assert(nan >= ninf == false);
assert(nan <= ninf == false);
assert(nan == ninf == false);
assert(nan != ninf == true);
}