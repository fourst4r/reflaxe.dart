package dartcompiler.filters;

#if (macro || dart_runtime)

import haxe.macro.Type;
import reflaxe.data.ClassVarData;
import reflaxe.data.ClassFuncData;

typedef ClassDef = {
    classType: ClassType, varFields: Array<ClassVarData>, funcFields: Array<ClassFuncData>
}

#end