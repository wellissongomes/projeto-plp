module Order where
  
import Candy
import Drink

import TypeClasses
import Utils

import Data.List.Split

data Order = Order {
  candies :: [Candy],
  drinks :: [Drink]
}

instance Show Order where
  show (Order candies drinks) = "\nDoces" ++ "\n" ++
                                showList' candies ++
                                "\nBebidas" ++  "\n" ++
                                showList' drinks

instance Stringfy Order where
  toString (Order candies drinks) = show (listOfAnythingToListOfToString candies) ++ ";" ++
                                    show (listOfAnythingToListOfToString drinks)