module Purchase where

import Candy
import Order

import TypeClasses
import Utils

import Data.List.Split

type PurchaseID = Int
type EmployeeID = Int
type CustomerID = Int
type Score = Int
type PurchasePrice = Float

data Purchase = Purchase {
  id :: PurchaseID,
  employeeID :: EmployeeID,
  customerID :: CustomerID,
  score :: Score,
  order :: Order,
  price :: PurchasePrice
}
                                  
instance Show Purchase where
  show (Purchase id employeeID customerID score order price) = "\n" ++
                                                    "ID da compra: " ++ show id ++ "\n" ++
                                                    "ID do funcionario: " ++ show employeeID ++ "\n" ++
                                                    "ID do cliente: " ++ show customerID ++ "\n" ++
                                                    "Avalição (0 - 5): " ++ show score ++ "\n" ++
                                                    "Valor total a pagar: " ++ show price ++ "\n" ++
                                                    "\nPedido: \n" ++ show order
          
instance Stringfy Purchase where
  toString (Purchase id employeeID customerID score order price) = show id ++ ";" ++
                                                       show employeeID ++ ";" ++
                                                       show customerID ++ ";" ++
                                                       show score ++ ";" ++
                                                       toString order ++ ";" ++
                                                       show price

instance Read Purchase where
  readsPrec _ str = do
  let l = splitOn ";" str
  let id = read (l !! 0) :: PurchaseID
  let employeeID = read (l !! 1) :: EmployeeID
  let customerID = read (l !! 2) :: CustomerID
  let score = read (l !! 3) :: Score
  let drinks = stringToListOfCandies (l !! 4)
  let candies = stringToListOfDrinks (l !! 5)
  let order = Order drinks candies
  let price = read (l !! 6) :: PurchasePrice
  [(Purchase id employeeID customerID score order price, "")]