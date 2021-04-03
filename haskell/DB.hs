module DB where

import Employee
import Candy
import Customer
import Purchase
import Drink
import CandyMenu
import TypeClasses
import Utils

data DB = DB {
  employees :: [Employee],
  customers :: [Customer],
  candies :: [Candy],
  purchases :: [Purchase],
  drinks :: [Drink],
  candyMenu :: CandyMenu
} deriving (Show)

listOfStringToListOfEmployees l = map read l :: [Employee]
listOfStringToListOfCustomers l = map read l :: [Customer]
listOfStringToListOfCandies l = map read l :: [Candy]
listOfStringToListOfPurchases l = map read l :: [Purchase]
listOfStringToListOfDrinks l = map read l :: [Drink]
stringToCandyMenu str = read str :: CandyMenu

addToFile :: Stringfy a => FilePath -> a -> IO ()
addToFile path content = appendFile path (toString content ++ "\n")

readFile' path = readFile $ "./db/" ++ path

connect :: IO DB
connect = do
  employeesContent <- readFile' "funcionario.txt"
  customersContent <- readFile' "cliente.txt"
  candiesContent <- readFile' "doce.txt"
  purchasesContent <- readFile' "compra.txt"
  drinksContent <- readFile' "bebida.txt"
  candyMenuContent <- readFile' "cardapio.txt"

  let employees = listOfStringToListOfEmployees $ splitForFile $ employeesContent
  let customers = listOfStringToListOfCustomers $ splitForFile $ customersContent
  let candies = listOfStringToListOfCandies $ splitForFile $ candiesContent
  let purchases = listOfStringToListOfPurchases $ splitForFile $ purchasesContent
  let drinks = listOfStringToListOfDrinks $ splitForFile $ drinksContent
  let candyMenu = stringToCandyMenu $ (splitForFile $ candyMenuContent) !! 0

  return (DB employees customers candies purchases drinks candyMenu) 

deleteAll :: IO ()
deleteAll = do
  let path = "./db/"

  writeFile (path ++ "funcionario.txt") ""
  writeFile (path ++ "cliente.txt") ""
  writeFile (path ++ "doce.txt") ""
  writeFile (path ++ "compra.txt") ""
  writeFile (path ++ "bebida.txt") ""
  writeFile (path ++ "cardapio.txt") ""