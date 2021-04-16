import Chat
import Employee
import Candy
import Customer
import Purchase
import TypeClasses
import Drink
import Order
import Utils
import DB
import CandyMenu
import EmployeeController
import PurchaseController

import Prelude hiding (id)

import Data.List.Split 

main = do
  dados <- DB.connect
  start dados

start :: DB -> IO()
start db = do
  clear 
  putStr slogan
  waitTwoSeconds
  clear

  putStr options

  option <- input "Número: "

  let number = read option

  if number == 1 then do
    clear
    ownerInteraction db
  else if number == 2 then do
    clear
    cId <- input "Digite o seu ID: "

    clear
    customerInteraction db (read cId)
  else if number == 3 then do
    clear
    fId <- input "Digite o seu ID: "
    clear

    employeeInteraction db (read fId) 
  else do
    start db

ownerInteraction :: DB -> IO ()
ownerInteraction db = do
  clear
  ownerId <- input "ID do dono: "
  
  let employees = DB.employees db

  if not $ existsEntity employees (read ownerId) then do
    putStr "Dono não cadastrado.\n"
    op <- input "\nGostaria de cadastrar um dono? [S - SIM ou qualquer letra para NÃO]: "
    if head op `elem` "Ss" then do
      registerEmployee db
    else do
      start db
  else if not $ hasPermission (read ownerId) employees "dono" then do
    putStr "O ID informado não pertence a um Dono.\n"
    waitTwoSeconds
    start db
  else do
    putStr ownerOptions

    option <- input "Número: "

    let number = read option

    if number == 1 then do
      registerEmployee db
    else if number == 2 then do
      registerCandy db
    else if number == 3 then do
      registerDrink db
    else if number == 4 then do
      removeCandy db
    else if number == 5 then do
      removeDrink db
    else if number == 6 then do
      displayEntity (DB.employees db) "funcionários"
      ownerInteraction db
    else if number == 7 then do
      displayEntity (DB.candies db) "doces"
      ownerInteraction db
    else if number == 8 then do
      displayEntity (DB.drinks db) "bebidas"
      ownerInteraction db
    else if number == 9 then do
      displayEntity (DB.purchases db) "vendas"
      ownerInteraction db
    else if number == 10 then do
      start db
    else do
      putStr ""

registerCandy :: DB -> IO ()
registerCandy db = do
  let candies = (DB.candies db)
  let candyId = (DB.currentIdCandy db) + 1

  name <- input "Nome do doce: "
  description <- input "Descrição: "
  price <- input "Preço: "

  let candy = (Candy candyId name description (read price))

  DB.entityToFile candy "doce.txt" "candyId.txt"
  let newDB = db {DB.candies = addCandy candy candies, DB.currentIdCandy = candyId}
  
  clear
  putStr "Doce cadastrado com sucesso!"
  putStr $ show candy
  waitThreeSeconds

  ownerInteraction newDB

removeCandy :: DB -> IO ()
removeCandy db = do
  let candies = (DB.candies db)

  candyId <- input "ID: "

  if not $ existsEntity candies (read candyId) then do
    putStr "Doce não cadastrado.\n"
    waitTwoSeconds
    ownerInteraction db
  else do
    let newCandyList = deleteCandy (read candyId) candies

    DB.writeToFile "doce.txt" newCandyList

    let newDB = db {DB.candies = newCandyList}
    ownerInteraction newDB

removeDrink :: DB -> IO ()
removeDrink db = do
  let drinks = (DB.drinks db)

  drinkId <- input "ID: "
  if not $ existsEntity drinks (read drinkId) then do
    putStr "Bebida não cadastrada.\n"
    waitTwoSeconds
    ownerInteraction db
  else do
    let newDrinkList = deleteDrink (read drinkId) drinks

    DB.writeToFile "bebida.txt" newDrinkList

    let newDB = db {DB.drinks = newDrinkList}
    ownerInteraction newDB

