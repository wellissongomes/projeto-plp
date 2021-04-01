import Funcionario
import Doce
import Cliente
import Compra
import TypeClasses
import Utils

import Data.List.Split


main = do
  let f1 = Funcionario 1 "10220579440" "Wellisson Gomes" 20 "Caixa"
  let d1 = Doce 1 "Sorvete de chocolate" "Sorvete de chocolate e calda morango" 15.96
  let c1 = Cliente 1 "10220579440" "Lucas Gomes" 20 "rua tal"
  let compra = Compra 1 1 1 [d1]
  
  let a = toString compra
  appendFile "./db/compra.txt" (a ++ "\n")

  putStr "\nCOMO A COMPRA TA NO FILE\n"
  content <- readFile "./db/compra.txt"
  putStr content
