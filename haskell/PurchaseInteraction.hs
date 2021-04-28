module PurchaseInteraction where

import DB
import Purchase
import Order
import Drink
import Candy
import Utils
import PurchaseController
import EmployeeController

getIds :: Int -> Int -> IO [Int]
getIds customerId employeeId =
  if customerId == -1 then do
    currentCustomerId <- input "ID do cliente: "
    return [read currentCustomerId, employeeId]
  else do
    currentEmployeeId <- input "ID do funcionário: "
    return [customerId, read currentEmployeeId]

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

backToCustomerOrEmployeeInteraction :: DB -> Interaction -> Interaction -> Int -> Int -> IO()
backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId =
  if customerId == (-1) then do
    employeeInteraction db employeeId
  else
    customerInteraction db customerId

purchaseReview :: DB -> (DB -> Int -> IO ()) -> Int -> IO ()
purchaseReview db customerInteraction customerId = do
  let purchases = DB.purchases db

  if not $ customerHasPurchase customerId purchases then do
    putStr "Você ainda não realizou nenhuma compra.\n"
    waitTwoSeconds
    clear
    customerInteraction db customerId
  else do
    purchaseId <- input "Digite o id da compra: "
    if not $ existsEntity purchases (read purchaseId) then do
      putStr "Você não possui uma compra com esse id...\n"
      waitTwoSeconds
      clear
      purchaseReview db customerInteraction customerId
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

          let order = Purchase.order currentPurchase

          let drinks = Order.drinks order
          let drinksId = [Drink.id drink | (_, drink) <- drinks]
          let drinksTupleWithNewScore = map (\(id, drink) -> (id, drink {Drink.scoreDrink = ((Drink.scoreDrink drink) + score) `div` 2 })) drinks
          newDrinks <- getNewItems (DB.drinks db) drinksId drinksTupleWithNewScore

          let candies = Order.candies order
          let candiesId = [Candy.id candy | (_, candy) <- candies]
          let candiesTupleWithNewScore = map (\(id, candy) -> (id, candy {Candy.scoreCandy = ((Candy.scoreCandy candy) + score) `div` 2 })) candies
          newCandies <- getNewItems (DB.candies db) candiesId candiesTupleWithNewScore

          let newOrder = Order drinksTupleWithNewScore candiesTupleWithNewScore
          
          let newPurchase = currentPurchase {Purchase.score = score, Purchase.hasBeenReviewed = True, Purchase.order = newOrder}
          let newPurchaseList = newPurchases ++ [newPurchase]

          DB.writeToFile "doce.txt" newCandies
          DB.writeToFile "bebida.txt" newDrinks

          DB.writeToFile "compra.txt" newPurchaseList
          let newDB = db {DB.purchases = newPurchaseList, DB.candies = newCandies, DB.drinks = newDrinks}

          print newPurchase
          waitFiveSeconds
          customerInteraction newDB customerId

finishPurchase :: DB -> Interaction -> Interaction -> Int -> Int -> IO ()
finishPurchase db employeeInteraction customerInteraction customerId employeeId = do

  [currentIdCustomer, currentIdEmployee] <-  getIds customerId employeeId

  let employees = DB.employees db
  let customers = DB.customers db

  if not $ existsEntity customers currentIdCustomer then do
    putStr "Cliente não cadastrado.\n"
    op <- input "Deseja volta para seu menu? [S - SIM ou qualquer letra para NÃO]: "
    if head op `elem` "Ss" then 
      backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId
    else do
      finishPurchase db employeeInteraction customerInteraction (-1) employeeId
  else do 
    if not $ existsEntity employees currentIdEmployee then do
      putStr "Funcionário não cadastrado.\n"
      op <- input "Deseja volta para seu menu? [S - SIM ou qualquer letra para NÃO]: "
      if head op `elem` "Ss" then 
        backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId
      else do
        finishPurchase db employeeInteraction customerInteraction customerId (-1)
    else if not $ hasPermission currentIdEmployee employees "vendedor" then do
      putStr "Funcionário tem que ser um vendedor.\n"
      waitTwoSeconds
      finishPurchase db employeeInteraction customerInteraction customerId (-1)
    else do
      clear
      if null $ DB.candies db then do
        putStr "Não há doces disponíveis.\n"
        waitTwoSeconds
        backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId
      else if null $ DB.drinks db then do
        putStr "Não há bebidas disponíveis.\n"
        waitTwoSeconds
        backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId
      else do
        let candyIds = []
        candyTuple <- _chooseCandy db candyIds
        candies <- _makeOrderCandy [candyTuple] db

        if fst (candyTuple) <= 0 then do
          putStr "A quantidade de doces não pode ser menor ou igual a 0.\n"
          waitTwoSeconds
          backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId 
        else do
          let drinkIds = []
          drinkTuple <- _chooseDrink db drinkIds
          drinks <- _makeOrderDrink [drinkTuple] db
        
          if fst (drinkTuple) <= 0 then do
            putStr "A quantidade de bebidas não pode ser menor ou igual a 0.\n"
            waitTwoSeconds
            backToCustomerOrEmployeeInteraction db employeeInteraction customerInteraction customerId employeeId 
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
            backToCustomerOrEmployeeInteraction newDB employeeInteraction customerInteraction customerId employeeId