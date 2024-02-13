package dartcompiler;

#if (macro || dart_runtime)

enum abstract Meta(String) to String {
    /** Replaces the name part of an expression with the given string. **/
    var Native = ":native";
    /** Replaces the entire expression with the given string, including type parameters. **/
    var NativeCode = ":nativeCode";
    var NativeFunctionCode = ":nativeFunctionCode";
    var LateCtor = ":dart.lateCtor";
    var DummyCtor = ":dart.dummyCtor";
    var Initializer = ":dart.initializer";
    var Import = ":dart.import";
    var TopLevel = ":dart.topLevel";
}

#end