Operators
---------

### Introduction

Another type of expression that is used in the same manner as variables is called an **operator**. Like
variables, operators are bound to expressions. The main differences between the two are syntax-related.
First, operators are named as a series of non-alphanumeric symbols wrapped in parentheses. For instance,
we can name an operator `(.+/<)`, such as in this expression:

`let (.+/<) = 2 in (.+/<) + (.+/<)`

While *allowed*, this is not how operators are generally used. They exist for a special purpose: If they are
bound to a function with two arguments, they can be used in infix notation after stripping the parentheses.
For instance:

`let (-#-) x y = x * y in 2 -#- 3`

We can also write the binding itself in infix notation:

`let x -#- y = x * y in 2 -#- 3`

Just remember that this binding is equivalent to `(-#-) = \x y -> x * y`.

The characters that may be used in operator names include these ASCII symbols: `!#$%&*+./<=>?@\^|-~:`.
We can also use certain Unicode symbols.

**Note:** The following cannot be used as operator names due to Haskell reserving them for special purposes:
`(..)`, `(:)`, `(::)`, `(=)`, `(\)`, `(|)`, `(<-)`, `(->)`, `(@)`, `(~)`, and `(=>)`.

### Infix Variables

Variables bound to functions that take 2 arguments can also be used in infix notation by wrapping them in
backticks (`` ` ``) like this:

``let foo x y = x * y in 2 `foo` 3``

And even write the binding itself in infix notation:

``let x `foo` y = x * y in foo 2 3``

### Standard Operators

The Prelude exports many standard operators, some of which we've used in prior examples, including the
arithmetic operators as well as `(++)`, which was used to contatenate strings. Whenever we wrote `a + b`, we
could have alternatively written `(+) a b` to apply the operator like a function variable. We can also bind
a variable to the operator like this:

`let add = (+) in add 1 2`

We can also partially apply the operator like any other function:

`let add3 = (+) 3 in add3 1 + add3 2`

To show that these arithmetic operators are not special syntax, but are just operators bound to expressions,
you can rebind them in GHCi (not that this is generally recommended):

`let a + b = 500 in 1 + 1`

### Negation

The standard `(-)` operator is used for subtraction, so `5 - 3` and `(-) 5 3` evaluate to `2`. However,
the `-` symbol can also be placed in front of a numeric expression to negate it. For instance, `-(5 - 3)`
evaluates to `-2`. Although this looks like an operator, it's really just part of the Haskell syntax, and
isn't a true operator as for as the language is concerned. For instance, it isn't something you can rebind.
It is a unary (single-argument) pseudo-operator, and the only one of its kind in Haskell.

### Associativity

Whenever using infix form it is possible to chain them like: `a -#- b -#- c` or ``a `foo` b `foo` c``. However,
this introduces ambiguity: Should these be evaluated as `(a -#- b) -#- c` and ``(a `foo` b) `foo` c``, or as
`a -#- (b -#- c)` and ``a `foo` (b `foo` c)``? This is a question of the operator's **associativity**. There are
four types of associativity:

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
- An operator is **non-associative** if it doesn't make sense to chain it. Haskell will give you an error
  message if you attempt to chain a non-associative operator.

Haskell allows you to use a so-called **fixity declaration** to declare the associativity of a bound
variable. A fixity declaration must accompany the binding it describes. Here are some examples:

1. `let { a -#- b = a / b; infixr -#- } in 50 -#- 10 -#- 2`
2. ``let { foo a b = a - b; infixl `foo` } in 5 `foo` 6 `foo` 7``
3. `let { a ## b = a == b; infix ## } in (5 ## 6) ## True`

The `infixr` and `infixl` declarations indicate right- and left-associativity, respectively, while the
`infix` declaration indicates non-associativity. Also note that the operator or variable's infix form
is used in the fixity declaration, so backticks are needed for variables and no parentheses for operators.

### Precedence

It is also possible to chain a mix of operators, like `a -#- b .+. c`. This also introduces ambiguity
with regards to order of evaluation, and associativity doesn't resolve it. Instead this is resolved through
the relative **precedence** of the two operators. Whichever has highest precedence is evaluated first.

Precedence in Haskell is represented as an integer in the range 0 through 9. The precedence of an operator
can be specified as part of its fixity declaration, like this:

`let { a -#- b = a / b; infixl 2 -#-; a .+. b = a * b; infixr 3 .+. } in 5 -#- 6 .+. 7`

Due to `(.+.)` having higher precedence than `(-#-)`, that expression is evaluated as `5 -#- (6 .+. 7)`.

Whenever two operators have the same precedence *and* the same associativity, they will be evaluated in
the order of the associativity. If they have the same precedence but *not* the same associativity, they
aren't allowed to be chained, and parentheses are required.

