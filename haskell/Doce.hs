module Doce where 
import TypeClasses

import Data.List.Split

-- import Prelude hiding (id)

-- type LandyId = Int
-- type Name = String
-- type Description = String
-- type Price = Float

data Doce = Doce {
  id :: Int,
  nome :: String,
  descricao :: String,
  preco :: Float
}

instance Show Doce where
  show (Doce _ nome descricao preco) = "\n-----------------------\n" ++
                                       "Nome: " ++ nome ++ "\n" ++
                                       "Descrição: " ++ descricao ++ "\n" ++ 
                                       "Preço: " ++ (show preco) ++
                                       "\n-----------------------\n"

instance Stringify Doce where
  toString (Doce id nome descricao preco) = show id ++ "," ++
                                            nome ++ "," ++
                                            descricao ++ "," ++
                                            show preco

instance Read Doce where
  readsPrec _ str = do
  let l = splitOn "," str
  let id = read (l !! 0) :: Int
  let nome = read (l !! 1) :: String
  let descricao = read (l !! 2) :: String
  let preco = read (l !! 3) :: Float
  [(Doce id nome descricao preco, "")]