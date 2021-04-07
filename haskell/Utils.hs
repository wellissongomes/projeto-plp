module Utils where

import Candy 
import Drink

import Data.List.Split
import TypeClasses

listOfAnythingToListOfToString :: (Stringfy a) => [a] -> [String]
listOfAnythingToListOfToString [] = []
listOfAnythingToListOfToString (x:xs) = toString x : listOfAnythingToListOfToString xs

listOfAnythingToString :: (Stringfy a) => [a] -> String
listOfAnythingToString [] = ""
listOfAnythingToString (x:xs) = (toString x) ++ "\n" ++ (listOfAnythingToString xs)

splitForFile :: String -> [String]
splitForFile str = init $ splitOn "\n" str

showList' :: (Show a) => [a] -> String
showList' [] = ""
showList' (x:xs) = (show x) ++ showList' xs

-- just to avoid circular import
listOfStringToListOfCandy l = map read l :: [Candy]
listOfStringToListOfDrink l = map read l :: [Drink]
stringToListOfString str = read str :: [String]

stringToListOfCandies str = listOfStringToListOfCandy $ stringToListOfString str
stringToListOfDrinks str = listOfStringToListOfDrink $ stringToListOfString str