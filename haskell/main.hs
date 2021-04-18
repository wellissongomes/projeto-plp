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
import System.Exit

import Prelude hiding (id)

import Data.List.Split 

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
      registerOwner db
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
        registerEmployee db ownerId
      else if number == 2 then do
        registerCandy db ownerId
      else if number == 3 then do
        registerDrink db ownerId
      else if number == 4 then do
        removeCandy db ownerId
      else if number == 5 then do
        removeDrink db ownerId
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

registerCandy :: DB -> Int -> IO ()
registerCandy db  ownerId = do
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

  ownerInteraction newDB ownerId

removeCandy :: DB -> Int -> IO ()
removeCandy db ownerId = do
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

removeDrink :: DB -> Int -> IO ()
removeDrink db ownerId = do
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

registerOwner :: DB -> IO ()
registerOwner db = do
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
     

registerEmployee :: DB -> Int -> IO ()
registerEmployee db ownerId = do
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

registerDrink :: DB -> Int -> IO()
registerDrink db ownerId = do
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

  ownerInteraction newDB ownerId

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

    if num == 2 then do
      clear
      putStr $ showCandyMenu (DB.candies db) (DB.drinks db)
      waitFiveSeconds
      clear
      customerInteraction db customerId
    else if num == 3 then do
      clear
      finishPurchase db customerId (-1)
    else if num == 4 then do
      clear
      customerViewCandyMenu db customerId
    else if num == 5 then do
      clear
      purchaseReview db customerId
    else if num == 6 then do
      start db
    else do
      customerInteraction db customerId

purchaseReview :: DB -> Int -> IO ()
purchaseReview db customerId = do
  let purchases = DB.purchases db

  if not $ customerHasPurchase customerId purchases then do
    putStr "tem n"
  else do
    purchaseId <- input "Digite o id da compra: "
    if not $ existsEntity purchases (read purchaseId) then do
      putStr "Você não possui uma compra com esse id...\n"
      waitTwoSeconds
      clear
      purchaseReview db customerId
    else do
      let newPurchases = removePurchase (read purchaseId) purchases
      let currentPurchase = getEntityById purchases (read purchaseId)

      if Purchase.hasBeenReviewed currentPurchase then do
        putStr "Você já avaliou essa compra.\n"
        waitTwoSeconds
        customerInteraction db customerId
      else do
        sOption <- input "Digite a avalição (VALOR INTEIRO ENTRE 0 E 5): "
        let score = read sOption :: Int
        let invalidScore = (score < 0) || (score > 5)
        if invalidScore then do
          putStr "Avaliação inválida.\n"
          waitTwoSeconds
          customerInteraction db customerId
        else do
          let newPurchase = currentPurchase {Purchase.score = score, Purchase.hasBeenReviewed = True}
          let newPurchaseList = newPurchases ++ [newPurchase]
          
          DB.writeToFile "compra.txt" newPurchaseList
          let newDB = db {DB.purchases = newPurchaseList}

          print newPurchase
          waitFiveSeconds
          customerInteraction newDB customerId

_chooseCandy :: DB -> [Int] -> IO (Int, Candy)
_chooseCandy db candyIds = do
  clear
  candyId <- input "ID do doce: "

  if (read candyId) `elem` candyIds then do
    _chooseCandy db candyIds
  else if not $ existsEntity (DB.candies db) (read candyId) then do
    putStr "O id do doce informado não existe.\n"
    waitTwoSeconds
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
    op <- input "Deseja outro doce? [S - SIM ou qualquer letra para NÃO]: "

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
    putStr "O id da bebida informada não existe.\n"
    waitTwoSeconds
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
    op <- input "Deseja outra bebida? [S - SIM ou qualquer letra para NÃO]: "

    if head op `elem` "Ss" then do
      drinkTuple <- _chooseDrink db drinkIds
      _makeOrderDrink (drinkTuple:drinks) db
    else do
      return drinks


getIds :: Int -> Int -> IO [Int]
getIds customerId employeeId =
  if customerId == -1 then do
    currentCustomerId <- input "ID do cliente: "
    return [read currentCustomerId, employeeId]
  else do
    currentEmployeeId <- input "ID do funcionário: "
    return [customerId, read currentEmployeeId]

backToCustomerOrEmployeeInteraction :: DB -> Int -> Int -> IO()
backToCustomerOrEmployeeInteraction db customerId employeeId =
  if customerId == (-1) then do
    employeeInteraction db employeeId
  else
    customerInteraction db customerId


