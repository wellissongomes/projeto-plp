module TypeClasses where

class Stringfy a where
  toString :: a -> String

class StringToType a where
  toType :: String -> a

class Item a where
  itemPrice :: a -> Float