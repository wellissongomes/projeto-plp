module Funcionario where

import TypeClasses

import Data.List.Split

-- import Prelude hiding (id)


-- type EmployeeId = Int
-- type Ssn = String
-- type Name = String
-- type Age = Int
-- type Role = String

data Funcionario = Funcionario {
  id :: Int,
  cpf :: String,
  nome :: String,
  idade :: Int,
  funcao :: String
} 

instance Show Funcionario where
  show (Funcionario id cpf nome idade funcao) = "\n-----------------------\n" ++
                                                "ID: " ++ (show id) ++ "\n" ++
                                                "CPF: " ++ cpf ++ "\n" ++
                                                "Nome: " ++ nome ++ "\n" ++
                                                "Função: " ++ funcao ++ "\n" ++
                                                "Idade: " ++ (show idade) ++
                                                "\n-----------------------\n"

instance Stringfy Funcionario where
  toString (Funcionario id cpf nome idade funcao) = show id ++ "," ++
                                                    cpf ++ "," ++
                                                    nome ++ "," ++
                                                    show idade ++ "," ++
                                                    funcao

instance Read Funcionario where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: Int
  let cpf = read (l !! 1) :: String
  let nome = read (l !! 2) :: String
  let idade = read (l !! 3) :: Int
  let funcao = read (l !! 4) :: String
  [(Funcionario id cpf nome idade funcao, "")]