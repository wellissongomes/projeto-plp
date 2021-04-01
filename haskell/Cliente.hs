module Cliente where

import TypeClasses

import Data.List.Split

-- import Prelude hiding (id)

-- type CustomerId = Int
-- type Ssn = String
-- type Name = String
-- type Age = Int
-- type Address = String

data Cliente = Cliente {
  id :: Int,
  cpf :: String,
  nome :: String,
  idade :: Int,
  endereco :: String
}

instance Show Cliente where
  show (Cliente id cpf nome idade endereco) = "\n-----------------------\n" ++
                                              "ID: " ++ (show id) ++ "\n" ++
                                              "CPF: " ++ cpf ++ "\n" ++
                                              "Nome: " ++ nome ++ "\n" ++
                                              "Idade: " ++ (show idade) ++ "\n" ++
                                              "Endereço: " ++ endereco ++
                                              "\n-----------------------\n"

instance Stringify Cliente where
  toString (Cliente id cpf nome idade endereco) = show id ++ "," ++
                                                  cpf ++ "," ++
                                                  nome ++ "," ++
                                                  show idade ++ "," ++
                                                  endereco

instance Read Cliente where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: Int
  let cpf = read (l !! 1) :: String
  let nome = read (l !! 2) :: String
  let idade = read (l !! 3) :: Int
  let endereco = read (l !! 4) :: String
  [(Cliente id cpf nome idade endereco, "")]