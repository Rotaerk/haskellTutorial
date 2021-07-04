[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)

Chapter 1 - Hello World
=======================

In your command-line shell, navigate to the `ch1/` directory.

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
  with Unicode numeric representation 65; equivalent to `'A'`)
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

Variable names must start with a *lowercase* letter or an underscore (`_`), while the remaining
characters may be letters (including uppercase), digits, apostrophes (`'`), and underscores. Within
those constraints, you can name them whatever you want.

**Note:** The following cannot be used as variable names due to Haskell reserving them for special
purposes: `case`, `class`, `data`, `default`, `deriving`, `do`, `else`, `foreign`, `if`, `import`,
`in`, `infix`, `infixl`, `infixr`, `instance`, `let`, `module`, `newtype`, `of`, `then`, `type`,
`where`, `_`.

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

### Introduction

A **function** is a value that describes how to build an expression from another expression, if one
were to be supplied.  When a function is supplied with an expression to use, it is said that the
function is **applied** to an **argument**. Here is an example of a function written using a notation
called a **lambda abstraction**, or simply a **lambda**:

`\x -> x + x`

**Note:** Functions cannot be displayed by GHCi, so if you enter the above into it, you will get an error.

The `\x` introduces the variable `x`, which will be bound to the argument when the function is applied.
Such variables are called **parameters**. The scope of a parameter is the entire expression after
the `->`, and this scope is *per* function application.

### Application

To apply a function, you simply put the argument after the function, separated by whitespace. However,
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

### Multiple Arguments

Because functions themselves are values, they can be the results of other functions, like this:

`\x -> \y -> x * y + 1`

Notice that not just `y` but also `x` is in scope for the inner function's result expression.
This means that we *effectively* have a two-parameter function. This is the typical approach in
Haskell for writing functions with multiple parameters.

There is syntax sugar for such a lambda that looks like this:

`\x y -> x * y + 1`

Also, the syntax sugar mentioned earlier for binding variables to functions can be extended for this:

`f x y = x * y + 1`

To apply this function to two arguments, you would write this:

`(\x y -> x * y + 1) 5 2`

The way this evaluates is that first, `x = 5` is temporarily brought into scope, and `(\y -> x * y + 1) 2`
is evaluated:

`let x = 5 in (\y -> x * y + 1) 2`

Next, `y = 2` is temporarily brought into scope, and `x * y + 1` is evaluated:

`let x = 5 in let y = 2 in x * y + 1`

It's worth noting that we can apply the function to just one argument, bind a variable to the resulting
function, and then supply the second argument later on, or even reuse the function multiple times on
different arguments. This pattern is known as **partial application**:

`let { f x y = x * y + 1; g = f 5 } in (g 2, g 3)`

### Functions as Arguments

Again because functions themselves are values, they can be arguments to other functions, like this:

`(\f -> f 1 + f 2) (\x -> x * 10)`

The way this evaluates is that first, `f = \x -> x * 10` is brought into scope, and `f 1 + f 2` is evaluated:

`let f x = x * 10 in f 1 + f 2`

Then `f` is applied twice, so we have two scopes where `x` is bound, and `x * 10` is evaluated for each:

`let f x = x * 10 in (let x = 1 in x * 10) + (let x = 2 in x * 10)`

At this point, `f` is no longer used on the right side of the `in`, so this is equivalent to:

`(let x = 1 in x * 10) + (let x = 2 in x * 10)`

**Note:** A function whose argument and/or result are another function is called a **higher-order function**.

Modules
-------

### Introduction

Entering declarations and expressions into GHCi is useful for trying things out, but Haskell programming is
done by writing source code into files that contain named organizational units called **modules**.  The
content of a module is a set of declarations, whose scope is the entire module. These are called **top-level
declarations**.

A module's name is a series of sub-names separated by dots (`.`). Each sub-name must begin with an uppercase
letter, but the remaining characters can be letters (including lowercase), digits, and apostrophes (`'`).
In GHC's implementation of Haskell, each source file must have exactly one module in it. Furthermore, it
expects the file's name and path relative to the source code directory to correspond to the module name.
Specifically, if you have a module named `Foo.Bar.Baz`, it is expected to be in the file `Foo/Bar/Baz.hs`.

