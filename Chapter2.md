[Back](Chapter1.md) / [Top](README.md) / [Next](Chapter3.md)

Chapter 2 - Procedural Programming
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

### Tuple Patterns

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

The Prelude actually provides a couple functions to do this conversion for you for 2-parameter functions,
called `curry` and `uncurry`. Here are some examples of them being used:

1. `let { f (x, y) = x + y; g = curry f } in g 1 2`
2. `let { f x y = x + y; g = uncurry f } in g (1, 2)`

Notice that both `curry` and `uncurry` take a function as an argument and build a function as a result.

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
bound to a multi-argument function, they can be used in **infix notation** (i.e. between the first two
arguments) after stripping the parentheses like this:

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

Also, in the earlier example, we defined `(-#-)` as `x -#- y = x * y`, but since `(*)` is, itself a curried
two-parameter function, we could have defined it like:

`let (-#-) = (*) in 2 -#- 3`

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

Whenever using infix notation it is possible to chain function applications like: `a -#- b -#- c` or
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
- An operator is **non-associative** if it can't be chained at all. The compiler will give you an error
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

### "Then" Operator

If we want to make a more complex program than one that simply displays "Hello World!", we need to build our
own procedures. This is done through the composition (or combination) of simpler procedures, and the Prelude
provides some functions for doing just this. The simplest is called `(>>)`, which you can pronounce as "then".
The `(>>)` operator takes two procedures as arguments and builds a new one that, *if* executed, will run the
first followed by the second. In `ch2/`, write a new file called "Main.hs" (or whatever) containing:

```hs
main = putStrLn "Line 1" >> putStrLn "Line 2"
```

Compile it with `ghc Main`, and then run the resulting program. You should see the following output:

```console
Line 1
Line 2
```

However, remember that `(>>)` doesn't execute its arguments. It only builds a new procedure that will execute
them if it is, itself, executed. So for instance, if you write and compile this, you will not see the two
lines displayed, only "Hello World!":

```hs
main = putStrLn "Hello World!"
printLines = putStrLn "Line 1" >> putStrLn "Line 2"
```

But if you do this, you will see "Hello World!" *and* the two lines:

```hs
main = putStrLn "Hello World!" >> printLines
printLines = putStrLn "Line 1" >> putStrLn "Line 2"
```

This operator is associative: `pa >> (pb >> pc)` is a procedure that runs `pa` and then runs procedure `pb >> pc`
(which runs `pb` and then `pc`), so ultimately `pa` then `pb` then `pc`. And `(pa >> pb) >> pc` is a procedure
that first runs procedure `pa >> pb` (which runs `pa` then `pb`) and then runs `pc`, which is again `pa` then
`pb` then `pc`. Thus, we can chain the operators like `pa >> pb >> pc`.

We can add a third line to our program this way:

```hs
main = putStrLn "Line 1" >> putStrLn "Line 2" >> putStrLn "Line 3"
```

The longer this gets, the harder it can be to read, so we can break this out across multiple lines like this:

```hs
main =
  putStrLn "Line 1" >>
  putStrLn "Line 2" >>
  putStrLn "Line 3" >>
  putStrLn "Line 4"
```

**Note:** Indentation matters in Haskell, so don't omit it. In this case, it indicates that the lines are still
part of the `main` binding and not starting their own top-level declaration.

### Execution Results

While not obvious with `putStrLn`, procedures always have execution results. In the case of `putStrLn`, because
its purpose is simply to output text, there is no *useful* result for it to return. When this is the case, a
procedure may choose to return the special Haskell value `()`, pronounced "unit", which is what `putStrLn` does.

An example of a procedure that *does* return something useful is `getLine`, provided by the Prelude. When run,
it will wait for the user to enter a line of text, and then its result will be a string containing that text.
If you run the following program, you'll be presented with a cursor awaiting input. Once you type something and
hit enter, it will display "Hello World!":

```hs
main = getLine >> putStrLn "Hello World!"
```

But as you can see, what you input was essentially ignored. This is because a procedure built by `(>>)` always
discards the execution result of the first argument. 

The result of the second argument becomes that of the overall procedure, so in the above program, because
`putStrLn "Hello World!"`'s result is `()`, `main`'s result is also `()`. Of course, you can reverse the order
of execution, so that it displays "Hello World!" *before* awaiting your input, and in this case, `main`'s result
is the string you input:

```hs
main = putStrLn "Hello World!" >> getLine
```

However, the program running `main` has no use for its result, so it is discarded as well.

### "Bind" Operator

To resolve this, the Prelude provides another procedure-composing function called `(>>=)`, pronounced "bind".
Like `(>>)`, its first argument is a procedure, but its second argument is a *function* that builds a procedure.
The procedure `pa >>= f` will execute as follows:

