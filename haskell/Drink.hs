module Drink where

import Prelude hiding (id)

import TypeClasses

import Data.List.Split

type DrinkID = Int
type Name = String
type Description = String
type Price = Float
type ScoreDrink = Int

data Drink = Drink {
  id :: DrinkID,
  name :: Name,
  description :: Description,
  price :: Price,
  scoreDrink :: ScoreDrink
}

instance Entity Drink where
  entityId drink = Drink.id drink

instance Item Drink where
  itemPrice drink = Drink.price drink

instance Show Drink where
  show (Drink id name description price scoreDrink) = "\n-----------------------\n" ++
                                         "ID: " ++ show id ++ "\n" ++
                                         "Nome: " ++ name ++ "\n" ++
                                         "Descrição: " ++ description ++ "\n" ++
                                         "Avaliação (0 - 5): " ++ show scoreDrink ++ "\n" ++
                                         "Preço: " ++ show price ++ "\n" ++
                                         "-----------------------\n"

instance Stringfy Drink where
  toString (Drink id name description price scoreDrink) = show id ++ "," ++
                                              name ++ "," ++
                                              description ++ "," ++
                                              show price ++ "," ++
                                              show scoreDrink

instance Read Drink where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: DrinkID
  let name = l !! 1
  let description = l !! 2
  let price = read (l !! 3) :: Price
  let scoreDrink = read (l !! 4) :: ScoreDrink
  [(Drink id name description price scoreDrink, "")]