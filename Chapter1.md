[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)

Chapter 1 - Hello World
=======================

In your command-line shell, navigate to the `./ch1` directory.

Expressions
------

Generally speaking, computation is the transformation of information according to a defined process.
Haskell is a language for describing a certain kind of information and is accompanied by a defined
process for transforming it. The kind of information described in Haskell is called an **expression**,
which is a syntactic arrangement of symbols. The process for transforming expressions, called
**evaluation**, is the iterative use of rules for replacing symbols in the expression with other symbols.
For some expressions, this process can go on forever unless interrupted. For others, it eventually reaches
a point where it can go no further, and the resulting expression is said to be **fully evaluated**. A fully
evaluated expression is called a **value**.

Let's play with some simple Haskell expressions. In your command-line shell, run `ghci`. It should
present you with something like this:

```console
GHCi, version 8.10.4: https://www.haskell.org/ghc/  :? for help
Prelude>
```

This is a very useful interactive tool that comes with GHC. The most common use case is to enter a
Haskell expression, and it will attempt to fully evaluate it and respond with the resulting value.
If what you enter isn't a valid expression, you will get an error. You can exit GHCi at any time by
entering `:q`.

Try entering each of the below expressions, one at a time, to see how it responds:

```hs
1.35
"Hello"
('a', True)
[5,6,7]
1 / 3
-9 * (1 + 8) 
'b' == 'c'
"Super" ++ "man"
(1 + 1 == 2, [1,2] ++ [3,4])
```

If GHCi responded with exactly what you entered, then it was already a value. Otherwise, what it gave
you was the value resulting from fully evaluating the provided expression.

Declarations
-------

While the goal of Haskell code is to define expressions to be evaluated by a program, the form it takes
is that of a set of **declarations**, or statements that declare something to be true. The simplest example
of a declaration is one that names an expression. This is called a **binding**. These names are alphanumeric
and must begin with a lowercase letter. For example, the following binding declares that the expression
`1 + 2` can be referred to by the name `x`:

```hs
x = 1 + 2
```

As a result of the binding, the name `x` becomes a valid expression, and the binding essentially says that if
you ever need to evaluate `x`, the first step to do so is to replace it with the expression it is bound to. 

GHCi accepts bindings, so try entering the above into it.  Notice that it does not give you back a result
because it is a binding rather than an expression. Once that is in place, enter `x` and note the result.

Modules
-------

Outside of GHCi, when writing Haskell source code files, declarations are grouped into named organizational
units called **modules**.  Module names are alphanumeric and must begin with an uppercase letter.  They may
contain dots, so for instance, `Foo.Bar.Baz` is a valid module name. In GHC's implementation of Haskell,
each module is required to be in its own file named after the module and typically with a `.hs` file name
extension. Furthermore, the module name has a direct correspondence to the file's relative path within the
source code directory. The dots are interpreted to as directory separators, so for instance, `Foo.Bar.Baz`
is expected to be in `Foo/Bar/Baz.hs`.

Let's define a module called `Foo` that contains the above binding along with a couple more. Create a new
file called `Foo.hs` (assuming you're still in the `./ch1` directory) and write this to it:

```hs
module Foo where

x = 1 + 2
y = "Hello " ++ "there"
z = (True, 'b')
```

If you still have GHCi running (assuming you launched it from the `./ch1` directory), you can load this
module by entering `:load Foo`. If you don't, you can run `ghci Foo`, and it will load the module on
startup. Once loaded, `x`, `y`, and `z` are usable expressions, so you can enter them to see their
values displayed.

The declarations within a module (including bindings) can refer to each other regardless of the
order they are in. (This isn't true for bindings directly entered into GHCi; you can't refer to a
name that isn't bound yet.)  For instance, edit Foo.hs to look like this:

```hs
module Foo where

x = y
y = (1 + 2, z)
z = "Hello"
```

Load that into GHCi. (Note: If you still have a GHCi session open in which you loaded `Foo` previously,
you can just enter `:reload`.) Once loaded, you'll find that `x` evaluates to `(3, "Hello")` as expected. 

TODO: Continue Here
====

By default, declarations can only refer to others within the same module. However, a module may use an
**import statement** to state that another module's declarations are available to be referenced. All imports
must appear at the top of the module. Here is an example of three modules, with one importing the others and
referring to their bindings:

```hs
module Foo where

x = 5


module Bar where

y = 6


module Baz where

import Bar
import Foo

z = x
w = y
```

If a module is defined in the above way, then *all* of its declarations will be usable from any other
module that imports it. In other words, all of its declarations are **exported**. However, we can
refine this by giving it an explicit **export list**. Here is an example of a module exporting a
portion of its declarations:

```hs
module Foo(x, y) where

x = 5
y = z
z = 6
```

If another module were to import `Foo`, it would be able to refer to `x` and `y` but not to `z`.

There is a standard module called **Prelude** that is implicitly imported into all modules, so all
of its exported declarations can be immediately referred to from any other module. Here is an example
of a module referring to a declaration from Prelude called `pi`:

```hs
module Foo where

x = pi
```

In GHC's implementation of haskell, each module is required to be in its own file, typically with a `.hs`
file name extension. Furthermore, the module name has a direct correspondence to the file path relative
to the base source code directory. A module's name may include dots, so for instance, `A.B.C` is a valid
module name. The expected file path for this  module is `A/B/C.hs`. The earlier modules `Foo`, `Bar`,
and `Baz` would belong in files called `Foo.hs`, `Bar.hs`, and `Baz.hs` at the root of the source
code directory.

Packages
--------

...

[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)
