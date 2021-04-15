module PurchaseController (
  getCandyById,
  getDrinkById,
  candyExists,
  drinkExists,
  calculatePrice,
  getPurchasesByCustomer,
  customerHasPurchase
) where

import Candy
import Drink
import Order
import Purchase

import Utils

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

customerHasPurchase :: Int -> [Purchase] -> Bool
customerHasPurchase id purchases = not $ null $ getPurchasesByCustomer id purchases

getPurchasesByCustomer :: Int -> [Purchase] -> String
getPurchasesByCustomer id purchases = showList' [p | p <- purchases, (Purchase.customerID p) == id]