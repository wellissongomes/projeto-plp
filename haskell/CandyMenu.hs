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

listOfStringToListOfCandy l = map read l :: [Candy]
listOfStringToListOfDrink l = map read l :: [Drink]
stringToListOfString str = read str :: [String]

stringToListOfCandies str = listOfStringToListOfCandy $ stringToListOfString str
stringToListOfDrinks str = listOfStringToListOfDrink $ stringToListOfString str

instance Read CandyMenu where
  readsPrec _ str = do
  let l = splitOn ";" str
  let candies = stringToListOfCandies (l !! 0)
  let drinks = stringToListOfDrinks (l !! 1)
  [(CandyMenu candies drinks, "")]