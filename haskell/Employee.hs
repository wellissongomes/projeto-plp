module Employee where

import TypeClasses

import Data.List.Split

type EmployeeID = Int
type Ssn = String
type Name = String
type Age = Int
type Role = String

data Employee = Employee {
  id :: EmployeeID,
  ssn :: Ssn,
  name :: Name,
  age :: Age,
  funcao :: Role
} 

instance Show Employee where
  show (Employee id ssn name age funcao) = "\n-----------------------\n" ++
                                                "ID: " ++ (show id) ++ "\n" ++
                                                "CPF: " ++ ssn ++ "\n" ++
                                                "Nome: " ++ name ++ "\n" ++
                                                "Função: " ++ funcao ++ "\n" ++
                                                "Idade: " ++ (show age) ++
                                                "\n-----------------------\n"

instance Stringfy Employee where
  toString (Employee id ssn name age funcao) = show id ++ "," ++
                                                    ssn ++ "," ++
                                                    name ++ "," ++
                                                    show age ++ "," ++
                                                    funcao

instance Read Employee where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: EmployeeID
  let ssn = l !! 1
  let name = l !! 2
  let age = read (l !! 3) :: Age
  let funcao = l !! 4
  [(Employee id ssn name age funcao, "")]