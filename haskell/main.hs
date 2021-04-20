import PurchaseInteraction
import CustomerInteraction
import OwnerInteraction
import EmployeeInteraction
import Chat
import DB
import Utils
import PurchaseController
import EmployeeController
import CandyMenu
import System.Exit

import Prelude hiding (id)

main = do
  dados <- DB.connect
  start dados

start :: DB -> IO()
start db = do
  clear 
  putStr slogan
  putStr options

  option <- input "Número: "

  let number = read option

  if number == 1 then do
    clear
    oId <- input "Digite o seu ID: "
    ownerInteraction db (read oId)
  else if number == 2 then do
    clear
    fId <- input "Digite o seu ID: "
    clear
    employeeInteraction db (read fId) 
  else if number == 3 then do
    clear
    cId <- input "Digite o seu ID: "
    clear
    customerInteraction db (read cId)
  else if number == 4 then do
    die "\nAdeus!\n"
  else
    start db

ownerInteraction :: DB -> Int -> IO ()
ownerInteraction db ownerId = do
  clear
  let employees = DB.employees db
  if not $ existsOwner employees then do
    putStr "Dono não cadastrado.\n"
    op <- input "\nGostaria de cadastrar um dono? [S - SIM ou qualquer letra para NÃO]: "
    if head op `elem` "Ss" then do
      registerOwner db start
    else do
      start db
  else do
    if not $ hasPermission ownerId employees "dono" then do
      putStr "O ID informado não pertence a um Dono.\n"
      waitThreeSeconds
      start db
    else do
      clear
      putStr ownerOptions

      option <- input "Número: "

      let number = read option

      if number == 1 then do
        registerEmployee db ownerInteraction ownerId
      else if number == 2 then do
        registerCandy db ownerInteraction ownerId
      else if number == 3 then do
        registerDrink db ownerInteraction ownerId
      else if number == 4 then do
        removeCandy db ownerInteraction ownerId
      else if number == 5 then do
        removeDrink db ownerInteraction ownerId
      else if number == 6 then do
        displayEntity (DB.employees db) "funcionários"
        ownerInteraction db ownerId
      else if number == 7 then do
        displayEntity (DB.candies db) "doces"
        ownerInteraction db ownerId
      else if number == 8 then do
        displayEntity (DB.drinks db) "bebidas"
        ownerInteraction db ownerId
      else if number == 9 then do
        displayEntity (DB.purchases db) "vendas"
        ownerInteraction db ownerId
      else if number == 10 then do
        start db
      else do
        ownerInteraction db ownerId

customerInteraction :: DB -> Int -> IO ()
customerInteraction db customerId = do
  let customers = DB.customers db

  if not $ existsEntity customers customerId then do
    putStr "Não há um cliente com esse id.\n"
    waitTwoSeconds
    clear
    start db
  else do
    clear
    putStr customerOptions

    option <- input "Número: "
    let num = read option

    if num == 1 then do
      clear
      putStr $ showCandyMenuFiltered (DB.candies db) (DB.drinks db)
      waitFiveSeconds
      clear
      customerInteraction db customerId
    else if num == 2 then do
      clear
      putStr $ showCandyMenu (DB.candies db) (DB.drinks db)
      waitFiveSeconds
      clear
      customerInteraction db customerId
    else if num == 3 then do
      clear
      finishPurchase db employeeInteraction customerInteraction customerId (-1)
    else if num == 4 then do
      clear
      customerViewCandyMenu db customerInteraction customerId
    else if num == 5 then do
      clear
      purchaseReview db customerInteraction customerId
    else if num == 6 then do
      start db
    else do
      customerInteraction db customerId

employeeInteraction :: DB -> Int -> IO()
employeeInteraction db employeeId = do
  let employees = DB.employees db 

  if not $ existsEntity employees employeeId then do
    putStr "Funcionário inexistente...\n"
    waitTwoSeconds
    clear
    start db
  else if not $ hasPermission employeeId employees "vendedor" then do
    putStr "O ID informado não pertence a um vendedor.\n"
    waitTwoSeconds
    clear
    start db
  else do
    clear
    putStr employeeOptions

    option <- input "Número: "
    let num = read option

    if num == 1 then do
     registerCustomer db employeeInteraction employeeId
    else if num == 2 then do
      clear
      finishPurchase db employeeInteraction customerInteraction (-1) employeeId
    else if num == 3 then do
      displayEntity (DB.customers db) "clientes"
      employeeInteraction db employeeId
    else if num == 4 then do
      putStr $ getPurchasesByEmployee employeeId (DB.purchases db)
      waitThreeSeconds
      employeeInteraction db employeeId
    else if num == 5 then do
      start db
    else do
      employeeInteraction db employeeId
