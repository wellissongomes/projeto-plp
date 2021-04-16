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
  role :: Role
} 

instance Entity Employee where
  entityId employee = Employee.id employee

instance Show Employee where
  show (Employee id ssn name age role) = "\n-----------------------\n" ++
                                                "ID: " ++ (show id) ++ "\n" ++
                                                "CPF: " ++ ssn ++ "\n" ++
                                                "Nome: " ++ name ++ "\n" ++
                                                "Função: " ++ role ++ "\n" ++
                                                "Idade: " ++ (show age) ++
                                                "\n-----------------------\n"

instance Stringfy Employee where
  toString (Employee id ssn name age role) = show id ++ "," ++
                                                    ssn ++ "," ++
                                                    name ++ "," ++
                                                    show age ++ "," ++
                                                    role

instance Read Employee where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: EmployeeID
  let ssn = l !! 1
  let name = l !! 2
  let age = read (l !! 3) :: Age
  let role = l !! 4
  [(Employee id ssn name age role, "")]