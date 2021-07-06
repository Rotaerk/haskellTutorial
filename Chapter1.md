[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)

Chapter 1 - Hello World
=======================

In your command-line shell, navigate to the `ch1/` directory.

Expressions and Evaluation
------

### Arithmetic and Algebra Expressions

If you're familiar with arithmetic, you've seen arithmetic expressions before. For example:

1. `1`
2. `3.14 + 1.3`
3. `(15 / 2) + 3 × (1 - 3)`

You're also familiar with the iterative, or step-by-step, process of calculating the value of
such expressions. For example, to calculate the value of expression #3 above, you might do:

1. `(15 / 2) + 3 × (1 - 3)` : start
2. `7.5 + 3 × (1 - 3)` : division of 15 and 2
3. `7.5 + 3 × -2` : subtraction of 1 and 3
4. `7.5 + -6` : multiplication of 3 and -2
5. `1.5` : addition of 7.5 and -6

If you're familiar with algebra, you've seen algebraic expressions before. For example:

1. `x`
2. `a(a + 1) - a + 2`
3. `(2x + 3y) / x - 2z - y/x - 3`

You're also familiar with the iterative process of simplifying such expressions. For example,
to simplify expression #3 above, you might do:

1. `(2x + 3y) / x - 2z - y/x - 3` : start
2. `2x/x + 3y/x - 2z - y/x - 3` : distributive property
3. `2 + 3y/x - 2z - y/x - 3` : cancel out the `x`s
4. `3y/x - 2z - y/x - 1` : subtract 2 and 3
5. `2y/x - 2z - 1` : combine terms containing `y/x`

In both cases, we've got:

1. Grammatical rules that tell us whether something is a valid expression. For instance, `1 +`
   is not a valid arithmetic expression. `x + y` also isn't, but it *is* a valid algebraic
   expression. Any arithmetic expression is also a valid algebraic expression. But then
   `x x` and `x -× 2- y/` are *not* valid algebraic expressions.

2. A set of rules that tell us how to iteratively transform expressions. For instance, we have
   a rule for arithmetic calculation that tells us in any arithmetic expression, we can replace
   two numbers separated by an arithmetic operation with the result of that operation like how we
   replaced `15 / 2` with `7.5` in the above arithmetic calculation. And for algebraic expressions,
   we have rules like canceling and the distributive property that allow us to eliminate variables,
   making the expression simpler. The rules of arithmetic calculation also apply in algebraic
   simplification, so arithmetic can be seen as a special case of algebra.

### Haskell Expressions

A **Haskell expression** is a type of expression that obeys grammar rules defined by the Haskell
language. Arithmetic expressions are generally valid Haskell expressions, although they might be
written a bit differently. For instance, multiplication uses the `*` symbol instead of `×`, and
exponentiation uses `^` instead of writing a superscript. However, Haskell expressions are not
limited to just numbers. For instance, you can have expressions that operate on strings of
characters, like `"Hello"`. The rules for what make a valid Haskell expression will be introduced
over the course of this tutorial.

Haskell also defines rules for iteratively transforming these expressions, called **evaluation**.
Like arithmetic calculation and algebraic simplification, evaluation rules entail replacing parts
of the expression, called **sub-expressions**, with other expressions. Unlike with arithmetic
calculation, there exist Haskell expressions for which the evaluation process can go on forever
because there's always a sub-expression replacement that can be done according to the rules. For
others, evaluation eventually reaches a point where it can go no further, and the resulting
expression is said to be **fully evaluated**. This is analogous to how `1.5` is a "fully calculated"
arithmetic expression, and `2y/x - 2z - 1` is a "fully simplified" algebraic expression. A fully
evaluated Haskell expression is called a **value**.

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
3. `'a'`
4. `1 / 3`
5. `-9 * (1 + 8) `
6. `"Super" ++ "man"`

**Note:** For the rest of this tutorial, Haskell expressions will simply be called "expressions".

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
something to be true. More will be introduced later. It is important to note that although they
are part of Haskell, declarations are *not* expressions and are *not* evaluated.

Every declaration has a limited context in which it is considered true, called its **scope**. In
the case of a binding declaration, its scope can also be referred to as the variable's scope. If
a declaration is considered true (or a variable is bound) in a given context, then the declaration
or variable is said to be "in scope".

