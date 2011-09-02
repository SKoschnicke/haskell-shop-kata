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

  sameCurrency :: Money -> Money -> Bool
  sameCurrency (Money _ currency_a) (Money _ currency_b) = currency_a == currency_b

  addMoney :: Money -> Money -> Maybe Money
  addMoney money_a@(Money a currency_a) money_b@(Money b currency_b)
    | sameCurrency money_a money_b  = Just (Money (a+b) currency_a)
    | otherwise = Nothing
