module Order where
  
import Candy
import Drink

import TypeClasses
import Utils

import Data.List.Split

type Quantity = Int

data Order = Order {
  drinks :: [(Quantity, Drink)],
  candies :: [(Quantity, Candy)]
}

instance Show Order where
  show (Order drinks candies) = "\nBebidas" ++  "\n" ++
                                "\n" ++ showListOfItems drinks ++ "\n" ++
                                "Doces" ++ "\n" ++
                                "\n" ++ showListOfItems candies 

instance Stringfy Order where
  toString (Order drinks candies) = show (listOfTupleToListOfString drinks) ++ ";" ++
                                    show (listOfTupleToListOfString candies)