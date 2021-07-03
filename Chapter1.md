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
But Haskell expressions have their own symbols and grammar, which will be introduced over the course
of this tutorial.

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

Literals
--------

The simplest of expressions are those composed of a single symbol. There are some single-symbol values
specially defined by the language called **literals**. Four kinds of literals exist: integer,
[floating](https://en.wikipedia.org/wiki/Floating-point_arithmetic), character, and string. Here are some
examples of each, which you can enter into GHCi to see its output:

- Integer Literals: `100`, `35`, `0x23` (hexadecimal notation for 35), `0o23` (octal notation for 19)
- Floating Literals: `3.14159`, `2.0`, `5e3`, `6.2E-3`
- Character Literals: `'a'`, `','`, `'\n'` (the "newline" character), `'\65'` (the character
  with unicode numeric representation 65; equivalent to `'A'`)
- String Literals: `"Hello World"`, `"\65\65\65"` (equivalent to `"AAA"`), `"Three\nLine\nString"`

Variables and Declarations
--------------------------

**Variables** are another kind of single-symbol expression, only these are defined by the programmer,
and they exist to represent *another* expression. A variable is defined through a mechanism called
**binding**, which entails specifying a name for it along with the expression it should stand for.
Evaluation of any variable entails evaluating the expression it is bound to.  One way to bind a
variable is called a **binding declaration**, which looks like this:

`num = 1 + 2`

A binding declaration is just one of many types of **declarations**, or statements that declare
something to be true. More will be introduced later. Every declaration has a limited context in which
it is considered true, called its **scope**. The scope of a binding declaration can also be referred to
as the variable's scope. If a declaration is true (or a variable is bound) in a given context, then
the declaration or variable are said to be "in scope".

GHCi allows you to enter binding declarations, and they remain in scope for the rest of the GHCi
session unless you enter another that re-binds the same variable name. Go ahead and try entering
the above example. Notice that GHCi doesn't reply back to you. This is because declarations are not
expressions and cannot be evaluated. Once you've entered that binding, enter the expression `num`
and note the result.

**Note:** Variable names must start with a *lowercase* letter or an underscore (`_`), while the
remaining characters may be letters (including uppercase), digits, apostrophes (`'`), and underscores.
Within those constraints, you can name them whatever you want.

Let Expressions
---------------

A **let expression** is an expression that allows you to make a declaration with a scope limited to
the expression itself. Only some types of declarations are allowed in one, but they include binding
declarations. Here is an example:

`let x = 1 + 2 in x * x`

Evaluating a let expression entails temporarily bringing the declaration into scope, and then
evaluating the expression after the `in`. Try it out by entering it into GHCi. Also note that
afterwards, if you simply enter `x`, it will give you an error, because `x`'s limited scope.
(If you previously entered a binding for `x` outside of a let expression, you will get the result
of that instead of an error.)

Here are a few more examples to try:

1. `let h = "Hello" in (h, h)`
2. `let n = 5 in n == 5`
3. `let notUsed = 500 in "Hello"`
4. `let foo = 1 in let bar = 2 in foo + bar`

That last example works because, *any* valid expression can be placed after the `in`, including other
let expressions. However, this isn't typically done because you can put multiple declarations in
one let expression, so it can be rewritten like this:

`let { foo = 1; bar = 1 } in foo + bar`

Note that these declarations are in scope for the *whole* let expression, including the part before
them. This means that the bound expressions may refer back to the variables themselves, like this:

`let { a = b; b = 3 + 1; c = a } in a + c`

**Note:** Bindings are the main type of declaration used in let expressions. The other kinds of
declarations that let expressions support must accompany a binding. Thus, let expressions are also
referred to as "let bindings".

Functions
---------

A **function** is a value that describes how to build an expression from another expression, if one
were to be supplied.  When a function is supplied with an expression to use, it is said that the
function is **applied** to an **argument**. Here is an example of a function written using a notation
called a **lambda abstraction**, or simply a **lambda**:

`\x -> x + x`

**Note:** Functions cannot be displayed by GHCi, so if you enter the above into it, you will get an error.

The `\x` introduces the variable `x`, which will be bound to the argument when the function is applied.
Such variables are called **parameters**. The scope of a parameter is the entire expression after
the `->`, and this scope is *per* function application.

To apply a function, you simply put the argument after the function separated by whitespace. However,
lambda syntax is greedy and assumes that all the symbols after the `->` are part of it, so `\x -> x + x 5`
will not work. To resolve this you can wrap the lambda in parentheses:

`(\x -> x + x) 5`

This function application is an expression that temporarily brings `x = 5` into scope and then evaluates
`x + x`. In other words, it is equivalent to the following:

`let x = 5 in x + x`

Another way to apply a function is to bind a variable to it and apply that, so this can be rewritten as:

`let f = \x -> x + x in f 5`

When binding a variable to a function, there is a simpler alternative syntax (also known as "syntax sugar")
that allows you to rewrite the above expression as:

`let f x = x + x in f 5`

Go ahead and try entering those examples into GHCi along with these:

1. `(\x -> "Hello, " ++ x) "World!"`
2. `(\notUsed -> [1,2,3]) 100`
3. `let g x = x * 2 in (g 10, g 20)`
4. `let h a = a + 1 in h 2 * 10`
5. `let h a = a + 1 in h (2 * 10)`
6. `(\x -> \y -> x * y + 1) 5 2`

Notice in that last example that we have a function that builds an expression that is, itself, another
function. Thus, the application to `5` results in another function that is in-turn applied to `2`.
First, `x = 5` is temporarily brought into scope, and then `(\y -> x * y + 1) 2` is evaluated:

`let x = 5 in (\y -> x * y + 1) 2`

Next, `y = 2` is temporarily brought into scope, and `x * y + 1` is evaluated:

`let x = 5 in let y = 2 in x * y + 1`

The function binding syntax sugar mentioned earlier also allows the above expression to be rewritten as:

`let f x y = x * y + 1 in f 5 2`

There is also syntax sugar for the lambda whose result is another lambda:

`(\x y -> x * y + 1) 5 2`

**Note:** Because both the outer function's parameter, `x`, and the inner function's parameter, `y`, are
in scope during the evaluation of the result expression, `x * y + 1`, nesting functions like this is the
typical approach to taking multiple arguments in Haskell.

And finally, one last example for you to try out:

`(\f -> f 1 + f 2) (\x -> x * 10)`

In this case, the argument of the first function is another function. First, `f = \x -> x * 10` is
brought into scope, and then `f 1 + f 2` is evaluated:

`let f x = x * 10 in f 1 + f 2`

Then `f` is applied twice, so we have two scopes where `x` is bound, and `x * 10` is evaluated for each:

`let f x = x * 10 in (let x = 1 in x * 10) + (let x = 2 in x * 10)`

At this point, `f` is no longer used on the right side of the `in`, so this is equivalent to:

`(let x = 1 in x * 10) + (let x = 2 in x * 10)`

**Note:** A function whose argument and/or result are another function is called a **higher-order function**.

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
