[Back](Chapter1.md) / [Top](README.md) / [Next](Chapter3.md)

Chapter 2 - Imperative Programming
==================================

In a command-line shell, create a new folder for the code you will write in this chapter, and
then navigate into it. Below, this folder will be referred to as `ch2/`.

Tuples
------

### Introduction

A **tuple** is a type of expression that contains two or more other expressions. Here are some examples:

1. `(1, 2)`
2. `("Hello", 3.5, 'x', \a -> a + 1)` : won't display in GHCi because it contains a function
3. `(2+2, "Hi " ++ "there!", let a = 3 in a * a)`

Evaluating a tuple entails evaluating the expressions it contains while keeping its structure intact.
The tuple is fully evaluated if all of its expressions are fully evaluated. So for instance, examples #1
and #2 are values, while #3 can still be evaluated.

### Pattern-matching

Binding declarations are actually more versatile than was demonstrated in Chapter 1. Rather than binding
variables to expressions, they actually bind **patterns** to expressions, and variables happen to be the
simplest pattern. A pattern describes a structure or shape expected from the bound expression while
allowing names to be given to pieces of that structure. A variable is simply a pattern that imposes no
structural constraints on the expression.

Here is an example of a **tuple pattern** bound to a tuple expression:

`let (a, b) = (1 + 1, 2 * 2) in a + b`

A tuple pattern looks very much like a tuple expression; after all, if `a` and `b` were in scope, `(a, b)`
would be a valid tuple expression. However, the placement within the binding syntax on the left side of
the `=` tells us that it is a pattern.

By placing variable names within the slots of the tuple pattern, we are saying that they should be bound
to the expressions in the corresponding slots of the bound expression. Particularly, `a` is bound to
`1 + 1` and `b` to `2 * 2`.

### Multi-Parameter Functions

Just as the left side of a binding declaration is a pattern, so is the parameter of a function.
Here are some examples of functions being applied to tuples:

1. `(\(x,y) -> x + y) (1,2)`
2. `let f (x, y) = x * y in f (3, 4)`

Thus, by packing multiple expressions into a tuple and applying a function to that, which uses pattern
matching to unpack the expressions, we effectively have a multi-parameter function.

Higher-Order Functions
----------------------

### Introduction

In Chapter 1, we covered functions and showed that they define an expression in terms of a parameter, or
a variable waiting to be bound to an argument (another expression) when the function is applied. Because
a function is, itself, an expression, it can be an argument to another function, as well as the expression
built by another function. Any function that takes another function as an argument or builds another function
as its result is called a **higher-order function**.

### Functions as Arguments

Here's what it looks like for a function to serve as an argument, and how it evaluates:

1. `(\f -> f 1 + f 2) (\x -> x * 10)` : start
2. `let f x = x * 10 in f 1 + f 2` : bind parameter to argument
3. `let f x = x * 10 in (\x -> x * 10) 1 + (\x -> x * 10) 2` : replace `f` with its value
4. `(\x -> x * 10) 1 + (\x -> x * 10) 2` : eliminate unused binding
5. `(1 * 10) + (2 * 10)` : function application x2
6. `30` : arithmetic

### Functions Building Functions

Here is an example of a function that builds another function:

`\x -> \y -> x * y + 1`

Notice that not just `y` but also `x` is in scope for the inner function's result expression. Let's see
how applying this to an argument evaluates:

1. `(\x -> \y -> x * y + 1) (1 + 2)` : start
2. `let x = 1 + 2 in \y -> x * y + 1` : bind parameter to argument
3. `let x = 3 in \y -> x * y + 1` : evaluate `x`
4. `let x = 3 in \y -> 3 * y + 1` : replace `x` with its value
5. `\y -> 3 * y + 1` : eliminate unused binding

Since we can apply expression #5 to an argument, and since expression #1 evaluates to expression #5, we
can also apply expression #1 to an argument. Let's see how that looks and evaluates:

1. `(\x -> \y -> x * y + 1) (1 + 2) (3 + 4)` : start
2. `(\y -> 3 * y + 1) (3 + 4)` : replaced first function application with its value per previous evaluation
3. `let y = 3 + 4 in 3 * y + 1` : bound parameter to argument
4. `let y = 7 in 3 * y + 1` : evaluated bound expression
5. `let y = 7 in 3 * 7 + 1` : replaced `y` with its value
6. `3 * 7 + 1` : eliminate unused binding
7. `22` : arithmetic

So when a function is nested within another like this, we effectively have a two-parameter function.
This extends to any number of nestings. For instance this is a 5-parameter function, or alternatively a
function that builds a function that builds a function that builds a function that builds a function
that builds an arithmetic expression:

`\a -> \b -> \c -> \d -> \e -> a + b + c + d + e`

There is syntax sugar for a multi-parameter lambda such as this:

`\a b c d e -> a + b + c + d + e`

Also, the syntax sugar mentioned earlier for binding variables to functions can be extended similarly:

