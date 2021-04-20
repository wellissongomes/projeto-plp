module DB where

import qualified System.IO.Strict as SIO

import Employee
import Candy
import Customer
import Purchase
import Drink
import TypeClasses
import Utils

type Interaction = (DB -> Int -> IO ())

data DB = DB {
  employees :: [Employee],
  customers :: [Customer],
  candies :: [Candy],
  purchases :: [Purchase],
  drinks :: [Drink],
  currentIdEmployee :: Int,
  currentIdCustomer :: Int,
  currentIdCandy :: Int,
  currentIdDrink :: Int,
  currentIdPurchase :: Int,
  currentIdOwner :: Int
} deriving (Show)

listOfStringToListOfEmployees l = map read l :: [Employee]
listOfStringToListOfCustomers l = map read l :: [Customer]
listOfStringToListOfCandies l = map read l :: [Candy]
listOfStringToListOfPurchases l = map read l :: [Purchase]
listOfStringToListOfDrinks l = map read l :: [Drink]
stringToInt str = read str :: Int

addToFile :: Stringfy a => FilePath -> a -> IO ()
addToFile path content = appendFile ("./db/" ++ path) (toString content ++ "\n")

writeToFile :: Stringfy a => FilePath -> [a] -> IO ()
writeToFile path content = writeFile ("./db/" ++ path) (listOfAnythingToString content)

writeIdToFile path id = writeFile ("./db/" ++ path) (show id)

readFile' path = SIO.readFile $ "./db/" ++ path

entityToFile :: (Entity a, Stringfy a) => a -> String -> String -> IO ()
entityToFile a entityFile idFile = do
  addToFile entityFile a
  writeIdToFile idFile (entityId a)
  return ()

connect :: IO DB
connect = do
  employeesContent <- readFile' "funcionario.txt"
  customersContent <- readFile' "cliente.txt"
  candiesContent <- readFile' "doce.txt"
  purchasesContent <- readFile' "compra.txt"
  drinksContent <- readFile' "bebida.txt"

  currentIdEmployeeContent <- readFile' "empId.txt"
  currentIdCustomerContent <- readFile' "custId.txt"
  currentIdCandyContent <- readFile' "candyId.txt"
  currentIdDrinkContent <- readFile' "drinkId.txt"
  currentIdPurchaseContent <- readFile' "purchaseId.txt"
  currentIdOwnerContent <- readFile' "ownerId.txt"

  let employees = listOfStringToListOfEmployees $ splitForFile $ employeesContent
  let customers = listOfStringToListOfCustomers $ splitForFile $ customersContent
  let candies = listOfStringToListOfCandies $ splitForFile $ candiesContent
  let purchases = listOfStringToListOfPurchases $ splitForFile $ purchasesContent
  let drinks = listOfStringToListOfDrinks $ splitForFile $ drinksContent

  let currentIdEmployee = stringToInt currentIdEmployeeContent
  let currentIdCustomer = stringToInt currentIdCustomerContent
  let currentIdCandy = stringToInt currentIdCandyContent
  let currentIdDrink = stringToInt currentIdDrinkContent
  let currentIdPurchase = stringToInt currentIdPurchaseContent
  let currentIdOwner = stringToInt currentIdOwnerContent

  return (DB employees customers candies purchases drinks currentIdEmployee currentIdCustomer currentIdCandy currentIdDrink currentIdPurchase currentIdOwner) 

deleteAll :: IO ()
deleteAll = do
  let path = "./db/"

  writeFile (path ++ "funcionario.txt") ""
  writeFile (path ++ "cliente.txt") ""
  writeFile (path ++ "doce.txt") ""
  writeFile (path ++ "compra.txt") ""
  writeFile (path ++ "bebida.txt") ""