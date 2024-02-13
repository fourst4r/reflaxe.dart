package dartcompiler;

#if (macro || dart_runtime)

import haxe.macro.Expr;

class MetaAccessor {
    var _meta:Metadata;

    public function new(?meta:Metadata)
        _meta = meta ?? [];

    public function get():Metadata
        return _meta;

    public function extract(name:String):Array<MetadataEntry>
        return _meta.filter(e -> e.name == name);

    public function add(name:String, params:Array<Expr>, pos:Position):Void
        _meta.push({name: name, params: params, pos: pos});

    public inline function remove(name:String):Void
        _meta = _meta.filter(e -> e.name != name);

    public function has(name:String):Bool
        return _meta.exists(e -> e.name == name);
}

#end