module Compra where

import Doce

type ID = Int

data Compra = Compra {
  id :: ID,
  idFuncionario :: ID,
  idCliente :: ID
  doces :: [Doce]
}