1. Execute `pa` and capture its result. Let's call it `a`.
2. Apply `f` to `a` to get a procedure. Let's call it `pb`. 
3. Execute `pb` and return its result as the result of the overall procedure.

Since `putStrLn` is a function that builds a procedure from a string, this is exactly the kind of thing `(>>=)`
expects as its second argument. Thus, we can write a program that waits for user's input and then immediately
displays it back to them like this:

```hs
main = getLine >>= putStrLn
```

We can also chain this with `(>>)` to display a prompt before waiting for input:

```hs
main = putStrLn "Please enter text:" >> getLine >>= putStrLn
```

We don't have a ready-made function like `putStrLn` that gives us the exact procedure we want. For instance,
say we want to display "You entered: " just before repeating the user's input. We can write our own function
that does this and use that instead:

```hs
main = putStrLn "Please enter text:" >> getLine >>= youEntered
youEntered line = putStrLn ("You entered: " ++ line)
```

Or just use lambda notation directly in our procedure expression:

```hs
main = putStrLn "Please enter text:" >> getLine >>= \line -> putStrLn ("You entered: " ++ line)
```

### Multiple Binds

Now what if we want two `(>>=)`s in our procedure? For instance, we'll echo user's input twice, each with a
different prompt and prefix. Here we'll split over multiple lines for readability:

```hs
main =
  putStrLn "Please enter your first input:" >>
  getLine >>= putPrefixedStrLn "Your first input: " >>
  putStrLn "Please enter your second input:" >>
  getLine >>= putPrefixedStrLn "Your second input: " >>
  putStrLn "Done!"

putPrefixedStrLn prefix line = putStrLn (prefix ++ line)
```

Notice that our `putPrefixedStrLn` function is curried, and we're partially applying it twice within `main`.
Specifically, we provide the first argument (the prefix) immediately, while the second argument (the line) is
provided by `(>>=)` after it executes `getLine`.

We can also do this inline with lambdas, but we'll need to wrap them in parentheses since we want more steps
to follow them:

```hs
main =
  putStrLn "Please enter your first input:" >>
  getLine >>= (\line1 -> putStrLn ("Your first input: " ++ line1)) >>
  putStrLn "Please enter your second input:" >>
  getLine >>= (\line2 -> putStrLn ("Your second input: " ++ line2)) >>
  putStrLn "Done!"
```

### Nested Binds

But what if we want to request both inputs before repeating them back to the user? The `line` parameter's
scope ends with the lambda, so by the time the second input has been requested, the first input has been
forgotten. This is because, so far, the second argument to `(>>=)` has always been the *next step* of the
procedure. The solution to this dilemma is to make the second argument to `(>>=)` actually be the *rest* of
the procedure. For instance, the above program can be reorganized like this:

```hs
main =
  putStrLn "Please enter your first input:" >>
  getLine >>= (
    \line1 ->
      putStrLn ("Your first input: " ++ line1) >>
      putStrLn "Please enter your second input:" >>
      getLine >>= (
        \line2 ->
          putStrLn ("Your second input: " ++ line2) >>
          putStrLn "Done!"
      )
  )
```

Notice that the first lambda doesn't end immediately after displaying the first line of input, but rather
contains all the remaining steps of the program. Also, because the second lambda is nested within the first
one, the `line1` parameter is still in scope within the second lambda.

This nesting allows us to alter the program to collect the inputs before echoing either of them back to the
user, by simply moving and indenting one line:

```hs
main =
  putStrLn "Please enter your first input:" >>
  getLine >>= (
    \line1 ->
      putStrLn "Please enter your second input:" >>
      getLine >>= (
        \line2 ->
          putStrLn ("Your first input: " ++ line1) >>
          putStrLn ("Your second input: " ++ line2) >>
          putStrLn "Done!"
      )
  )
```

The parentheses around the lambdas here are actually optional. This is because of how Haskell tends to include
everything after the `->` within the lambda. A lot of the indentation is also unnecessary. This procedure can
be rewritten as follows:

```hs
main =
  putStrLn "Please enter your first input:" >>
  getLine >>= \line1 ->
  putStrLn "Please enter your second input:" >>
  getLine >>= \line2 ->
  putStrLn ("Your first input: " ++ line1) >>
  putStrLn ("Your second input: " ++ line2) >>
  putStrLn "Done!"
```

The lack of nested indentation might fool you initially, but just remember that all the lines after `\line1 ->`
are part of the first lambda, and all the lines after the `\line2 ->` are part of the second lambda. In other
words, the second argument to each `(>>=)` is the entire rest of the procedure. This is the typical way in
which `(>>=)` and `(>>)` are used.

### "Then" And "Bind"

By the way, `(>>)` is actually defined in terms of `(>>=)` as simply `a >> b = a >>= \_ -> b`. Here we've
introduced a new type of pattern called the **wildcard pattern**, written as an underscore. Like variables, it
applies no constraints on the structure of what it is bound to. So this could actually be written as
`a >> b = a >>= \x -> b`. However, `_` is used to explicitly *avoid* naming the bound expression, which
makes it clear that you have no intention of using it. This clearly shows that `(>>)` discards the execution
result of its first argument.

