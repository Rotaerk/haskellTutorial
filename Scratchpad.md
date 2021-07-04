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