finishPurchase :: DB -> Int -> Int -> IO ()
finishPurchase db customerId employeeId = do

  [currentIdCustomer, currentIdEmployee] <-  getIds customerId employeeId

  let employees = DB.employees db
  let customers = DB.customers db

  if not $ existsEntity customers currentIdCustomer then do
    putStr "Cliente não cadastrado.\n"
    op <- input "Deseja volta para seu menu? [S - SIM ou qualquer letra para NÃO]: "
    if head op `elem` "Ss" then 
      backToCustomerOrEmployeeInteraction db customerId employeeId
    else do
      finishPurchase db (-1) employeeId
  else do 
    if not $ existsEntity employees currentIdEmployee then do
      putStr "Funcionário não cadastrado.\n"
      op <- input "Deseja volta para seu menu? [S - SIM ou qualquer letra para NÃO]: "
      if head op `elem` "Ss" then 
        backToCustomerOrEmployeeInteraction db customerId employeeId
      else do
        finishPurchase db customerId (-1)
    else if not $ hasPermission currentIdEmployee employees "vendedor" then do
      putStr "Funcionário tem que ser um vendedor.\n"
      waitTwoSeconds
      finishPurchase db customerId (-1)
    else do
      clear
      if null $ DB.candies db then do
        putStr "Não há doces disponíveis.\n"
        waitTwoSeconds
        backToCustomerOrEmployeeInteraction db customerId employeeId
      else if null $ DB.drinks db then do
        putStr "Não há bebidas disponíveis.\n"
        waitTwoSeconds
        backToCustomerOrEmployeeInteraction db customerId employeeId
      else do
        let candyIds = []
        candyTuple <- _chooseCandy db candyIds
        candies <- _makeOrderCandy [candyTuple] db

        if fst (candyTuple) == 0 then do
          putStr "A quantidade do doce não pode ser igual a 0.\n"
          waitTwoSeconds
          backToCustomerOrEmployeeInteraction db customerId employeeId 
        else do
          let drinkIds = []
          drinkTuple <- _chooseDrink db drinkIds
          drinks <- _makeOrderDrink [drinkTuple] db
        
          if fst (drinkTuple) == 0 then do
            putStr "A quantidade da bebida não pode ser igual a 0.\n"
            waitTwoSeconds
            backToCustomerOrEmployeeInteraction db customerId employeeId 
          else do 
            let purchaseId = (DB.currentIdPurchase db) + 1
            let score = 5 
            let order = Order drinks candies
            let price = calculatePrice order
            let hasBeenReviewed = False
            let purchase = Purchase purchaseId currentIdEmployee currentIdCustomer score order price hasBeenReviewed

            putStr $ show purchase

            DB.entityToFile purchase "compra.txt" "purchaseId.txt"
            let newDB = db {DB.purchases = (DB.purchases db) ++ [purchase], DB.currentIdPurchase = purchaseId}

            waitFiveSeconds
            clear
            backToCustomerOrEmployeeInteraction newDB customerId employeeId

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
    backToCustomerInteraction db currentCustomerId


employeeInteraction :: DB -> Int -> IO()
employeeInteraction db employeeId = do
  let employees = DB.employees db 

  if not $ existsEntity employees employeeId then do
    putStr "Funcionário inexistente...\n"
    waitTwoSeconds
    clear
    start db
  else if not $ (hasPermission employeeId employees "vendedor") || (hasPermission employeeId employees "confeiteiro") then do
    putStr "O ID informado não pertence a um vendedor ou confeiteiro.\n"
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
      clear
      finishPurchase db (-1) employeeId
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


registerCustomer :: DB -> Int -> IO ()
registerCustomer db employeeId = do
  let customers = DB.customers db

  let customerId = (DB.currentIdCustomer db) + 1

  ssn <- input "CPF: "
  if existsPerson customers ssn then do
    putStr "CPF já cadastrado.\n"
    registerCustomer db employeeId
  else do
    name <- input "Nome: "
    age <- input "Idade: "
    address <- input "Endereço: "

    let customer = (Customer customerId ssn name (read age) address)

    DB.entityToFile customer "cliente.txt" "custId.txt"
    let newDB = db {DB.customers = customers ++ [customer], DB.currentIdCustomer = customerId}

    clear
    putStr "Cliente cadastrado com sucesso!"
    putStr $ show customer
    waitThreeSeconds
  
    employeeInteraction newDB employeeId