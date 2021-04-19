module CandyMenu (
  addCandy,
  addDrink,
  deleteCandy,
  deleteDrink,
  showCandyMenu,
  showCandyMenuFiltered
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

showCandyMenu :: [Candy] -> [Drink] -> String
showCandyMenu candies drinks = 
  if null candies && null drinks then do
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ "\nNão há doces disponíveis." ++ "\n" ++ "\nBebidas\n"  ++ "\nNão há bebidas disponíveis\n"
  else if null candies then do 
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ "\nNão há doces disponíveis." ++ "\n" ++ "\nBebidas" ++  "\n" ++ showList' drinks
  else if null drinks then do
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ showList' candies ++ "\nBebidas" ++ "\n" ++ "\nNão há bebidas disponíveis.\n" 
  else do
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ showList' candies ++ "\nBebidas" ++  "\n" ++ showList' drinks
                              
showCandyMenuFiltered :: [Candy] -> [Drink] -> String
showCandyMenuFiltered candies drinks = 
  if null candies && null drinks then do
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ "\nNão há doces disponíveis." ++ "\n" ++ "\nBebidas\n"  ++ "\nNão há bebidas disponíveis\n"
  else if null candies then do 
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ "\nNão há doces disponíveis." ++ "\n" ++ "\nBebidas" ++  "\n" ++ showList' (_drinksFiltered drinks)
  else if null drinks then do
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ showList' (_candiesFiltered candies) ++ "\nBebidas" ++ "\n" ++ "\nNão há bebidas disponíveis.\n" 
  else do
    "CARDAPIO: \n" ++ "\nDoces" ++ "\n" ++ showList' (_candiesFiltered candies) ++ "\nBebidas" ++  "\n" ++ showList' (_drinksFiltered drinks)

_drinksFiltered drinks = [d | d <- drinks, (Drink.scoreDrink d) >= 4]
_candiesFiltered candies = [c | c <- candies, (Candy.scoreCandy c) >= 4]