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

  -- DB.addToFile "./db/compra.txt" compra
  -- dados <- DB.connect

  DB.addToFile "compra.txt" compra

  -- print $ DB.purchases dados

  content <- DB.readFile' "compra.txt"
  
  let purchases = listOfStringToListOfPurchases $ splitForFile content
  print purchases
  