registerEmployee :: DB -> IO ()
registerEmployee db = do
  let employees = DB.employees db

  let employeeId = (DB.currentIdEmployee db) + 1

  ssn <- input "CPF: "
  name <- input "Nome: "
  age <- input "Idade: "
  role <- input "Cargo: "

  if existsPerson employees ssn then do
    putStr "Funcionário já cadastrado.\n"
    waitTwoSeconds
    ownerInteraction db
  else do
    let employee = (Employee employeeId ssn name (read age) role)

    DB.entityToFile employee "funcionario.txt" "empId.txt"
    let newDB = db {DB.employees = employees ++ [employee], DB.currentIdEmployee = employeeId}
    
    clear
    putStr "Funcionário cadastrado com sucesso!"
    putStr $ show employee
    waitThreeSeconds

    ownerInteraction newDB

registerDrink :: DB -> IO()
registerDrink db = do
  let drinks = (DB.drinks db)
  let drinkId = (DB.currentIdDrink db) + 1

  name <- input "Nome: "
  description <- input "Descrição: "
  price <- input "Preço: "

  let drink = (Drink drinkId name description (read price))

  DB.entityToFile drink "bebida.txt" "drinkId.txt"
  let newDB = db {DB.drinks = addDrink drink drinks, DB.currentIdDrink = drinkId}

  clear
  putStr "Bebida cadastrada com sucesso!"
  putStr $ show drink
  waitThreeSeconds

  ownerInteraction newDB

customerInteraction :: DB -> Int -> IO ()
customerInteraction db customerId = do
  let customers = DB.customers db

  if not $ existsEntity customers customerId then do
    putStr "Usuário inexistente...\n"
    waitTwoSeconds
    clear
    start db
  else do
    putStr customerOptions

    option <- input "Número: "
    let num = read option

    if num == 2 then do
      clear
      putStr $ showCandyMenu (DB.candies db) (DB.drinks db)
      waitFiveSeconds
      clear
      customerInteraction db customerId
    else if num == 3 then do
      clear
      customerPurchase db customerId
    else if num == 4 then do
      clear
      customerViewCandyMenu db customerId
    else if num == 6 then do
      start db
    else do
      customerInteraction db customerId

_chooseCandy :: DB -> [Int] -> IO (Int, Candy)
_chooseCandy db candyIds = do
  clear
  candyId <- input "ID do doce: "

  if (read candyId) `elem` candyIds then do
    _chooseCandy db candyIds
  else if not $ existsEntity (DB.candies db) (read candyId) then do
    _chooseCandy db candyIds
  else do
    quantityCandy <- input "Digite a quantidade: "

    let candy = getEntityById (DB.candies db) (read candyId)

    return (read quantityCandy, candy)

_makeOrderCandy :: [(Int, Candy)] -> DB -> IO [(Int, Candy)]
_makeOrderCandy candies db = do
  clear

  let candyIds = [Candy.id candy | (_, candy) <- candies]
  
  let totalCandies = length $ DB.candies db
  let currAmountCandies = length $ candyIds

  if currAmountCandies >= totalCandies then do
    return candies
  else do
    op <- input "Deseja outro doce? [S/Qualquer tecla (letra)]: "

    if head op `elem` "Ss" then do
      candyTuple <- _chooseCandy db candyIds
      _makeOrderCandy (candyTuple:candies) db
    else do
      return candies

_chooseDrink :: DB -> [Int] -> IO (Int, Drink)
_chooseDrink db drinkIds = do
  clear
  drinkId <- input "ID da bebida: "

  if (read drinkId) `elem` drinkIds then do
    _chooseDrink db drinkIds
  else if not $ existsEntity (DB.drinks db) (read drinkId) then do
    _chooseDrink db drinkIds
  else do
    quantityDrink <- input "Digite a quantidade: "

    let candy = getEntityById (DB.drinks db) (read drinkId)

    return (read quantityDrink, candy)

