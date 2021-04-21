module Purchase where

import Candy
import Drink
import Order

import TypeClasses
import Utils

import Data.List.Split

type PurchaseID = Int
type EmployeeID = Int
type CustomerID = Int
type Score = Int
type PurchasePrice = Float
type HasBeenReviewed = Bool

data Purchase = Purchase {
  id :: PurchaseID,
  employeeID :: EmployeeID,
  customerID :: CustomerID,
  score :: Score,
  order :: Order,
  price :: PurchasePrice,
  hasBeenReviewed :: HasBeenReviewed
}

instance Entity Purchase where
  entityId purchase = Purchase.id purchase
                                  
instance Show Purchase where
  show (Purchase id employeeID customerID score order price _) = "\n" ++
                                                    "ID da compra: " ++ show id ++ "\n" ++
                                                    "ID do funcionario: " ++ show employeeID ++ "\n" ++
                                                    "ID do cliente: " ++ show customerID ++ "\n" ++
                                                    "Avalição (0 - 5): " ++ show score ++ "\n" ++
                                                    "Valor total a pagar: " ++ show price ++ "\n" ++
                                                    "\nPedido: \n" ++ show order
          
instance Stringfy Purchase where
  toString (Purchase id employeeID customerID score order price hasBeenReviewed) = show id ++ ";" ++
                                                       show employeeID ++ ";" ++
                                                       show customerID ++ ";" ++
                                                       show score ++ ";" ++
                                                       toString order ++ ";" ++
                                                       show price ++ ";" ++
                                                       show hasBeenReviewed

instance Read Purchase where
  readsPrec _ str = do
  let l = splitOn ";" str
  let id = read (l !! 0) :: PurchaseID
  let employeeID = read (l !! 1) :: EmployeeID
  let customerID = read (l !! 2) :: CustomerID
  let score = read (l !! 3) :: Score

  let drinksStr = l !! 4
  let candiesStr = l !! 5

  let drinks = map stringToTupleOfDrinks $ stringToListOfString drinksStr
  let candies = map stringToTupleOfCandies $ stringToListOfString candiesStr

  let order = Order drinks candies
  let price = read (l !! 6) :: PurchasePrice
  let hasBeenReviewed = read (l !! 7) :: HasBeenReviewed
  [(Purchase id employeeID customerID score order price hasBeenReviewed, "")]