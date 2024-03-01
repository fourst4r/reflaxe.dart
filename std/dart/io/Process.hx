package dart.io;

import dart.convert.Encoding;

@:dart.import("dart:io")
extern class Process {
    static function runSync(
        executable:String,
        arguments:List<String>,
        @:dart.named workingDirectory:Null<String>,
        @:dart.named environment:Null<Map<String,String>>,
        @:dart.named includeParentEnvironment:Bool = true,
        @:dart.named runInShell:Bool = false,
        @:dart.named ?stdoutEncoding:Encoding,
        @:dart.named ?stderrEncoding:Encoding
    ):ProcessResult;
}