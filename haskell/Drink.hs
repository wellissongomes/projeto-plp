module Drink where

import Prelude hiding (id)

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

instance Item Drink where
  itemPrice drink = Drink.price drink

instance Show Drink where
  show (Drink id name description price) = "\n-----------------------\n" ++
                                         "ID: " ++ show id ++ "\n" ++
                                         "Nome: " ++ name ++ "\n" ++
                                         "Descrição: " ++ description ++ "\n" ++
                                         "Preço: " ++ show price ++ "\n" ++
                                         "-----------------------\n"

instance Stringfy Drink where
  toString (Drink id name description price) = show id ++ "," ++
                                              name ++ "," ++
                                              description ++ "," ++
                                              show price

instance Read Drink where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: DrinkID
  let name = l !! 1
  let description = l !! 2
  let price = read (l !! 3) :: Price
  [(Drink id name description price, "")]