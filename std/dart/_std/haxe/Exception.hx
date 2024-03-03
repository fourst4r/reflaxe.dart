package haxe;


/**
	Base class for exceptions.

	If this class (or derivatives) is used to catch an exception, then
	`haxe.CallStack.exceptionStack()` will not return a stack for the exception
	caught. Use `haxe.Exception.stack` property instead:
	```haxe
	try {
		throwSomething();
	} catch(e:Exception) {
		trace(e.stack);
	}
	```

	Custom exceptions should extend this class:
	```haxe
	class MyException extends haxe.Exception {}
	//...
	throw new MyException('terrible exception');
	```

	`haxe.Exception` is also a wildcard type to catch any exception:
	```haxe
	try {
		throw 'Catch me!';
	} catch(e:haxe.Exception) {
		trace(e.message); // Output: Catch me!
	}
	```

	To rethrow an exception just throw it again.
	Haxe will try to rethrow an original native exception whenever possible.
	```haxe
	try {
		var a:Array<Int> = null;
		a.push(1); // generates target-specific null-pointer exception
	} catch(e:haxe.Exception) {
		throw e; // rethrows native exception instead of haxe.Exception
	}
	```
**/
@:coreApi class Exception implements dart.core.Exception {
    var _message:String;
    var _previous:Null<Exception>;
    var _native:Any;

	/**
		Exception message.
	**/
	public var message(get,never):String;
	private function get_message():String return _message;

	/**
		The call stack at the moment of the exception creation.
	**/
	public var stack(get,never):CallStack;
	private function get_stack():CallStack return [];

	/**
		Contains an exception, which was passed to `previous` constructor argument.
	**/
	public var previous(get,never):Null<Exception>;
	private function get_previous():Null<Exception> return _previous;

	/**
		Native exception, which caused this exception.
	**/
	public var native(get,never):Any;
	final private function get_native():Any return _native;

	/**
		Used internally for wildcard catches like `catch(e:Exception)`.
	**/
	static private function caught(value:Any):Exception {
        // if(Std.isOfType(value, Exception)) {
			return value;
		// } else {
			// return new Exception((value:CsException).Message, null, value);
		// }
    }

	/**
		Used internally for wrapping non-throwable values for `throw` expressions.
	**/
	static private function thrown(value:Any):Any {
        return value;
    }

	/**
		Create a new Exception instance.

		The `previous` argument could be used for exception chaining.

		The `native` argument is for internal usage only.
		There is no need to provide `native` argument manually and no need to keep it
		upon extending `haxe.Exception` unless you know what you're doing.
	**/
	public function new(message:String, ?previous:Exception, ?native:Any) {
        // super(message);
        _message = message;
        _previous = previous;
        _native = native;
    }

	/**
		Extract an originally thrown value.

		Used internally for catching non-native exceptions.
		Do _not_ override unless you know what you are doing.
	**/
	private function unwrap():Any {
        return null;
    }

	/**
		Returns exception message.
	**/
	public function toString():String {
        return _message;
    }

	/**
		Detailed exception description.

		Includes message, stack and the chain of previous exceptions (if set).
	**/
	public function details():String {
        return "TODO: details";
    }

	/**
		If this field is defined in a target implementation, then a call to this
		field will be generated automatically in every constructor of derived classes
		to make exception stacks point to derived constructor invocations instead of
		`super` calls.
	**/
	// @:noCompletion @:ifFeature("haxe.Exception.stack") private function __shiftStack():Void;
}
