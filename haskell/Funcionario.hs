module Funcionario where

type ID = Int
type Name = String
type Age = Int
type Role = String

data Funcionario = Funcionario {
  id :: ID,
  nome :: Name,
  idade :: Age,
  funcao :: Role
} 

instance Show Funcionario where
  show (Funcionario id nome idade funcao) = "\n-----------------------\n" ++
                                            "Nome: " ++ nome ++ "\n" ++
                                            "Função: " ++ funcao ++ "\n" ++
                                            "Idade: " ++ (show idade) ++
                                            "\n-----------------------\n"