module Bebida where
import TypeClasses

import Data.List.Split

data Bebida = Bebida {
  id :: Int,
  nome :: String,
  descricao :: String,
  preco :: Float
}

instance Show Bebida where
  show (Bebida _ nome descricao preco) = "\n-----------------------\n" ++
                                         "Nome: " ++ nome ++ "\n" ++
                                         "Descrição: " ++ descricao ++ "\n" ++
                                         "Preço: " ++ (show preco) ++ "\n" ++
                                         "\n-----------------------\n"

instance Stringfy Bebida where
  toString (Bebida id nome descricao preco) = show id ++ "," ++
                                              nome ++ "," ++
                                              descricao ++ "," ++
                                              show preco

instance Read Bebida where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: Int
  let nome = read (l !! 1) :: String
  let descricao = read (l !! 2) :: String
  let preco = read (l !! 3) :: Float
  [(Bebida id nome descricao preco, "")]