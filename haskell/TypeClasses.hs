module TypeClasses where

class Stringify a where
  toString :: a -> String