The above program could have actually been written as:

```hs
main =
  putStrLn "Please enter your first input:" >>= \_ ->
  getLine >>= \line1 ->
  putStrLn "Please enter your second input:" >>= \_ ->
  getLine >>= \line2 ->
  putStrLn ("Your first input: " ++ line1) >>= \_ ->
  putStrLn ("Your second input: " ++ line2) >>= \_ ->
  putStrLn "Done!"
```

But of course `(>>)` makes it a bit cleaner.

### Do Notation

Haskell provides syntax sugar for writing expressions consisting of `(>>)` and `(>>=)` called **do notation**.
This starts with the keyword `do` followed by a series of so-called **statements**. The entire expression
written in do notation is called a **do block**. Here is the above program rewritten using do notation:

```hs
main = do
  putStrLn "Please enter your first input:"
  line1 <- getLine
  putStrLn "Please enter your second input:"
  line2 <- getLine
  putStrLn ("Your first input: " ++ line1)
  putStrLn ("Your second input: " ++ line2)
  putStrLn "Done!"
```

Each line after the `do` is a statement, and there are two kinds demonstrated here. The simplest is just a
procedure, such as the `putStrLn` lines. The other is a pattern followed by `<-` and then a procedure.

Let's break down how this corresponds to the procedure composition operators. The do notation equivalent of
`pa >> pb` is simply:

```hs
do
  pa
  pb
```

The do notation equivalent of `pa >>= \a -> pb` is:

```hs
do
  a <- pa
  pb
```

**Note:** These can also be written as `do { pa; pb }` and `do { a <- pa; pb }` if you don't want to split
them across multiple lines.

So basically, whenever you have a `<-` statement, this corresponds to the introduction of a lambda, where
the pattern to the left of it is the lambda's parameter, and all remaining statements within the do block
are contained within that lambda. Given this correspondence, a do block cannot end with a `<-` statement,
and the procedure that it does end with decides the execution result of the whole do block.

Also, just as `(>>)` is just a cleaner way to use `(>>=)` when the result is ignored, the same applies to
simple procedure statements and `<-` statements (aside from the last one). The above program could be
written as follows (not that you should):

```hs
main = do
  _ <- putStrLn "Please enter your first input:"
  line1 <- getLine
  _ <- putStrLn "Please enter your second input:"
  line2 <- getLine
  _ <- putStrLn ("Your first input: " ++ line1)
  _ <- putStrLn ("Your second input: " ++ line2)
  putStrLn "Done!"
```

Return
------

In the above examples, we've only written a `main` procedure. However, for non-trivial programs, we don't
tend to put everything directly into `main` because it can become hard to navigate the code. Instead, the
code tends to be split across many procedures, while `main` is what ties them together.

We didn't pay much attention to the actual result of `main` in those examples, because of the fact that it
is discarded by the program. However, when writing other procedures, the result matters a lot, because it
can be used by the calling procedure (the procedure running them).

Let's write a procedure that simply prompts the user for some input and returns the user's input as its
result:

```hs
promptInput = do
  putStrLn "Please enter input:"
  getLine
```

Remember that the final statement in the do block determines the result of the whole do block, so the line
entered by the user becomes the result of `promptInput`.

But what if we want something to prompt for two inputs and return both? We can start by writing:

```hs
promptTwoInputs = do
  putStrLn "Please enter your first input:"
  line1 <- getLine
  putStrLn "Please enter your second input:"
  line2 <- getLine
  ...
```

But then how do we make the result of `promptTwoInputs` be `(line1, line2)`? If we simply end with the
second `getLine` (and don't bind to `line2`), then `line1` will be lost and the result will only be the
second line. The Prelude provides a function called `return` that builds a procedure that does nothing but
return its argument as a result. With it, we can complete the above procedure to be:

```hs
promptTwoInputs = do
  putStrLn "Please enter your first input:"
  line1 <- getLine
  putStrLn "Please enter your second input:"
  line2 <- getLine
  return (line1, line2)
```

Now we can rewrite our original program as follows:

```hs
main = do
  (a, b) <- promptTwoInputs
  putStrLn ("Your first input: " ++ a)
  putStrLn ("Your second input: " ++ b)
  putStrLn "Done!"

promptTwoInputs = do
  putStrLn "Please enter your first input:"
  line1 <- getLine
  putStrLn "Please enter your second input:"
  line2 <- getLine
  return (line1, line2)
```

Notice that we can use a tuple pattern on the left side of the `<-` because that matches the structure
of the result of `promptTwoInputs`.

[Back](Chapter1.md) / [Top](README.md) / [Next](Chapter3.md)
