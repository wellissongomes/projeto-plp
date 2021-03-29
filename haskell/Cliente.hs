module Cliente where

type ID = Int
type Name = String
type Address = String

data Cliente = Cliente {
  id :: ID,
  nome :: Name
  endereco :: Address
}