module Utils where

import Data.List.Split
import TypeClasses

listOfAnythingToListOfToString :: (Stringfy a) => [a] -> [String]
listOfAnythingToListOfToString [] = []
listOfAnythingToListOfToString (x:xs) = toString x : listOfAnythingToListOfToString xs

splitForFile :: String -> [String]
splitForFile str = init $ splitOn "\n" str