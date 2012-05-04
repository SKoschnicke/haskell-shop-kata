module PriceList.Internal where

-- currencies
data Euro
data US_Dollar
data Yen
data Bitcoin

-- phantom type
-- NOTE: the currency string is only added to have the currency at runtime,
-- correctness is ensured at compile-time even without the string
data Money currency = Money {
  amount :: Double
} deriving (Show)

-- this should be exported, not the type itself
makeEuro :: Double -> Money Euro
makeEuro a = (Money a)

makeYen :: Double -> Money Yen
makeYen a = (Money a)

class Currency a where currencyCode :: Money a -> String

instance Currency Euro where currencyCode _ = "EUR"
instance Currency US_Dollar where currencyCode _ = "USD"
instance Currency Yen where currencyCode _ = "YEN"
instance Currency Bitcoin where currencyCode _ = "BC"

instance Eq (Money a) where
  (==) (Money amount_a) (Money amount_b) = amount_a == amount_b

(+) :: Money a -> Money a -> Money a
(+) x y = (Money (amount x Prelude.+ amount y))

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
