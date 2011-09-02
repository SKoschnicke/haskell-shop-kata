{-# LANGUAGE GADTs #-}

data Empty
data NonEmpty
data List x y where
     Nil :: List a Empty
     Cons:: a -> List a b ->  List a NonEmpty

safeHead:: List x NonEmpty -> x
safeHead (Cons a b) = a

empty = Nil
list1 = Cons 1
list2 = Cons 1 . Cons 2 . Cons 3
