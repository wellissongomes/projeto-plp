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

showList' :: (Show a) => [a] -> String
showList' [] = ""
showList' (x:xs) = (show x) ++ showList' xs

instance Show CandyMenu where
  show (CandyMenu candies drinks) = "Doces" ++ "\n" ++
                                  (showList' candies) ++
                                  "Bebidas" ++  "\n" ++
                                  (showList' drinks)

instance Stringfy CandyMenu where
  toString (CandyMenu candies drinks) = show (listOfAnythingToListOfToString candies) ++ ";" ++
                                        show (listOfAnythingToListOfToString drinks)