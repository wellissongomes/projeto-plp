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

import Data.List.Split 

main = do
  let f1 = Employee 1 "10120379940" "Wellisson Gomes" 20 "Caixa"
  let d1 = Candy 1 "Sorvete de chocolate" "Sorvete de chocolate e calda morango" 15.96
  let c1 = Customer 1 "10120379940" "Gomes Gomes" 20 "rua tal"
  let refri = Drink 1 "Suco de graviola" "Feito por extraterrestres" 10.9
  let cardapio = CandyMenu [d1, d1] [refri]
  let pedido = Order [(5, refri), (5, refri), (5, refri)] [(1, d1)]
  let compra = Purchase 1 1 1 5 pedido 5

  -- content <- DB.readFile' "compra.txt"

  -- print content

  -- DB.addToFile "cardapio.txt" cardapio
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
  putStr options

  option <- input "Número: "

  let number = read option :: Int

  if number == 1 then do
    clear
    putStr ownerOptions
  else if number == 2 then do
    clear
    customerInteraction db
  else if number == 3 then do
    clear
    putStr employeeOptions
  else do
    clear
    start db

customerInteraction :: DB -> IO()
customerInteraction db = do
  putStr customerOptions

  option <- input "Número: "
  let num = head option

  clear
  if num == '2' then
    putStr $ showCandyMenu $ DB.candyMenu db
  else 
    customerInteraction db
