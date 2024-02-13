package dartcompiler;

// Make sure this code only exists at compile-time.

#if (macro || dart_runtime)

// Import relevant Haxe macro types.
import haxe.macro.Type;
import haxe.macro.TypedExprTools;

// Import Reflaxe types
import reflaxe.helpers.Context;
import reflaxe.GenericCompiler;
import reflaxe.data.ClassFuncData;
import reflaxe.data.ClassVarData;
import reflaxe.data.EnumOptionData;
import reflaxe.output.DataAndFileInfo;
import reflaxe.output.StringOrBytes;
import reflaxe.compiler.TargetCodeInjection;
import reflaxe.compiler.TypeUsageTracker;

import dartcompiler.filters.*;

/**
	The class used to compile the Haxe AST into your target language's code.

	This must extend from `BaseCompiler`. `PluginCompiler<T>` is a child class
	that provides the ability for people to make plugins for your compiler.
**/
class Compiler extends GenericCompiler<DartPrinter, DartPrinter, DartPrinter, DartPrinter, DartPrinter> {
	var _printer:Null<DartPrinter>;
	var _mainModule:Null<ModuleType>;
	var _imports:Map<String, String> = [];

	public function new() {
		super();
	}

	override function onCompileEnd() {

			// _printer.clear();
			// _printer.printMain();
			// setExtraFile("main.dart", _printer.toString());
			trace("outputDir="+output.outputDir);
	}

	function mkPrinter() {
		return new DartPrinter(this, "  ", "\n");
	}

	override function setupModule(mt:Null<ModuleType>) {
		super.setupModule(mt);

		_printer = mkPrinter();

		if (typeUsage != null) {
			_printer.writeln('// TYPE USAGE FOR ${mt.getCommonData().qualifiedName()}');
			for (k => v in typeUsage) {
				for (m in v) {
					switch (m) {
						case EType(t): 
							//_printer.printType(t);
						case EModuleType(mt): 

						final classType = mt.getCommonData();
						if (classType.hasMeta(Meta.Import)) {
							var pkg = classType.meta.extractStringFromFirstMeta(Meta.Import);
							var native = _imports.get(pkg);
							var og = pkg;

							if (native == null) {

								native = pkg.replace(".dart", "");
								native = native.replace("/", "_");
								native = native.replace(":", "_");
								native = native.replace(".", "_");
								_imports.set(pkg, native);

								if (!classType.hasMeta(Meta.TopLevel))
									native += "." + classType.getNameOrNativeName();

							}

							classType.meta.add(Meta.Native, [macro $v{native}], classType.pos);
							trace('$og => $native');
							
						}

						_printer.write('// ');
						_printer.write(mt.getCommonData().qualifiedName());
						_printer.write(' -- ${mt.getCommonData().importPrefix()}');
						_printer.writeln();
					}
				}
			}
		}
		
		if (getCurrentModule()?.getUniqueId() == getMainModule()?.getUniqueId()) {
			_printer.printMain();
			
		}

	}

	public override function compileTypedefImpl(def: DefType): Null<DartPrinter> {
		return switch (def.type) {
            case TAnonymous(_.get().status => AClassStatics(_)|AEnumStatics(_)|AAbstractStatics(_)):
				null;
            default:
				_printer.printTypedef(def);
				_printer;
        }
	}

	public function compileClassImpl(classType: ClassType, varFields: Array<ClassVarData>, funcFields: Array<ClassFuncData>): Null<DartPrinter> {
		
		final cd = new LateSuper().filterClass({classType: classType, varFields: varFields, funcFields: funcFields});
		_printer.printClass(cd.classType, cd.varFields, cd.funcFields);
		
		return _printer;
	}

	public function compileEnumImpl(enumType: EnumType, constructs: Array<EnumOptionData>): Null<DartPrinter> {
		_printer.printEnum(enumType, constructs);
		return _printer;
	}

	// public override function compileAbstractImpl(abstractType: AbstractType): Null<DartPrinter> {
	// 	_printer.printAbstract(abstractType);
	// 	return _printer;
	// }

