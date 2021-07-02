[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)

Chapter 1 - Hello World
=======================

In your command-line shell, navigate to the `./ch1` directory.

Expressions and Evaluation
------

Generally speaking, computation is the transformation of information according to a defined process.
Haskell is a language for describing a certain kind of information and is accompanied by a defined
process for transforming it. The kind of information described in Haskell is a syntactic arrangement
of symbols called an **expression**. To use an analogy, an English sentence could be called an
expression, as it is a series of words (symbols) arranged according to English grammar (syntax).
But Haskell expressions have their own grammar, which will be introduced over the course of
this tutorial.

The process for transforming expressions, called **evaluation**, is the iterative replacement of
symbols or groups of symbols in the expression, called **sub-expressions**, with other expressions
by following defined rules. For instance if we have a rule that tells us to replace `a + b`
with the sum of `a` and `b`, then `1 + 2 + 3` can be evaluated as follows:

1. `1 + 2 + 3` - start
2. `3 + 3` - replace the subexpression `1 + 2` with `3`
3. `6` - replace `3 + 3` with `6`

For some expressions, this process can go on forever unless interrupted. For others, like the above
example, evaluation eventually reaches a point where it can go no further, and the resulting
expression is said to be **fully evaluated**. A fully evaluated expression is called a **value**.
Thus `6` is a value. Also, since evaluation rules are defined such that they always lead to the
same result, it can be said that `6` is *the* value of `1 + 2 + 3`.

Let's play with some simple Haskell expressions. We'll use GHCi, a tool that comes with GHC for
working with Haskell interactively. In your command-line shell, run `ghci`. It should present you
with something like this:

```console
GHCi, version 8.10.4: https://www.haskell.org/ghc/  :? for help
Prelude>
```

**Note:** You can exit GHCi at any time by entering `:q`.

The most common use for GHCi is to have it evaluate Haskell expressions.  If you enter a Haskell
expression, it will attempt to fully evaluate it and respond with its value. If what you enter
isn't a valid expression, you will get an error message. 

Try entering each of the below expressions to see how it responds:

1. `1.35`
2. `"Hello"`
3. `('a', True)`
4. `[5,6,7]`
5. `1 / 3`
6. `-9 * (1 + 8) `
7. `'b' == 'c'`
8. `"Super" ++ "man"`
9. `(1 + 1 == 2, [1,2] ++ [3,4])`

Literals and Variables
---------

The simplest of expressions are those composed of a single symbol. There are some single-symbol values
specially defined by the language called **literals**. Four kinds of literals exist: integer,
[floating](https://en.wikipedia.org/wiki/Floating-point_arithmetic), character, and string. Here are some
examples of each, which you can enter into GHCi to see its output:

- Integer Literals: `100`, `35`, `0x23` (hexadecimal notation for 35), `0o23` (octal notation for 19)
- Floating Literals: `3.14159`, `2.0`, `5e3`, `6.2E-3`
- Character Literals: `'a'`, `','`, `'\n'` (the "newline" character), `'\65'` (the character
  with unicode numeric representation 65; equivalent to `'A'`)
- String Literals: `"Hello World"`, `"\65\65\65"` (equivalent to `"AAA"`), `"Three\nLine\nString"`

**Variables** are another kind of single-symbol expression, only these are defined by the programmer,
and they exist to represent *another* expression. A variable is defined through a mechanism called
**binding**, which entails specifying a name for it along with the expression it should stand for.
Evaluation of any variable always starts by replacing it with the expression it is bound to.

It should be noted that every variable has a limited context, or **scope**, in which it exists.
Different scopes may have different variables with the same name bound to different expressions.
If a variable is bound in the current context, it is said to be "in scope".

One way to bind a variable is called a **let binding**, which looks like this:

`let x = 1 + 2 in x * x`

What this does is bind a variable named `x` to the expression `1 + 2` with a scope limited to the
let binding itself. A let binding is also an expression, and evaluating it entails evaluating
the expression after the `in` in a context where the variable is bound. Try it out by
entering it into GHCi. Here are a few more examples to try:

1. `let h = "Hello" in (h, h)`
2. `let num = 5 in num == 5`
3. `let notUsed = 500 in "Hello"`
4. `let _Foo = 1 in let bar' = 2 in _Foo + bar'`

That last example works because, again, let bindings are expressions, and *any* expression can be
placed after the `in`. However, this isn't typically done because you can bind multiple variables
in a single let binding, so it can be rewritten like this:

`let { _Foo = 1; bar' = 1 } in _Foo + bar'`

These variables are in scope for the *whole* let binding, so the expressions bound to the variables
may refer to the variables themselves, and it doesn't matter which order they come in:

`let { a = b; b = 3 + 1; c = a } in a + c`

**Note:** Variable names must start with a *lowercase* letter or an underscore (`_`), while the remaining
characters may be letters, digits, apostrophes (`'`), and underscores. Within those constraints,
you can name them whatever you want.

Functions
---------

A **function** is a value that describes how to build an expression from another expression, if one
were to be supplied.  When a function is supplied with an expression to use, it is said that the
function is **applied** to an **argument**. Here is an example of a function:

`\x -> x + x`

**Note:** Functions cannot be displayed by GHCi, so if you enter the above into it, you will get an error.

The `\x` introduces a variable, `x`, that will be bound to the argument when the function is applied to one.
Such variables are called **parameters**. Parameters are bound to arguments *per* function application,
so in one application `x` can be bound to `1`, while in another it can be bound to `2`. The scope of this
parameter is the entire expression after the `->`.

To apply a function, you simply put the argument after the function separated by whitespace. However,
function syntax is greedy and assumes that everything after the `->` is part of its result expression,
so `\x -> x + x 5` will not work. To resolve this you can wrap the function in parentheses:

`(\x -> x + x) 5`

Now, while a *function* is a value, and thus cannot be evaluated any further, a function *application*
such as this can be. Evaluation entails replacing the function and its argument with a let binding that
binds the parameter to the argument and evaluates the expression inside the function. So for example, 
the above expression is evaluated like this:

1. `(\x -> x + x) 5` - start
2. `let x = 5 in x + x` - bind the parameter to the argument
3. `5 + 5` - evaluate the `x`s by replacing them with bound expression, `5`
4. `10`

Another way to apply a function is to bind a variable to it and apply that:

`let f = \x -> x + 1 in f 5`

When binding a variable to a function, there is a simpler alternative syntax (also known as "syntax sugar")
that allows you to rewrite the above expression as:

`let f x = x + 1 in f 5`

Go ahead and try entering those examples into GHCi along with these:

1. `(\x -> "Hello, " ++ x) "World!"`
2. `(\notUsed -> [1,2,3]) 100`
3. `let g x = x * 2 in (g 10, g 20)`
4. `let h a = a + 1 in h 5 * 2`
5. `let h a = a + 1 in h (5 * 2)`
6. `(\x -> \y -> x * y + 1) 5 2`

That last example works because functions are values (which are expressions), and any valid expression
may follow the `->`. So the function with parameter `x` is given `5` as an argument and builds an
expression that is another function with `x` replaced by `5`, like: `\y -> 5 * y + 1`. Then *that* function
is given `2` as an argument and builds an arithmetic expression that uses both `5` and `2`,

That example can also be rewritten using syntax sugar as:

`let f x y = x * y + 1 in f 5 2`

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

[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)
