
import haxe.ds.List;

abstract AbstractInt(List<Int>) {
  public function new() {
    this = new List();
  }
  
  public function add1() {
		return this.length;
  }
}

function main() {
    var a = new AbstractInt();
    trace(a.add1());
    trace(a);
  }
