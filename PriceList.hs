module PriceList (
  Currency(..), Money(..), Product(..),
  addMoney
) where

  data Currency = Euro
                | US_Dollar
                | Yen
                | Bitcoin
                deriving (Show,Eq)

  -- money is an amount and a currency
  -- TODO: is Double the right datatype for arbitrary precision decimals?
  data Money = Money {
        amount   :: Double
      , currency :: Currency
      } deriving (Show,Eq)

  -- a product should not have a price or an amount
  data Product = Product {
        name :: String
      } deriving (Show)

  -- price definition is a product, a money instance and an matcher or something for the amount
  -- amount is a number and a unit

  -- TODO: Non-exhaustive patterns to ensure equality of currencies?
  addMoney :: Money -> Money -> Money
  addMoney (Money a currency_a) (Money b currency_b)
    | currency_a == currency_b  = Money (a+b) currency_a
