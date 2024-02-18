package dartcompiler;

#if (macro || dart_runtime)

enum abstract Meta(String) to String {
    /** Replaces the name part of an expression with the given string. **/
    var Native = ":native";
    var NativeName = ":nativeName";
    /** Replaces the entire expression with the given string, including type parameters. **/
    var NativeCode = ":nativeCode";
    var NativeFunctionCode = ":nativeFunctionCode";
    var Initializer = ":dart.initializer";
    var Import = ":dart.import";
    var TopLevel = ":dart.topLevel";
    var ExtensionType = ":dart.extensionType";

    // internal compiler metas
    var LateCtor = ":dart.lateCtor";
    var DummyCtor = ":dart.dummyCtor";
    var InjectExpr = ":dart.injectExpr";
}

#end