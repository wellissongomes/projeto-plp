module Cardapio where
import Doce
import Bebida

import Data.List.Split

data Cardapio = Cardapio {
  doces :: [Doce],
  bebidas :: [Bebida]
}

showLista :: (Show a) => [a] -> String
showLista [] = ""
showLista (x:xs) = (show x) ++ showLista xs

instance Show Cardapio where
  show (Cardapio doces bebidas) = "Doces" ++ "\n" ++
                                  (showLista doces) ++
                                  "Bebidas" ++  "\n" ++
                                  (showLista bebidas)