`f a b c d e = a + b + c + d + e`

### Currying

This form of multi-parameter function is called a **curried** function, while one that simply takes a
tuple is called an "uncurried" function. Any curried function can be expressed as an uncurried function
and vice versa. For example, `\x y -> x + y` is the curried form of `\(x,y) -> x + y`. The process of
converting an uncurried function to its curried form is called "currying", while the reverse is called
"uncurrying".

The Prelude actually provides a couple functions to do this conversion for you, for 2-parameter functions,
called `curry` and `uncurry`. Here are some examples of them being used:

1. `let { f (x, y) = x + y; g = curry f } in g 1 2`
2. `let { f x y = x + y; g = uncurry f } in g (1, 2)`

### Partial Application

Curried functions are the most common in Haskell because they have a big advantage over uncurried functions:
We can apply a curried function to a portion of its arguments, bind a variable to the resulting function,
and then supply further arguments to that variable later on, or even reuse it multiple times on different
arguments. This usage is known as **partial application**. For example, here's how it looks and evaluates:

1. `let { f x y = x * y + 1; g = f 5 } in g 2 + g 3` : start
2. `let { f x y = x * y + 1; g = (\x y -> x * y + 1) 5 } in g 2 + g 3` : replace `f` with its value
3. `let g = (\x y -> x * y + 1) 5 in g 2 + g 3` : eliminate unused binding
4. `let g = \y -> 5 * y + 1 in g 2 + g 3` : function application (to evaluate `g`)
5. `let g = \y -> 5 * y + 1 in (\y -> 5 * y + 1) 2 + (\y -> 5 * y + 1) 3` : replace `g` with its value
6. `(\y -> 5 * y + 1) 2 + (\y -> 5 * y + 1) 3` : eliminate unused binding
7. `(5 * 2 + 1) + (5 * 3 + 1)` : function application x2 (skipped some steps)
8. `27` : arithmetic

Operators and Infix Notation
----------------------------

### Introduction

Another type of expression that is used in the same manner as variables is called an **operator**. Like
variables, operators are bound to expressions. The main differences between the two are syntax-related.
First, operators are named as a series of non-alphanumeric symbols wrapped in parentheses. For instance,
we can name an operator `(.+/<)`, such as in this expression:

`let (.+/<) = 2 in (.+/<) + (.+/<)`

While *allowed*, this is not how operators are generally used. They exist for a special purpose: If they are
bound to a multi-argument function, they can be used in infix notation after stripping the parentheses.
For instance:

`let (-#-) x y = x * y in 2 -#- 3`

We can also write the binding itself in infix notation:

`let x -#- y = x * y in 2 -#- 3`

Just remember that this binding is equivalent to `(-#-) = \x y -> x * y`.

The characters that may be used in operator names include these ASCII symbols: `!#$%&*+./<=>?@\^|-~:`.
We can also use certain Unicode symbols.

**Note:** The following cannot be used as operator names due to Haskell reserving them for special purposes:
`(..)`, `(:)`, `(::)`, `(=)`, `(\)`, `(|)`, `(<-)`, `(->)`, `(@)`, `(~)`, and `(=>)`.

### Standard Operators

The Prelude exports many standard operators, some of which we've used in prior examples, including the
arithmetic operators as well as `(++)`, which was used to contatenate strings. Whenever we wrote `a + b`, we
could have alternatively written `(+) a b` to apply the operator like any function-bound variable.

To show that these arithmetic operators are not special syntax, but are just operators bound to expressions
like any other, you can rebind (not that this is generally recommended):

`let a + b = 500 in 1 + 1`

### Negation

The standard `(-)` operator is used for subtraction, so `5 - 3` and `(-) 5 3` evaluate to `2`. However,
the `-` symbol can also be placed in front of a numeric expression to negate it. For instance, `-(5 - 3)`
evaluates to `-2`. Although this looks like an operator, it really *is* just special Haskell syntax, and
isn't a true operator as far as the language is concerned. For instance, it isn't something you can rebind.
It is a unary (single-argument) pseudo-operator, and the only one of its kind in Haskell.

### Infix Variables

