module ProductController (
  addCandy,
  addDrink,
  deleteCandy,
  deleteDrink,
  existsCandy,
  existsDrink,
  showProducts
) where
import Candy
import Drink
import Utils

addCandy :: Candy -> [Candy] -> [Candy]
addCandy candy candies = candies ++ [candy]

addDrink :: Drink -> [Drink] -> [Drink]
addDrink drink drinks = drinks ++ [drink]

deleteCandy :: Int -> [Candy] -> [Candy]
deleteCandy id candies = [c | c <- candies, (Candy.id c) /= id]

deleteDrink :: Int -> [Drink] -> [Drink]
deleteDrink id drinks = [d | d <- drinks, (Drink.id d) /= id]

existsCandy :: Int -> [Candy] -> Bool
existsCandy id candies = not $ null [c | c <- candies, (Candy.id c) == id]

existsDrink :: Int -> [Drink] -> Bool
existsDrink id drinks = not $ null [c | c <- drinks, (Drink.id c) == id]

-- showCandyMenu :: Show a => a -> String
-- showCandyMenu candyMenu = show candyMenu

showProducts :: [Candy] -> [Drink] -> String
showProducts candies drinks = "CARDAPIO: \n" ++
                              "\nDoces" ++ "\n" ++
                              showList' candies ++
                              "\nBebidas" ++  "\n" ++
                              showList' drinks