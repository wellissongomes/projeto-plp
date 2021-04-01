module Utils where

import TypeClasses

listOfAnythingToListOfToString :: (Stringify a) => [a] -> [String]
listOfAnythingToListOfToString [] = []
listOfAnythingToListOfToString (x:xs) = toString x : listOfAnythingToListOfToString xs