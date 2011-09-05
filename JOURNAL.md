Coding journal for this kata
============================

Non-exaustive function definition for addMoney
----------------------------------------------

The first version of `addMoney` used a guard to ensure that only money in the same currency was added:

    addMoney :: Money -> Money -> Money
    addMoney (Money a currency_a) (Money b currency_b)
      | currency_a == currency_b  = Money (a+b) currency_a

This led to a runtime error because of the non-exaustive definition (the function is not definied for the case `currency_a` and `currency_b` differs)

The first solution was to use the `Maybe` type:

    addMoney :: Money -> Money -> Maybe Money
    addMoney (Money a currency_a) (Money b currency_b)
      | currency_a == currency_b  = Just (Money (a+b) currency_a)
      | otherwise = Nothing

Now, the function is completely defined, but one have to check for `Nothing` everytime addMoney is used. The initial goal was to let the compiler check, if money with different currency was added.

To make it a bit clearer, I implemented a `sameCurrency` function and used this:

    sameCurrency :: Money -> Money -> Bool
    sameCurrency (Money _ currency_a) (Money _ currency_b) = currency_a == currency_b

    addMoney :: Money -> Money -> Maybe Money
    addMoney money_a@(Money a currency_a) money_b@(Money b currency_b)
      | sameCurrency money_a money_b  = Just (Money (a+b) currency_a)
      | otherwise = Nothing

I don't think that this adds much to the readability of the `addMoney` function, but the `sameCurrency` function can now be used somewhere else to check for same currency.


ViewPatterns
------------

I found a feature called ViewPatterns: http://hackage.haskell.org/trac/ghc/wiki/ViewPatterns (also saved as ViewPatterns.txt in the repository)

After thinking a bit I believe now that ensuring equality of currency at compile time is not possible. ViewPatterns don't help because they enable applying an expression to a argument and matching a pattern against the result (instead of matching the pattern against the argument), but that would still mean that the function is not completely defined.


Generalized Algebraic Datatypes (GADTs)
---------------------------------------

I found another feature which might be helpful in the `addMoney` problem:

 - http://en.wikibooks.org/wiki/Haskell/GADT
 - http://www.haskell.org/haskellwiki/Generalised_algebraic_datatype

TypeClasses for Money
---------------------

Maybe typeclasses are good for specifying different types of money?

 - http://www.haskell.org/tutorial/classes.html

I created a typeclass money, but ensuring that only same currencies are added will only work when every currency is a separate type, so instead of using a record which holds amount and currency, I will create a type for each currency using newtype. This type only holds the amount, so it's just a double.

 - http://www.haskell.org/tutorial/moretypes.html


