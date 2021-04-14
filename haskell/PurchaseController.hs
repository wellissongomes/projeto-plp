module PurchaseController (
  getCandyById,
  getDrinkById,
  candyExists,
  drinkExists,
  calculatePrice
) where

import Candy
import Drink
import Order

import TypeClasses

getCandyById id candies = head [c | c <- candies, (Candy.id c) == id]

getDrinkById id drinks = head [d | d <- drinks, (Drink.id d) == id]

candyExists id candies = not $ null [c | c <- candies, (Candy.id c) == id]

drinkExists id drinks = not $ null [d | d <- drinks, (Drink.id d) == id]

_calculatePrice :: Item a => (Int, a) -> Float
_calculatePrice item = (fromIntegral $ fst item) * (itemPrice $ snd item)

_calculateTotalPrice :: Item a => [(Int, a)] -> Float
_calculateTotalPrice l = sum $ map _calculatePrice l

calculatePrice :: Order -> Float
calculatePrice order = (_calculateTotalPrice $ Order.drinks order) + (_calculateTotalPrice $ Order.candies order)