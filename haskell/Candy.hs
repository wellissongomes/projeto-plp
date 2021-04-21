module Candy where 

import Prelude hiding (id)

import TypeClasses

import Data.List.Split

type CandyID = Int
type Name = String
type Description = String
type Price = Float
type ScoreCandy = Int

data Candy = Candy {
  id :: CandyID,
  name :: Name,
  description :: Description,
  price :: Price,
  scoreCandy :: ScoreCandy
}

instance Entity Candy where
  entityId candy = Candy.id candy

instance Item Candy where
  itemPrice candy = Candy.price candy

instance Show Candy where
  show (Candy id name description price scoreCandy) = "\n-----------------------\n" ++
                                       "ID: " ++ show id ++ "\n" ++
                                       "Nome: " ++ name ++ "\n" ++
                                       "Descrição: " ++ description ++ "\n" ++ 
                                       "Avaliação (0 - 5): " ++ show scoreCandy ++ "\n" ++
                                       "Preço: " ++ show price ++
                                       "\n-----------------------\n"

instance Stringfy Candy where
  toString (Candy id name description price scoreCandy) = show id ++ "," ++
                                              name ++ "," ++
                                              description ++ "," ++
                                              show price ++ "," ++
                                              show scoreCandy

instance Read Candy where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: CandyID
  let name = l !! 1
  let description = l !! 2
  let price = read (l !! 3) :: Price
  let scoreCandy = read (l !! 4) :: ScoreCandy
  [(Candy id name description price scoreCandy, "")]