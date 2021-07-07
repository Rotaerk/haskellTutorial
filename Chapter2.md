[Back](Chapter1.md) / [Top](README.md) / [Next](Chapter3.md)

Chapter 2 - **WORK IN PROGRESS**
==================

Higher-Order Functions
----------------------

### Introduction

In Chapter 1, we covered functions and showed that they define an expression in terms of a parameter, or
a variable waiting to be bound to an argument (another expression) when the function is applied. Because
a function is, itself, an expression, it can be both an argument to another function, as well as the
expression built by another function. Any function that builds another function as its result or takes
another function as an argument is called a **higher-order function**.

### Multiple Arguments

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

### Partial Application

We already did it once in the very first example of a multi-parameter function, but we need to draw
attention to the fact that we can apply such a function to a portion of its arguments, bind a variable
to the resulting function, and then supply further arguments to that variable later on, or even reuse
it multiple times on different arguments. This pattern is known as **partial application**. For example:

`let { f x y = x * y + 1; g = f 5 } in g 2 + g 3`

### Functions as Arguments

As mentioned earlier, functions may also consume other functions as arguments. Here's what that looks like
and how it evaluates:

1. `(\f -> f 1 + f 2) (\x -> x * 10)` : start
2. `let f x = x * 10 in f 1 + f 2` : bind parameter to argument
3. `let f x = x * 10 in (\x -> x * 10) 1 + (\x -> x * 10) 2` : replace `f` with its value
4. `(\x -> x * 10) 1 + (\x -> x * 10) 2` : eliminate unused binding
5. `(1 * 10) + (2 * 10)` : function application (skipped some steps)
6. `30` : arithmetic

[Back](Chapter1.md) / [Top](README.md) / [Next](Chapter3.md)
