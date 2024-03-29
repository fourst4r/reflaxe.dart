/*
 * Copyright (C)2005-2019 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

 package haxe;

 /**
     This type unifies with any function type.
 
     It is intended to be used as a type parameter constraint. If used as a real
     type, the underlying type will be `Dynamic`.
 **/
 @:callable
 abstract Function(Dynamic) {}
 
 /**
     This type unifies with an enum instance if all constructors of the enum
     require no arguments.
 
     It is intended to be used as a type parameter constraint. If used as a real
     type, the underlying type will be `Dynamic`.
 **/
 abstract FlatEnum(Dynamic) {}
 
 /**
     This type unifies with anything but `Void`.
 
     It is intended to be used as a type parameter constraint. If used as a real
     type, the underlying type will be `Dynamic`.
 **/
 abstract NotVoid(Dynamic) { }
 
 /**
     This type unifies with any instance of classes that have a constructor
     which
 
       * is `public` and
       * unifies with the type used for type parameter `T`.
 
     If a type parameter `A` is assigned to a type parameter `B` which is constrained
     to `Constructible<T>`, A must be explicitly constrained to
     `Constructible<T>` as well.
 
     It is intended to be used as a type parameter constraint. If used as a real
     type, the underlying type will be `Dynamic`.
 **/
 abstract Constructible<T>(Dynamic) {}
 
 #if dart
 /** IMap gets obliterated by DCE... **/
 @:keep
 #end
 interface IMap<K, V> {
     function get(k:K):Null<V>;
     function set(k:K, v:V):Void;
     function exists(k:K):Bool;
     function remove(k:K):Bool;
     function keys():Iterator<K>;
     function iterator():Iterator<V>;
     function keyValueIterator():KeyValueIterator<K, V>;
     function copy():IMap<K, V>;
     function toString():String;
     function clear():Void;
 }
 