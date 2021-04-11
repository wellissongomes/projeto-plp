module CandyMenu where

import Candy
import Drink

import TypeClasses
import Utils

import Data.List.Split

data CandyMenu = CandyMenu {
  candies :: [Candy],
  drinks :: [Drink]
}

instance Show CandyMenu where
  show (CandyMenu candies drinks) = "Doces" ++ "\n" ++
                                  showList' candies ++
                                  "\nBebidas" ++  "\n" ++
                                  showList' drinks

instance Stringfy CandyMenu where
  toString (CandyMenu candies drinks) = show (listOfAnythingToListOfToString candies) ++ ";" ++
                                        show (listOfAnythingToListOfToString drinks)

instance Read CandyMenu where
  readsPrec _ str = do
  let l = splitOn ";" str
  let candies = stringToListOfCandies (l !! 0)
  let drinks = stringToListOfDrinks (l !! 1)
  [(CandyMenu candies drinks, "")]