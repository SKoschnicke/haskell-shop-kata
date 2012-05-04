import Test.QuickCheck
import PriceList

instance Arbitrary (Money a) where
  arbitrary = do
      amount <- arbitrary
      return (createFun amount)
    where
      createFun =
        oneof [
          makeEuro
        , makeYen
        ]

prop_commutative a b = a + b == b + a

main = quickCheck (prop_commutative :: Money a -> Money a -> Bool)
