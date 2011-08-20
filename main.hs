
data Currency = Euro
              | US_Dollar
              | Yen
              | Bitcoin

-- money is an amount and a currency
data Money = Rational Currency

main = putStrLn "Hello world"