GHCi allows you to enter binding declarations, and they remain in scope for the rest of the GHCi
session unless you enter another that re-binds the same variable name. Go ahead and try entering
the above example. Notice that GHCi doesn't reply back to you. This is because, again, declarations
are not expressions and cannot be evaluated. Once you've entered that binding, enter the expression
`num` and note the result.

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
the expression itself, and then to evaluate another expression in that context. Only some types of
declarations are allowed in one, but they include binding declarations. Here is an example:

`let x = 1 + 2 in x * x`

Evaluating a let expression entails temporarily bringing the declaration into scope, and then
evaluating the expression after the `in`. Try it out by entering it into GHCi. Also note that
afterwards, if you simply enter `x`, it will give you an error, because of `x`'s limited scope.
(If you previously entered a binding for `x` outside of a let expression, you will get the result
of that instead of an error.)

Here are a few more examples to try:

1. `let s = "foo" in s ++ s`
2. `let notUsed = 500 in "Hello"`
3. `let foo = 1 in let bar = 2 in foo + bar`

That last example works because *any* valid expression can be placed after the `in`, including other
let expressions. However, this isn't typically done because you can put multiple declarations in
one let expression, so it can be rewritten like this:

`let { foo = 1; bar = 1 } in foo + bar`

Note that these declarations are in scope for the *whole* let expression, including the declarations
that come before them. This means that the bound expressions may refer back to the variables themselves:

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
2. `(\notUsed -> "Blah") 100`
3. `let g x = x * 2 in g 10 + g 20`
4. `let h a = a + 1 in h 2 * 10`
5. `let h a = a + 1 in h (2 * 10)`

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

With those in place, load `Baz` into GHCi. Doing so will automatically load the other two modules because
it imports them.

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

Procedures
----------

### Introduction

So far, the expressions we've talked about include: literals, variables, let-expressions, and functions.
Variables are expressions serving as names for other expressions. Let-expressions bring declarations into scope,
but otherwise just evaluate to other expressions. Functions define expressions relative to other expressions.
So the only expressions we've talked about so far that stand on their own are literals, which include numbers,
characters, and strings. But Haskell is a *programming language*, not a number, character, and string evaluation
language. If we're going to build programs, we need some more useful expressions to evaluate.

To specify the behavior of our program, we need to be able to describe a sequence of instructions for it to
execute. Haskell supports a type of expression for doing just that, which I call a **procedure**. This kind of
expression is officialy called both an "I/O operation" and an "action" by the Haskell Report. However, because
such an expression can describe anything from the simplest CPU instruction to the most complicated of programs,
I find both of these terms to undersell the complexity they might encapsulate.

There is no special syntax for creating a procedure. Rather, GHC gives us simple procedures bound to variables,
which serve as the bedrock for programming in Haskell. New procedures are created by chaining together simpler
ones. We will cover how to chain together procedures later.

### Hello World

A Haskell program is written by creating a module called `Main` (and in this one case, the file name does *not*
have to match the module name) and binding a top-level variable called `main` to a procedure. When GHC compiles
the module, it specifically looks for this variable in this module, and it will build a program that, when run,
executes the procedure it is bound to. Other procedures referenced, directly or indirectly, by the `main`
procedure may run as a part of it, but `main` serves as the so-called **entry-point**.

Let's create our first program, which will print the text "Hello World!" to the command-line interface. We do
not need to piece together our own procedure for this, because the Prelude has us covered. It provides us a
function called `putStrLn` that expects a string argument and gives back a procedure that contains the
instructions for printing that string.

Create a new file in `ch1/` called `HelloWorld.hs`, and write this to it:

```hs
module Main where

main = putStrLn "Hello World!"
```

Then from the command-line, run `ghc HelloWorld` to compile the module. You should get an output like this:

```console
[1 of 1] Compiling Main             ( HelloWorld.hs, HelloWorld.o )
Linking HelloWorld ...
```

It will have created an executable program alongside your module file. If you run that from the command-line,
you should see the text "Hello World!" displayed.

You can also load this module into GHCi, and then enter the command `:main` to run the procedure without
first compiling.

[Back](README.md) / [Top](README.md) / [Next](Chapter2.md)
