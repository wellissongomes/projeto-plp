module CandyMenu where
import Candy
import Drink

import Data.List.Split

data CandyMenu = CandyMenu {
  candies :: [Candy],
  drinks :: [Drink]
}

showList :: (Show a) => [a] -> String
showList [] = ""
showList (x:xs) = (show x) ++ showList xs

instance Show CandyMenu where
  show (CandyMenu candies drinks) = "Doces" ++ "\n" ++
                                  (showList candies) ++
                                  "Bebidas" ++  "\n" ++
                                  (showList drinks)