Let's define a module called `Foo` that contains a few top-level binding declarations. We'll use `ch1/` as
our source code directory. Go ahead and create a new file in it called `Foo.hs`, and write this to it:

```hs
module Foo where

add x y = x + y
addThree = add three
three = 1 + 2
```

The `module Foo where` line is the module's **header**, and everything after it is its **body**.

Now in GHCi, assuming you started it from `ch1/`, you can load this module by entering `:load Foo`.
Alternatively, you can start a new GHCi session that loads it immediately by running `ghci Foo` from the
command-line. If you've already loaded a module into GHCi and you would like to reload it (e.g. if you
changed something in the file), you can enter `:reload`.

As a result of loading the module, all of its declarations are brought into scope for the rest of the
GHCi session. Thus, if you enter `add 1 2`, `addThree 6`, and `three`, it should display their values.

### Importing

Modules can **export** top-level declarations for use by other modules. By default, all of them are
exported. We'll cover how to refine this later. In order for another module to use the declarations exported
by `Foo`, it must first **import** `Foo`. This is done using a special kind of declaration called an
**import declaration**, which states that the exported top-level declarations of the imported module are
in scope for the current module.

**Note:** Import declarations are not considered top-level declarations, and they must all come before the
top-level declarations in the module's body. The order of the import declarations themselves doesn't matter.

Let's try this out. Go ahead and create a couple more module files:

Bar.hs:
```hs
module Bar where

x = 1
y = 2
z = 3
```

Baz.hs:
```hs
module Baz where

import Foo
import Bar

addZ = add z
threePlusXTimesY = addThree (x * y)
```

Go ahead and load `Baz` into GHCi. Doing so will automatically load the other two modules because it
imports them.

### Prelude

There is a standard module called **Prelude** that is implicitly imported into all other modules, so
all of its exported declarations are immediately in scope for them. The set of declarations exported
by Prelude is extensive enough that we'll only cover some of them in this tutorial. Here is an example
of a module referring to a variable exported by Prelude called `pi`:

```hs
module UsesPrelude where

x = pi
```

You can also use `pi` from a fresh instance of GHCi without having loaded any modules.

Operators
---------

### Introduction

Let's go back to variables for a bit. There's actually another way they can be named: as a series of
non-alphanumeric symbols wrapped in parentheses. Variables named in this manner are called **operators**.
For instance, we can name an operator `(.+/<)`, such as in this expression:

`let (.+/<) = 2 in (.+/<) + (.+/<)`

While *allowed*, this is not how operators are generally used. They exist for a special purpose: If they
are bound to a function with 2 arguments, they can be used in infix notation after stripping the
parentheses. For instance:

`let (-#-) x y = x * y in 2 -#- 3`

We can also write the binding itself in infix notation:

`let x -#- y = x * y in 2 -#- 3`

The characters that may be used in operator names include these ASCII symbols: `!#$%&*+./<=>?@\^|-~:`.
We can also use certain Unicode symbols.

**Note:** The following cannot be used as operator names due to Haskell reserving them for special
purposes: `(..)`, `(:)`, `(::)`, `(=)`, `(\)`, `(|)`, `(<-)`, `(->)`, `(@)`, `(~)`, and `(=>)`.

### Standard Operators

The Prelude exports many standard operators, including the arithmetic operators we've been using
in prior examples. Whenever we wrote `a + b`, we could have alternatively written `(+) a b` to
use the operator like any other function. We can also bind it to a variable like this:

`let add = (+) in add 1 2`

### Infix Functions

Non-operator variables bound to functions that take 2 arguments can also be used in infix notation
by wrapping them in backticks (`` ` ``) like this:

``let foo x y = x * y in 2 `foo` 3``

And even write the binding itself in infix notation:

``let x `foo` y = x * y in foo 2 3``

Procedures
----------

[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)