_makeOrderDrink :: [(Int, Drink)] -> DB -> IO [(Int, Drink)]
_makeOrderDrink drinks db = do
  clear

  let drinkIds = [Drink.id drink | (_, drink) <- drinks]
  
  let totalDrinks = length $ DB.drinks db
  let currAmountDrinks = length $ drinkIds

  if currAmountDrinks >= totalDrinks then do
    return drinks
  else do
    op <- input "Deseja outra bebida? [S/Qualquer tecla (letra)]: "

    if head op `elem` "Ss" then do
      drinkTuple <- _chooseDrink db drinkIds
      _makeOrderDrink (drinkTuple:drinks) db
    else do
      return drinks

customerPurchase :: DB -> Int -> IO ()
customerPurchase db currentCustomerId = do 
  employeeId <- input "ID do funcionário: "
  
  let employees = DB.employees db

  if not $ existsEntity employees (read employeeId) then do
    putStr "Funcionário não cadastrado.\n"
    waitTwoSeconds
    customerPurchase db currentCustomerId
  else if not $ hasPermission (read employeeId) employees "vendedor" then do
    putStr "Funcionário tem que ser um vendedor.\n"
    waitTwoSeconds
    customerPurchase db currentCustomerId
  else do
    let candyIds = []
    candyTuple <- _chooseCandy db candyIds
    candies <- _makeOrderCandy [candyTuple] db

    let drinkIds = []
    drinkTuple <- _chooseDrink db drinkIds
    drinks <- _makeOrderDrink [drinkTuple] db

    let purchaseId = (DB.currentIdPurchase db) + 1
    let score = 5 
    let order = Order drinks candies
    let price = calculatePrice order
    let purchase = Purchase purchaseId (read employeeId) currentCustomerId score order price

    putStr $ show purchase

    DB.entityToFile purchase "compra.txt" "purchaseId.txt"
    let newDB = db {DB.purchases = (DB.purchases db) ++ [purchase], DB.currentIdPurchase = purchaseId}

    waitFiveSeconds
    clear
    customerInteraction newDB currentCustomerId

backToCustomerInteraction :: DB -> Int -> IO ()
backToCustomerInteraction db currentCustomerId = do
  waitThreeSeconds
  clear
  customerInteraction db currentCustomerId

customerViewCandyMenu :: DB -> Int -> IO ()
customerViewCandyMenu db currentCustomerId = do
  let purchases = (DB.purchases db)
  
  let hasPurchase = customerHasPurchase currentCustomerId purchases
  if hasPurchase then do
    putStr $ getPurchasesByCustomer currentCustomerId purchases
    backToCustomerInteraction db currentCustomerId
  else do
    putStr "Você ainda não tem compras realizadas.\n"
    waitTwoSeconds
    backToCustomerInteraction db currentCustomerId


employeeInteraction :: DB -> Int -> IO()
employeeInteraction db employeeId = do
  let employees = DB.employees db 

  if not $ existsEntity employees employeeId then do
    putStr "Funcionário inexistente...\n"
    waitTwoSeconds
    clear
    start db
  else do
    clear
    putStr employeeOptions

    option <- input "Número: "
    let num = read option

    if num == 1 then do
     registerCustomer db employeeId
    else if num == 2 then do
      putStr "Branco"
    else if num == 3 then do
      displayEntity (DB.customers db) "clientes"
      employeeInteraction db employeeId
    else if num == 4 then do
     putStr ""
    else if num == 5 then do
     start db
    else do
      employeeInteraction db employeeId


registerCustomer :: DB -> Int -> IO ()
registerCustomer db employeeId = do
  let customers = DB.customers db

  let customerId = (DB.currentIdCustomer db) + 1

  ssn <- input "CPF: "
  name <- input "Nome: "
  age <- input "Idade: "
  address <- input "Endereço: "

  if existsPerson customers ssn then do
    putStr "Cliente já cadastrado.\n"
    waitTwoSeconds
    employeeInteraction db employeeId
  else do
    let customer = (Customer customerId ssn name (read age) address)

    DB.entityToFile customer "cliente.txt" "custId.txt"
    let newDB = db {DB.customers = customers ++ [customer], DB.currentIdCustomer = customerId}

    clear
    putStr "Cliente cadastrado com sucesso!"
    putStr $ show customer
    waitThreeSeconds
  
    employeeInteraction newDB employeeId