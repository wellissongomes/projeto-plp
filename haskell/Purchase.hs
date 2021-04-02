module Purchase where

import Candy
import TypeClasses
import Utils

import Data.List.Split

type PurchaseID = Int
type EmployeeID = Int
type CustomerID = Int
type Score = Int

data Purchase = Purchase {
  id :: PurchaseID,
  employeeID :: EmployeeID,
  customerID :: CustomerID,
  score :: Score,
  candies :: [Candy]
}
                                  
instance Show Purchase where
  show (Purchase id employeeID customerID score candies) = "\n" ++
                                                    "ID da compra: " ++ (show id) ++ "\n" ++
                                                    "ID do funcionario: " ++ (show employeeID) ++ "\n" ++
                                                    "ID do cliente: " ++ show customerID ++ "\n" ++
                                                    "Avalição (0 - 5): " ++ show score ++ "\n" ++
                                                    "\nDoces: " ++ show candies
          
instance Stringfy Purchase where
  toString (Purchase id employeeID customerID score candies) = show id ++ ";" ++
                                                       show employeeID ++ ";" ++
                                                       show customerID ++ ";" ++
                                                       show score ++ ";" ++
                                                       show (listOfAnythingToListOfToString candies)


listOfStringToListOfCandy l = map read l :: [Candy]
stringToListOfString str = read str :: [String]
stringToListOfCandies str = listOfStringToListOfCandy $ stringToListOfString str

instance Read Purchase where
  readsPrec _ str = do
  let l = splitOn ";" str
  let id = read (l !! 0) :: PurchaseID
  let employeeID = read (l !! 1) :: EmployeeID
  let customerID = read (l !! 2) :: CustomerID
  let score = read (l !! 3) :: Score
  let candies = stringToListOfCandies (l !! 4)
  [(Purchase id employeeID customerID score candies, "")]