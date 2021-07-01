[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)

Chapter 1 - Hello World
=======================

Declarations and Modules
-------

Haskell code consists of a set of **declarations**, or statements that declare something to be true.
The simplest example of a declaration is one that names a value. This is called a **binding**. For example,
the following binding declares that the number 5 can be referred to by the name `x`:

```hs
x = 5
```

Declarations are grouped into named organizational units called **modules**. To define a module called `Foo`
that contains the above binding along with a couple more, you can write:

```hs
module Foo where

x = 5
y = 6
z = 7
```

The declarations within a module can refer to each other.  For instance, in the following module, `y` is
declared to be a name for the same value as `x`:

```hs
module Foo where

x = 5
y = x
```

Declarations can appear in any order within the module, and this doesn't affect their ability to refer to one another.
For instance the above module can be rewritten:

```hs
module Foo where

y = x
x = 5
```

By default, declarations can only refer to others within the same module. However, a module may use an
**import statement**, which states that another module's declarations are available to be referenced.
All imports must appear at the top of the module. Here is an example of three modules, with one importing
the others and referring to their bindings:

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
