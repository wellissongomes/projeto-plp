import Employee
import Candy
import Customer
import Purchase
import TypeClasses
import Utils
import DB

import Data.List.Split

main = do
  let f1 = Employee 1 "10220579440" "afawfawfawff Gomes" 20 "Caixa"
  let d1 = Candy 1 "Sorvete de chocolate" "Sorvete de chocolate e calda morango" 15.96
  let c1 = Customer 1 "10220579440" "Lucas Gomes" 20 "rua tal"
  let compra = Purchase 1 1 1 5 [d1, d1, d1, d1, d1, d1]
  
  -- appendFile "./db/funcionario.txt" (toString f1 ++ "\n")
  -- appendFile "./db/cliente.txt" (toString c1 ++ "\n")
  -- appendFile "./db/doce.txt" (toString d1 ++ "\n")
  -- appendFile "./db/compra.txt" (toString compra ++ "\n")

  DB.addToFile "./db/funcionario.txt" f1
  DB.addToFile "./db/cliente.txt" c1
  DB.addToFile "./db/doce.txt" d1
  DB.addToFile "./db/compra.txt" compra

  dados <- DB.connect
  print (DB.employees dados)