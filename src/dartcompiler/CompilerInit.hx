package dartcompiler;

#if (macro || dart_runtime)

import reflaxe.ReflectCompiler;

class CompilerInit {
	public static function Start() {
		#if !eval
		Sys.println("CompilerInit.Start can only be called from a macro context.");
		return;
		#end

		#if (haxe_ver < "4.3.0")
		Sys.println("Reflaxe/Dart requires Haxe version 4.3.0 or greater.");
		return;
		#end

		ReflectCompiler.AddCompiler(new Compiler(), {
			fileOutputExtension: ".dart",
			outputDirDefineName: "dart-output",
			fileOutputType: SingleFile,
			reservedVarNames: reservedNames(),
			targetCodeInjectionName: "__dart__",
			smartDCE: true,
			trackUsedTypes: true,
			deleteOldOutput: true,
			preventRepeatVars: true,
			enforceNullTyping: false, // false because there are some unwanted optimizations
			convertNullCoal: false,
			defaultOutputFilename: "main",
			unwrapTypedefs: true,
			ignoreExterns: false,
		});
	}

	static function reservedNames() {
		return [
			"abstract",
			"else",
			"import",
			"show",
			"as",
			"enum",
			"in",
			"static",
			"assert",
			"export",
			"interface",
			"super",
			"async",
			"extends",
			"is",
			"switch",
			"await",
			"extension",
			"late",
			"sync",
			"base",
			"external",
			"library",
			"this",
			"break",
			"factory",
			"mixin",
			"throw",
			"case",
			"false",
			"new",
			"true",
			"catch",
			"final",
			"null",
			"try",
			"class",
			"on",
			"typedef",
			"const",
			"finally",
			"operator",
			"var",
			"continue",
			"for",
			"part",
			"void",
			"covariant",
			"Function",
			"required",
			"when",
			"default",
			"get",
			"rethrow",
			"while",
			"deferred",
			"hide",
			"return",
			"with",
			"do",
			"if",
			"sealed",
			"yield",
			"dynamic",
			"implements",
			"set",
			"int",
			"double",
			"num"
		];
	}
}

#end
