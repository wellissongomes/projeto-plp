module Compra where

import Doce
import TypeClasses
import Utils

import Data.List.Split

-- type PurchaseId = Int
-- type EmployeeId = Int
-- type CustomerId = Int

data Compra = Compra {
  id :: Int,
  idFuncionario :: Int,
  idCliente :: Int,
  doces :: [Doce]
}
                                  
instance Show Compra where
  show (Compra id idFuncionario idCliente doces) = "\n" ++
                                                    "ID da compra: " ++ (show id) ++ "\n" ++
                                                    "ID do funcionario: " ++ (show idFuncionario) ++ "\n" ++
                                                    "ID do cliente: " ++ show idCliente ++ "\n" ++
                                                    "\nDoces: " ++ show doces
          
instance Stringfy Compra where
  toString (Compra id idFuncionario idCliente doces) = show id ++ "," ++
                                                       show idFuncionario ++ "," ++
                                                       show idCliente ++ "," ++
                                                       show (listOfAnythingToListOfToString doces)


instance Read Compra where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: Int
  let idFuncionario = read (l !! 1) :: Int
  let idCliente = read (l !! 2) :: Int
  let doces = read (l !! 3) :: [Doce]
  [(Compra id idFuncionario idCliente doces, "")]