module PriceList (
  Euro, Product(..)
) where

  newtype Euro = MakeEuro Double
  newtype US_Dollar = MakeUS_Dollar Double
  newtype Yen = MakeYen Double
  newtype Bitcoin = MakeBitcoin Double

  class Money a where
    (+) :: a -> a -> a
    amount :: a -> Double

  instance Money Euro where
    amount (MakeEuro a) = a
    (+) x y = MakeEuro (amount x Prelude.+ amount y)

  -- a product should not have a price or an amount
  data Product = Product {
        name :: String
      } deriving (Show)

  -- price definition is a product, a money instance and an matcher or something for the amount
  -- amount is a number and a unit

--  sameCurrency :: Money -> Money -> Bool
--  sameCurrency (Money _ currency_a) (Money _ currency_b) = currency_a == currency_b
--
--  addMoney :: Money -> Money -> Maybe Money
--  addMoney money_a@(Money a currency_a) money_b@(Money b currency_b)
--    | sameCurrency money_a money_b  = Just (Money (a+b) currency_a)
--    | otherwise = Nothing
