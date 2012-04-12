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

The drawback is here that an instance has to be created for every currency that should be used. That makes it impossible to use user-defined arbitrary currencies, but I don't know that it's possible to have type-safe currencies at compile-time on the one hand and arbitrary run-time defined currencies on the other hand.

PhantomTypes
------------

A better solution might be phantom types:

 - http://www.haskell.org/haskellwiki/Phantom_type

And finally, this works!

    -- currencies
    data Euro
    data US_Dollar
    data Yen
    data Bitcoin

    -- phantom type
    newtype Money c = Money { amount :: Double } deriving (Show)

    -- this should be exported, not the type itself
    makeEuro :: Double -> Money Euro
    makeEuro a = (Money a)

    makeYen :: Double -> Money Yen
    makeYen a = (Money a)

    (+) :: Money a -> Money a -> Money a
    (+) x y = (Money (amount x Prelude.+ amount y))

See:

    [1 of 1] Compiling PriceList        ( PriceList.hs, interpreted )
    Ok, modules loaded: PriceList.

    *PriceList> let a = makeEuro 24.0
    *PriceList> a
    Money {amount = 24.0}

    *PriceList> let b = makeYen 10.0
    *PriceList> b
    Money {amount = 10.0}

    *PriceList> (PriceList.+) a b

    <interactive>:1:17:
    Couldn't match expected type `Euro' with actual type `Yen'
    Expected type: Money Euro
      Actual type: Money Yen
    In the second argument of `(PriceList.+)', namely `b'
    In the expression: (PriceList.+) a b

Problem is that after compilation the currency is not visible anymore. So we could additionally add the currency to the record and ensure in the constructor, that it is always set correctly

    -- phantom type
    data Money currency = Money {
      amount :: Double,
      currency :: String
    } deriving (Show)

    -- this should be exported, not the type itself
    makeEuro :: Double -> Money Euro
    makeEuro a = (Money a "Euro")

    makeYen :: Double -> Money Yen
    makeYen a = (Money a "Yen")

    (+) :: Money a -> Money a -> Money a
    (+) x y = (Money (amount x Prelude.+ amount y) (currency x))


Products
--------

Next part is to develop a representation for products as shown on the bill which should be the goal of the kata..
