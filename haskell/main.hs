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

import System.IO ( hFlush, stdout )
import System.Process
import Data.List.Split 

main = do
  let f1 = Employee 1 "10120379940" "Wellisson Gomes" 20 "Caixa"
  let d1 = Candy 1 "Sorvete de chocolate" "Sorvete de chocolate e calda morango" 15.96
  let c1 = Customer 1 "10120379940" "Gomes Gomes" 20 "rua tal"
  let refri = Drink 1 "Suco de graviola" "Feito por extraterrestres" 10.9
  let cardapio = CandyMenu [d1, d1] [refri]
  let pedido = Order [d1, d1] [refri, refri]
  let compra = Purchase 1 1 1 5 pedido 5

  content <- DB.readFile' "compra.txt"
  -- print content

  -- DB.addToFile "./db/compra.txt" compra
  dados <- DB.connect

  DB.writeToFile "compra.txt" [compra, compra]

  -- print $ DB.purchases dados

  start dados

options :: String
options = "\n---------------\n" ++
          "Como você deseja logar no sistema?\n" ++
          "(1) Logar como dono\n" ++
          "(2) Logar como cliente\n" ++
          "(3) Logar como funcionário\n" ++
          "\n---------------\n"

ownerOptions :: String
ownerOptions = "\n---------------\n" ++
               "O que você deseja fazer?\n" ++
               "(1) Cadastrar funcionário\n" ++
               "(2) Cadastrar doce\n" ++
               "(3) Cadastrar bebida\n" ++
               "(4) Remover doce\n" ++
               "(5) Remover bebida\n" ++
               "(6) Listar funcionários\n" ++
               "(7) Listar doces\n" ++
               "(8) Listar bebidas\n" ++
               "(9) Listar vendas\n" ++
               "\n---------------\n"

customerOptions :: String
customerOptions = "\n---------------\n" ++
                  "O que você deseja fazer?\n" ++
                  "(1) Listar produtos bem avaliados\n" ++
                  "(2) Exibir cardápio\n" ++
                  "(3) Personalizar pedido\n" ++
                  "(4) Realizar compra\n" ++
                  "(5) Listar suas compras\n" ++
                  "(6) Avaliar suas compras\n" ++
                  "\n---------------\n"

employeeOptions :: String
employeeOptions = "\n---------------\n" ++
                  "O que você deseja fazer?\n" ++
                  "(1) Cadastrar cliente\n" ++
                  "(2) Cadastrar venda\n" ++
                  "(3) Listar clientes\n" ++
                  "(4) Listar suas vendas\n" ++
                  "\n---------------\n"

clear = do
    _ <- system "clear"
    return ()

input :: String -> IO String
input text = do
    putStr text
    hFlush stdout
    getLine

start :: DB -> IO()
start db = do
  putStr options

  option <- input "Número: "

  let number = read option :: Int

  if number == 1 then do
    putStr ownerOptions
  else if number == 2 then do
    putStr customerOptions
  else if number == 3 then do
    putStr employeeOptions
  else do
    putStr "Opção inválida!\n"

  clear
  start db
