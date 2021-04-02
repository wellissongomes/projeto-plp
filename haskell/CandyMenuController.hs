module CandyMenuController where
import CandyMenu
import Candy
import Drink

addCandyToCandyMenu :: Candy -> CandyMenu -> [Candy]
addCandyToCandyMenu candy candyMenu = (CandyMenu.candies candyMenu) ++ [candy]

addDrinkToCandyMenu :: Drink -> CandyMenu -> [Drink]
addDrinkToCandyMenu drink candyMenu = (CandyMenu.drinks candyMenu) ++ [drink]

deleteCandyFromCandyMenu :: Int -> CandyMenu -> [Candy]
deleteCandyFromCandyMenu id candyMenu = [c | c <- (CandyMenu.candies candyMenu), (Candy.id c) /= id]

deleteDrinkFromCandyMenu :: Int -> CandyMenu -> [Drink]
deleteDrinkFromCandyMenu id candyMenu = [d | d <- (CandyMenu.drinks candyMenu), (Drink.id d) /= id]