	/**
		This is the final required function.
		It compiles the expressions generated from Haxe.
		
		PLEASE NOTE: to recusively compile sub-expressions:
			BaseCompiler.compileExpression(expr: TypedExpr): Null<String>
			BaseCompiler.compileExpressionOrError(expr: TypedExpr): String
		
		https://api.haxe.org/haxe/macro/TypedExpr.html
	**/
	public function compileExpressionImpl(expr: TypedExpr, topLevel: Bool): Null<DartPrinter> {
		
		if(options.targetCodeInjectionName != null) {
			final result = checkTargetCodeInjection(options.targetCodeInjectionName, expr);
			if(result != null) {
				return _printer;
			}
		}

		expr = new BinopPrecedence().filterExpr(expr);

		_printer.printExpr(expr, topLevel);
		return _printer;
	}

	public function checkTargetCodeInjection(injectFunctionName: String, expr: TypedExpr): Null<DartPrinter> {

		switch (expr.expr) {
			case TCall({expr: TIdent(id)}, el) if (id == injectFunctionName && el.length > 0):

				var code = switch (el[0].expr) {
					case TConst(TString(s)): s;
					default: Context.error(injectFunctionName + " first parameter must be a constant String.", el[0].pos);
				}
				
				function compileArg(n) {
					if (n+1 >= el.length)
						Context.error('argument $n not supplied', el[el.length-1].pos);
					compileExpression(el[n+1]);
				}
				
				// trace('code=$code');
				final pattern = ~/{(\d+)}/;
				if (pattern.match(code)) {
					var pos;
					do {
						final matched = pattern.matched(1);
						final arg = Std.parseInt(matched) ?? throw "impossible";

						_printer.write(pattern.matchedLeft());
						// trace('${pattern.matchedLeft()}{$matched}');
						compileArg(arg);
						
						pos = pattern.matchedPos();
						code = code.substr(pos.pos+pos.len);
					} while (pattern.match(code));
					_printer.write(code);
				} else {
					_printer.write(code);
				}
				
			default: 
				return null;
		}

		return _printer;

		// return if(callIdent == injectFunctionName && arguments != null) {
		// 	if(arguments.length == 0) {
		// 		Context.error(injectFunctionName + " requires at least one String argument.", expr.pos);
		// 	}

		// 	final injectionString: String = switch(arguments[0].expr) {
		// 		case TConst(TString(s)): s;
		// 		case _: {
		// 			Context.error(injectFunctionName + " first parameter must be a constant String.", arguments[0].pos);
		// 		}
		// 	}

		// 	// Initially fill all arguments as `null`.
		// 	final injectionArguments = [ for(_ in 1...arguments.length) null ];

		// 	// Use function so we only compile arguments that are used
		// 	function getArg(i: Int) {
		// 		return if(i < injectionArguments.length) {
		// 			if(injectionArguments[i] == null) {
		// 				final oldprinter = _printer;
		// 				final arg = compiler.compileExpression(arguments[i + 1]);

		// 				if(arg == null) {
		// 					Context.error("Compiled expression resulted in nothing.", arguments[i].pos);
		// 				} else {
		// 					injectionArguments[i] = arg.toString();
		// 				}
		// 			}
		// 			injectionArguments[i];
		// 		} else {
		// 			null;
		// 		}
		// 	}

		// 	// Find all instances of {NUMBER} and replace with argument if possible
		// 	final result = ~/{(\d+)}/g.map(injectionString, function(ereg) {
		// 		final num = Std.parseInt(ereg.matched(1));
		// 		return (num != null ? getArg(num) : null) ?? ereg.matched(0);
		// 	});


		// } else {
		// 	null;
		// }
	}

	/**
		Compiles the {this} expression for `@:nativeFunctionCode`.
	**/
	public function compileNFCThisExpression(expr: TypedExpr, meta: Null<MetaAccess>): DartPrinter {
		return compileExpressionOrError(expr); 
	}