Variables bound to multi-argument functions can also be used in infix notation by wrapping them in backticks
(`` ` ``) like this:

``let foo x y = x * y in 2 `foo` 3``

And even write the binding itself in infix notation:

``let x `foo` y = x * y in foo 2 3``

Fixity
------

### Associativity

Whenever using infix form it is possible to chain function applications like: `a -#- b -#- c` or
``a `foo` b `foo` c``. However, this introduces ambiguity: Should these be evaluated as `(a -#- b) -#- c` and
``(a `foo` b) `foo` c``, or as `a -#- (b -#- c)` and ``a `foo` (b `foo` c)``? This is a question of the
operator's **associativity**. There are four types of associativity:

- An operator is **left-associative** if it should be evaluated left-to-right. For instance, subtraction
  is typically left-associative. You would expect `5 - 2 - 1` to evaluate to `(5 - 2) - 1`, or `2`. It
  would be surprising to see it evaluate to `5 - (2 - 1)`, or `4`.
- An operator is **right-associative** if it should be evaluated right-to-left. For instance, exponentiation
  is typically right-associative. As in, `2 ^ 3 ^ 2` is generally expected to evaluate to `2 ^ (3 ^ 2)`,
  or `512`, not `(2 ^ 3) ^ 2`, or `64`.
- An operator is simply **associative** if it evaluates to the same value regardless of the order.
  For instance, addition is associative. As in, `2 + 3 + 4` can be evaluated as `(2 + 3) + 4` or as
  `2 + (3 + 4)` and you get `9` either way. However, Haskell requires a convention be chosen even for
  associative operators, so the standard `(+)` operator is (arbitrarily) defined as left-associative.
- An operator is **non-associative** if it can't be chained at all. Haskell will give you an error
  message if you attempt to chain a non-associative operator.

Haskell allows you to use a so-called **fixity declaration** to declare the associativity of a bound
variable. A fixity declaration must accompany the binding it describes. Here are some examples:

1. `let { a -#- b = a / b; infixr -#- } in 50 -#- 10 -#- 2`
2. ``let { foo a b = a - b; infixl `foo` } in 5 `foo` 6 `foo` 7``
3. `let { a ## b = a * b - a / b; infix ## } in (5 ## 6) ## 7`

The `infixr` and `infixl` declarations indicate right- and left-associativity, respectively, while the
`infix` declaration indicates non-associativity. Also note that the operator or variable's infix form
is used in the fixity declaration, so backticks are needed for variables and no parentheses for operators.

### Precedence

It is also possible to chain a mix of operators, like `a -#- b .+. c`. This also introduces ambiguity
with regards to order of evaluation, and associativity doesn't resolve it. Instead this is resolved through
the relative **precedence** of the two operators. In Haskell, the precedence of an operator is represented
as an integer in the range 0 through 9. When chaining two operators such as in that example, the operator
with the higher precedence is evaluated first.

The precedence of an operator can be specified as part of its fixity declaration like this:

`let { a -#- b = a / b; infixl 2 -#-; a .+. b = a * b; infixr 3 .+. } in 5 -#- 6 .+. 7`

Due to `(.+.)` having higher precedence than `(-#-)`, that expression is evaluated as `5 -#- (6 .+. 7)`.

Whenever two operators have the same precedence *and* the same associativity, they will be evaluated in
the order of the associativity. If they have the same precedence but *not* the same associativity, they
aren't allowed to be chained, and parentheses are required.

Procedure Composition
---------------------

### Output-Only

The Prelude provides some functions for composing procedures. The simplest is called `(>>)`, which you can
pronounce as "then". In `ch2/`, create a new file called "Main.hs" containing:

```hs
module Main where

main = putStrLn "Line 1" >> putStrLn "Line 2" >> putStrLn "Line 3"
```

Compile it with `ghc Main`, and then run the resulting program. You should see the following output:

```console
Line 1
Line 2
Line 3
```

The `(>>)` operator takes two procedures and builds a new one that, *if* executed, will execute its first
argument followed by its second argument. It's associative, because the same sequence of execution happens
in both `a >> (b >> c)` and `(a >> b) >> c`, so it can be unambiguously chained.

### Input

The only procedures we've seen so far output text, but what if we want to get input back from the user?
While not obvious with `putStrLn`, procedures always have execution results. In the case of `putStrLn`,
its execution result is always a special value called `()`, pronounced "unit". This is a useful value
for when a procedure must return *something* but has nothing useful to return.

An example of a procedure that does return something useful is `getLine`, provided by the Prelude. If this
procedure is executed, it will prompt the user to enter a line of text, and then its result will be that
text. But how do we get access to this?

Let's say we want to make a procedure that will ask the user for a line of text and then immediately display
it back to them (often called "echoing"). Remember that `putStrLn` is not, itself, a procedure, but a function
that builds a procedure given a string. Procedures don't take parameters. The string to be displayed is built
in to the procedure returned by a particular application of `putStrLn`. Thus, how an echo procedure must work
is:

1. Run `getLine`, and get its result. Let's call this `line`.
2. Apply `putStrLn` to `line` to build a new procedure that displays `line`
3. Run this new `line`-displaying procedure.

This is precisely what the Prelude-provided operator called `(>>=)` does. This can be pronounced "bind".
Its first argument is a procedure. Its second argument is a function that builds a procedure. The way it
works is that it will run the first procedure, apply the provided function to the execution result of that
first procedure, and then run the procedure built by that function. Go ahead and edit Main.hs to look like
the following, and then compile and run it:

```hs
module Main where

main = getLine >>= \line -> putStrLn line
```

[Back](Chapter1.md) / [Top](README.md) / [Next](Chapter3.md)
