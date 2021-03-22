module Funcionario where

data Funcionario = Funcionario {
  id :: Int,
  nome :: String,
  idade :: Int,
  funcao :: String
} 

instance Show Funcionario where
  show (Funcionario id nome idade funcao) = "Nome: " ++ nome ++ "\n" ++
                                            "Função: " ++ funcao ++ "\n" ++
                                            "Idade: " ++ (show idade) ++ "\n"