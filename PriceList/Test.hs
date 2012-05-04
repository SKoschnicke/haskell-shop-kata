module PriceList.Test where

import Test.QuickCheck
import PriceList.Internal

instance Arbitrary (Money a) where
  arbitrary = do
      amount <- arbitrary
      return (Money amount)

prop_commutative a b = a PriceList.Internal.+ b == b PriceList.Internal.+ a

main = quickCheck (prop_commutative :: Money a -> Money a -> Bool)
