package;

import dart.io.Platform;
import dart.io.Directory;
import dart.core.Duration;
import haxe.ds.StringMap;

//  @:coreApi
class Sys {
    public static inline function time():Float
        return dart.core.DateTime.now().millisecondsSinceEpoch;
 
    public static function exit(code:Int):Void
        dart.io.Lib.exit(code);
 
    public static inline function print(v:Dynamic):Void
        dart.io.Lib.stdout.write(v);
 
    public static inline function println(v:Dynamic):Void {
        untyped print(v);
    }
 
    public static function args():Array<String>
        return @:privateAccess Array.fromList(Platform.executableArguments);
 
    public static function getEnv(s:String):Null<String>
        return untyped Platform.environment[s];
 
    public static function putEnv(s:String, v:Null<String>):Void {
        throw new haxe.exceptions.NotImplementedException();
    }
 
     public static function environment():Map<String, String> {
         final environ = new StringMap();
        //  final env = Platform.environment;
        //  for (key in env.keys) {
        //     environ.set(key, env[key]);
        //  }
         return environ;
     }
 
    public static function sleep(seconds:Float):Void
        return dart.io.Lib.sleep(new Duration(0, 0, 0, 0, Std.int(seconds*1000)));
 
    public static function setTimeLocale(loc:String):Bool {
        return false;
    }
 
    public static function getCwd():String {
        return Directory.current.path;
    }
 
    public static function setCwd(s:String):Void {
        Directory.current = new Directory(s);
    }
 
    public static function systemName():String {
        return if (Platform.isLinux) 
            "Linux";
        else if (Platform.isMacOS) 
            "Mac";
        else if (Platform.isWindows) 
            "Windows";
        else 
            throw "not supported platform";
    }
 
    //  public static function command(cmd:String, ?args:Array<String>):Int {
    //      return if (args == null)
    //          python.lib.Subprocess.call(cmd, {shell: true});
    //      else
    //          python.lib.Subprocess.call([cmd].concat(args));
    //  }
 
    //  public static inline function cpuTime():Float {
    //      return python.lib.Timeit.default_timer();
    //  }
 
    @:deprecated("Use programPath instead") public static function executablePath():String {
        return Platform.resolvedExecutable;
    }
 
    public static function programPath():String {
        return Platform.script.toString();
    }
 
    //  public static function getChar(echo:Bool):Int {
    //      var ch = switch (systemName()) {
    //          case "Linux" | "Mac":
    //              var fd = python.lib.Sys.stdin.fileno();
    //              var old = python.lib.Termios.tcgetattr(fd);
 
    //              var restore = python.lib.Termios.tcsetattr.bind(fd, python.lib.Termios.TCSADRAIN, old);
 
    //              try {
    //                  python.lib.Tty.setraw(fd);
    //                  var x = python.lib.Sys.stdin.read(1);
    //                  restore();
    //                  x.charCodeAt(0);
    //              } catch (e:Dynamic) {
    //                  restore();
    //                  throw e;
    //              }
 
    //          case "Windows":
    //              // python.lib.Msvcrt.getch().decode("utf-8").charCodeAt(0);
    //              python.lib.Msvcrt.getwch().charCodeAt(0);
    //          case var x:
    //              throw "platform " + x + " not supported";
    //      }
    //      if (echo) {
    //          python.Lib.print(String.fromCharCode(ch));
    //      }
    //      return ch;
    //  }
 
    //  public static function stdin():haxe.io.Input {
    //      return python.io.IoTools.createFileInputFromText(python.lib.Sys.stdin);
    //  }
 
    //  public static function stdout():haxe.io.Output {
    //      return python.io.IoTools.createFileOutputFromText(python.lib.Sys.stdout);
    //  }
 
    //  public static function stderr():haxe.io.Output {
    //      return python.io.IoTools.createFileOutputFromText(python.lib.Sys.stderr);
    //  }
}
 