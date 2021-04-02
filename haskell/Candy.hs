module Candy where 
import TypeClasses

import Data.List.Split

type CandyID = Int
type Name = String
type Description = String
type Price = Float

data Candy = Candy {
  id :: CandyID,
  name :: Name,
  description :: Description,
  price :: Price
}

instance Show Candy where
  show (Candy _ name description price) = "\n-----------------------\n" ++
                                       "Nome: " ++ name ++ "\n" ++
                                       "Descrição: " ++ description ++ "\n" ++ 
                                       "Preço: " ++ (show price) ++
                                       "\n-----------------------\n"

instance Stringfy Candy where
  toString (Candy id name description price) = show id ++ "," ++
                                              name ++ "," ++
                                              description ++ "," ++
                                              show price

instance Read Candy where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: CandyID
  let name = l !! 1
  let description = l !! 2
  let price = read (l !! 3) :: Price
  [(Candy id name description price, "")]