module OwnerInteraction where

import DB
import Utils
import Candy
import Drink
import Employee
import CandyMenu

getCredentials :: [Employee] -> IO [String]
getCredentials employees = do
  ssn <- input "CPF: "
  if existsPerson employees ssn then do
    putStr "CPF já cadastrado.\n"
    waitTwoSeconds
    getCredentials employees
  else do
    name <- input "Nome: "
    age <- input "Idade: "
    return [ssn,name,age]

getRole :: IO String
getRole = do
   putStr "\n(1) Confeitero\n(2) Vendedor\n\n"
   role <- input "Cargo: "
   if role == "1" then 
     return "confeitero"
   else if role == "2" then
     return "vendedor"
   else
     getRole

registerOwner :: DB -> (DB -> IO()) -> IO ()
registerOwner db start = do
  let employees = DB.employees db

  let employeeId = (DB.currentIdEmployee db) + 1

  [ssn, name, age] <- getCredentials employees
  let role = "dono"

  if existsPerson employees ssn then do
    putStr "CPF já cadastrado.\n"
    waitTwoSeconds
    start db
  else do
    let employee = (Employee employeeId ssn name (read age) role)

    DB.entityToFile employee "funcionario.txt" "empId.txt"
    let newDB = db {DB.employees = employees ++ [employee], DB.currentIdEmployee = employeeId}
    
    clear
    putStr "Dono cadastrado com sucesso!"
    putStr $ show employee
    waitThreeSeconds

    start newDB

registerEmployee :: DB -> Interaction -> Int -> IO ()
registerEmployee db ownerInteraction ownerId = do
  let employees = DB.employees db

  let employeeId = (DB.currentIdEmployee db) + 1

  [ssn, name, age] <- getCredentials employees
  
  role <- getRole 
  let employee = (Employee employeeId ssn name (read age) role)

  DB.entityToFile employee "funcionario.txt" "empId.txt"
  let newDB = db {DB.employees = employees ++ [employee], DB.currentIdEmployee = employeeId}
  
  clear
  putStr "Funcionário cadastrado com sucesso!"
  putStr $ show employee
  waitThreeSeconds

  ownerInteraction newDB ownerId

registerCandy :: DB -> Interaction -> Int -> IO ()
registerCandy db ownerInteraction ownerId = do
  let candies = (DB.candies db)
  let candyId = (DB.currentIdCandy db) + 1

  name <- input "Nome do doce: "
  description <- input "Descrição: "
  price <- input "Preço: "

  let defaultScoreCandy = 5
  let candy = (Candy candyId name description (read price) defaultScoreCandy)

  DB.entityToFile candy "doce.txt" "candyId.txt"
  let newDB = db {DB.candies = addCandy candy candies, DB.currentIdCandy = candyId}
  
  clear
  putStr "Doce cadastrado com sucesso!"
  putStr $ show candy
  waitThreeSeconds

  ownerInteraction newDB ownerId

removeCandy :: DB -> Interaction -> Int -> IO ()
removeCandy db ownerInteraction ownerId = do
  let candies = (DB.candies db)
  existsEntityWithMsg candies "Não há doces presentes no sistema." (ownerInteraction db ownerId)
  candyId <- input "ID: "
  if not $ existsEntity candies (read candyId) then do
    putStr "Doce não cadastrado.\n"
    waitTwoSeconds
    ownerInteraction db ownerId
  else do
    print $ getEntityById candies (read candyId) 
    let newCandyList = deleteCandy (read candyId) candies
    putStr "Doce removido com sucesso.\n"
    waitThreeSeconds
    DB.writeToFile "doce.txt" newCandyList

    let newDB = db {DB.candies = newCandyList}
    ownerInteraction newDB ownerId

registerDrink :: DB -> Interaction -> Int -> IO()
registerDrink db ownerInteraction ownerId = do
  let drinks = (DB.drinks db)
  let drinkId = (DB.currentIdDrink db) + 1

  name <- input "Nome: "
  description <- input "Descrição: "
  price <- input "Preço: "

  let defaultScoreDrink = 5
  let drink = (Drink drinkId name description (read price) defaultScoreDrink)

  DB.entityToFile drink "bebida.txt" "drinkId.txt"
  let newDB = db {DB.drinks = addDrink drink drinks, DB.currentIdDrink = drinkId}

  clear
  putStr "Bebida cadastrada com sucesso!"
  putStr $ show drink
  waitThreeSeconds
  clear

  ownerInteraction newDB ownerId

removeDrink :: DB -> Interaction -> Int -> IO ()
removeDrink db ownerInteraction ownerId = do
  let drinks = (DB.drinks db)
  existsEntityWithMsg drinks "Não há bebidas presentes no sistema." (ownerInteraction db ownerId)
  drinkId <- input "ID: "
  if not $ existsEntity drinks (read drinkId) then do
    putStr "Bebida não cadastrada.\n"
    waitTwoSeconds
    ownerInteraction db ownerId
  else do
    print $ getEntityById drinks (read drinkId) 
    let newDrinkList = deleteDrink (read drinkId) drinks
    putStr "Bebida removida com sucesso.\n"
    waitThreeSeconds
    DB.writeToFile "bebida.txt" newDrinkList

    let newDB = db {DB.drinks = newDrinkList}
    ownerInteraction newDB ownerId