	/**
		This function is for compiling the result of functions
		using the `@:nativeFunctionCode` meta.
	**/
	public function compileNativeFunctionCodeMeta(callExpr: TypedExpr, arguments: Array<TypedExpr>, typeParamsCallback: Null<(Int) -> Null<String>> = null, custom: Null<(String) -> String> = null): Null<String> {
		final declaration = callExpr.getDeclarationMeta(arguments);
		if(declaration == null) {
			return null;
		}

		final meta = declaration.meta;
		final data = meta != null ? extractStringFromMeta(meta, ":nativeFunctionCode") : null;
		if(data == null) {
			return null;
		}

		final code = data.code;
		var result = code;

		var oldprinter = _printer;
		_printer = new DartPrinter(this, "  ", "\n");

		// Handle {this}
		if(code.contains("{this}")) {
			final thisExpr = declaration.thisExpr != null ? compileNFCThisExpression(declaration.thisExpr, declaration.meta) : null;
			if(thisExpr == null) {
				if(declaration.thisExpr == null) {
					#if eval
					Context.error("Cannot use {this} on @:nativeFunctionCode meta for constructors.", data.entry.pos);
					#end
				} else {
					onExpressionUnsuccessful(callExpr.pos);
				}
			} else {
				result = result.replace("{this}", thisExpr.toString());
			}
		}

		_printer.clear();
		// Handle {argX}
		var argExprs: Null<Array<String>> = null;
		for(i in 0...arguments.length) {
			final key = "{arg" + i + "}";
			if(code.contains(key)) {
				if(argExprs == null) {
					argExprs = arguments.map(function(e) {
						_printer.clear();
						return this.compileExpressionOrError(e).toString();
					});
				}
				if(argExprs[i] == null) {
					onExpressionUnsuccessful(arguments[i].pos);
				} else {
					result = result.replace(key, argExprs[i]);
				}
			}
		}

		// Handle {typeX} if `typeParamsCallback` exists
		if(typeParamsCallback != null) {
			final typePrefix = "{type";

			var typeParamsResult = null;
			var oldIndex = 0;
			var index = result.indexOf(typePrefix); // Check for `{type`
			while(index != -1) {
				// If found, figure out the number that comes after
				final startIndex = index + typePrefix.length;
				final endIndex = result.indexOf("}", startIndex);
				final numStr = result.substring(startIndex, endIndex);
				final typeIndex = Std.parseInt(numStr);
				
				// If the number if valid...
				if(typeIndex != null && !Math.isNaN(typeIndex)) {
					// ... add the content before this `{type` to `typeParamsResult`.
					if(typeParamsResult == null) typeParamsResult = "";
					typeParamsResult += result.substring(oldIndex, index);

					// Compile the type
					final typeOutput = typeParamsCallback(typeIndex);
					if(typeOutput != null) {
						typeParamsResult += typeOutput;
					}
				}

				// Skip past this {typeX} and search again.
				oldIndex = endIndex + 1;
				index = result.indexOf(typePrefix, oldIndex);
			}
			// Modify "result" if processing occurred.
			if(typeParamsResult != null) {
				typeParamsResult += result.substr(oldIndex);
				result = typeParamsResult;
			}
		}

		// Apply custom transformations
		if(custom != null) {
			result = custom(result);
		}

		_printer = oldprinter;

		return result;
	}

	/**
		This function is for compiling the result of functions
		using the `@:nativeTypeCode` meta.
	**/
	public function compileNativeTypeCodeMeta(type: Type): Null<DartPrinter> {
		final meta = type.getMeta() ?? return null;
		final params = type.getParams();
		final meta = extractStringFromMeta(meta, Meta.NativeCode) ?? return null;

		PrinterTools.eregMap(_printer, ~/{type(\d+)}/, meta.code, capture -> {
			trace(capture);
			final n = Std.parseInt(capture) ?? throw "impossible";
			if (n < 0 || n >= params.length)
				Context.error('invalid param number: $n', meta.entry.pos);

			_printer.printType(params[n]);
		});

		return _printer;
	}

	public function generateOutputIterator():Iterator<DataAndFileInfo<StringOrBytes>> {
		trace("generateOutputIterator");
		final all = classes.concat(enums).concat(typedefs).concat(abstracts);
		
		final p = mkPrinter();
		for (pkg => name in _imports)
			p.printImport(pkg, name);
		p.printFooter();
		all.unshift(all[0].with(p));
		
		var index = 0;
		return {
			hasNext: () -> index < all.length,
			next: () -> {
				final data = all[index++];
				return data.withOutput(data.data.toString());
			}
		}
	}


}

#end
