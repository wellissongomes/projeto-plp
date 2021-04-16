import Chat
import Employee
import Candy
import Customer
import Purchase
import TypeClasses
import CandyMenu
import Drink
import Order
import Utils
import DB
import CandyMenuController
import EmployeeController
import PurchaseController
import CustomerController

import Control.Concurrent

import Prelude hiding (id)

import Data.List.Split 

oneSecond :: Int
oneSecond = 1000000

waitTwoSecond = threadDelay $ 2 * oneSecond
waitThreeSeconds = threadDelay $ 3 * oneSecond
waitFiveSeconds = threadDelay $ 5 * oneSecond

main = do
  let f1 = Employee 1 "10120379940" "Wellisson Gomes" 20 "vendedor"
  let d1 = Candy 1 "Sorvete de chocolate" "Sorvete de chocolate e calda morango" 15.96
  let d2 = Candy 2 "Sorvete de test" "Sorvete de test e calda morango" 15.26
  let c1 = Customer 1 "10120379940" "Gomes Gomes" 20 "rua tal"
  let refri = Drink 1 "Suco de graviola" "Feito por extraterrestres" 10.9
  let cardapio = CandyMenu [d1, d1] [refri]
  let pedido = Order [(5, refri), (5, refri), (5, refri)] [(1, d1)]
  let compra = Purchase 1 1 1 5 pedido 5

  -- content <- DB.readFile' "compra.txt"

  -- print content

  DB.addToFile "funcionario.txt" f1
  DB.addToFile "cardapio.txt" cardapio
  DB.addToFile "doce.txt" d1
  DB.addToFile "doce.txt" d2
  DB.addToFile "bebida.txt" refri
  DB.addToFile "cliente.txt" c1

  -- c <- DB.readFile' "empId.txt"
  -- print c


  -- print $ DB.purchases dados

  
  -- let purchases = listOfStringToListOfPurchases $ splitForFile content
  dados <- DB.connect
  -- print dados

  -- let newId = (DB.currentIdCustomer dados) + 1
  -- let newDB = dados {DB.currentIdCustomer = newId}
  -- print $ DB.currentIdCustomer newDB
  -- DB.writeIdToFile "custId.txt" newId

  start dados

start :: DB -> IO()
start db = do
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
    putStr employeeOptions
  else do
    start db


ownerInteraction :: DB -> IO ()
ownerInteraction db = do
  let currentOwnerId = (DB.currentIdOwner db)

  clear
  if currentOwnerId == 0 then do
    putStr "Seja bem vindo ao Candy Land!!"

    let newOwnerId = currentOwnerId + 1

    DB.writeIdToFile "ownerId.txt" newOwnerId
    let newDB = db {DB.currentIdOwner = newOwnerId}

    ownerInteraction newDB
  else do
    putStr ownerOptions

    option <- input "Número: "

    let number = read option

    if number == 1 then do
      registerEmployee db
    else if number == 2 then do
      registerCandy db
    else if number == 10 then do
      start db
    else do
      putStr ""

registerCandy :: DB -> IO()
registerCandy db = do
  let candies = (DB.candies db)
  let candyId = (DB.currentIdCandy db) + 1

  name <- input "Nome do doce: "
  description <- input "Descrição: "
  price <- input "Preço: "

  let candy = (Candy candyId name description (read price))

  DB.addToFile "doce.txt" candy
  DB.writeIdToFile "candyId.txt" candyId
  let newDB = db {DB.candies = candies ++ [candy]}

  clear
  print "Doce cadastrado com sucesso!"
  print candy
  waitThreeSeconds

  ownerInteraction newDB



registerEmployee :: DB -> IO ()
registerEmployee db = do
  let employees = DB.employees db

  let employeeId = (DB.currentIdEmployee db) + 1

  ssn <- input "CPF: "
  name <- input "Nome: "
  age <- input "Idade: "
  role <- input "Cargo: "

  let employee = (Employee employeeId ssn name (read age) role)

  DB.addToFile "funcionario.txt" employee
  DB.writeIdToFile "empId.txt" employeeId
  let newDB = db {DB.employees = employees ++ [employee]}

  print employee

  ownerInteraction newDB


customerInteraction :: DB -> Int -> IO()
customerInteraction db customerId = do
  let customers = DB.customers db

  if not $ existsCustomer customerId  customers then do
    putStr "Usuário inexistente...\n"
    waitTwoSecond
    clear
    start db
  else do
    putStr customerOptions

    option <- input "Número: "
    let num = read option

    if num == 2 then do
      clear
      putStr $ showCandyMenu $ DB.candyMenu db
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
  else if not $ candyExists (read candyId) (DB.candies db) then do
    _chooseCandy db candyIds
  else do
    quantityCandy <- input "Digite a quantidade: "

    let candy = getCandyById (read candyId) (DB.candies db)

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
  else if not $ drinkExists (read drinkId) (DB.drinks db) then do
    _chooseDrink db drinkIds
  else do
    quantityDrink <- input "Digite a quantidade: "

    let candy = getDrinkById (read drinkId) (DB.drinks db)

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

  if not $ existsEmployee (read employeeId) employees then do
    putStr "Funcionário não cadastrado.\n"
    customerPurchase db currentCustomerId
  else if not $ hasPermission (read employeeId) employees then do
    putStr "Funcionário tem que ser um vendedor.\n"
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

    print purchase

    DB.addToFile "compra.txt" purchase
    DB.writeIdToFile "purchaseId.txt" purchaseId
    let newDB = db {DB.purchases = (DB.purchases db) ++ [purchase], DB.currentIdPurchase = purchaseId}

    waitFiveSeconds
    clear
    customerInteraction newDB currentCustomerId

backToCustomerInteraction :: DB -> Int -> IO ()
backToCustomerInteraction db currentCustomerId = do
  waitThreeSeconds
  clear
  customerInteraction db currentCustomerId

customerViewCandyMenu db currentCustomerId = do
  let purchases = (DB.purchases db)
  
  let hasPurchase = customerHasPurchase currentCustomerId purchases
  if hasPurchase then do
    putStr $ getPurchasesByCustomer currentCustomerId purchases
    backToCustomerInteraction db currentCustomerId
  else do
    putStr "Você ainda não tem compras realizadas.\n"
    backToCustomerInteraction db currentCustomerId

  