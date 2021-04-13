module PurchaseController (
  getCandyById,
  getDrinkById,
  candyExists,
  drinkExists
) where

import Candy
import Drink

getCandyById id candies = head [c | c <- candies, (Candy.id c) == id]

getDrinkById id drinks = head [d | d <- drinks, (Drink.id d) == id]

candyExists id candies = not $ null [c | c <- candies, (Candy.id c) == id]

drinkExists id drinks = not $ null [d | d <- drinks, (Drink.id d) == id]