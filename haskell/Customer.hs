module Customer where

import TypeClasses

import Data.List.Split

type CustomerID = Int
type Ssn = String
type Name = String
type Age = Int
type Address = String

data Customer = Customer {
  id :: CustomerID,
  ssn :: Ssn,
  name :: Name,
  age :: Age,
  address :: Address
}

instance Show Customer where
  show (Customer id ssn name age address) = "\n-----------------------\n" ++
                                              "ID: " ++ (show id) ++ "\n" ++
                                              "CPF: " ++ ssn ++ "\n" ++
                                              "Nome: " ++ name ++ "\n" ++
                                              "Idade: " ++ (show age) ++ "\n" ++
                                              "Endereço: " ++ address ++
                                              "\n-----------------------\n"

instance Stringfy Customer where
  toString (Customer id ssn name age address) = show id ++ "," ++
                                                  ssn ++ "," ++
                                                  name ++ "," ++
                                                  show age ++ "," ++
                                                  address

instance Read Customer where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: CustomerID
  let ssn = l !! 1
  let name = l !! 2
  let age = read (l !! 3) :: Age
  let address = l !! 4
  [(Customer id ssn name age address, "")]