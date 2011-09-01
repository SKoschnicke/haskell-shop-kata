import Test.QuickCheck
import PriceList

instance Arbitrary Currency where
  arbitrary = elements [Euro, US_Dollar, Yen, Bitcoin]

instance Arbitrary Money where
  arbitrary = do
    amount <- arbitrary
    currency <- arbitrary
    return (Money amount currency)

prop_commutative a b = addMoney a b == addMoney b a

main = quickCheck (prop_commutative :: Money -> Money -> Bool)
