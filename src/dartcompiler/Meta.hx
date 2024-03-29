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
    /** Declares static function to be a named constructor. **/
    var NamedCtor = ":dart.namedCtor";
    /** Declares named function argument. **/
    var Named = "dart_named";
    /** Marks a function argument type as covariant. **/
    var Covariant = ":dart.covariant";
    /** Lazy way to get around Haxe compiler not keeping arg metas... **/
    var ArgMeta = ":dart.argMeta";

    // internal compiler metas
    var LateCtor = ":dart.lateCtor";
    var DummyCtor = ":dart.dummyCtor";
    var InjectClasses = ":dart.injectClasses";
    var InjectEnums = ":dart.injectEnums";
}

#end