module Drink where
import TypeClasses

import Data.List.Split

type DrinkID = Int
type Name = String
type Description = String
type Price = Float

data Drink = Drink {
  id :: DrinkID,
  name :: Name,
  description :: Description,
  price :: Price
}

instance Show Drink where
  show (Drink _ name description price) = "\n-----------------------\n" ++
                                         "Nome: " ++ name ++ "\n" ++
                                         "Descrição: " ++ description ++ "\n" ++
                                         "Preço: " ++ (show price) ++ "\n" ++
                                         "\n-----------------------\n"

instance Stringfy Drink where
  toString (Drink id name description price) = show id ++ "," ++
                                              name ++ "," ++
                                              description ++ "," ++
                                              show price

instance Read Drink where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: Int
  let name = read (l !! 1) :: String
  let description = read (l !! 2) :: String
  let price = read (l !! 3) :: Float
  [(Drink id name description price, "")]