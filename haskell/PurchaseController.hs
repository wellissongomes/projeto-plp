module PurchaseController (
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