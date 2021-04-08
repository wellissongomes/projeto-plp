module Utils where

import Candy 
import Drink

import Data.List.Split
import Data.Char(digitToInt)

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

listOfStringToString [] = ""
listOfStringToString (x:xs) = x ++ "," ++ listOfStringToString xs

stringWithoutLastComma str = init str 

getQuantityItem str = digitToInt $ head str
stringToDrink str = read (drop 3 str) :: Drink
stringToCandy str = read (drop 3 str) :: Candy

stringToTupleOfDrinks str = (getQuantityItem str, stringToDrink str)
stringToTupleOfCandies str = (getQuantityItem str, stringToCandy str)

listOfTupleToListOfString :: (Show a, Stringfy b) => [(a, b)] -> [String]
listOfTupleToListOfString [] = []
listOfTupleToListOfString ((qtd, item):xs) = (show qtd ++ "," ++ toString item):(listOfTupleToListOfString xs)

showListOfItems :: (Show a, Show b) => [(a, b)] -> String
showListOfItems [] = ""
showListOfItems ((qtd, item):xs) = ("Quantidade: " ++ show qtd ++ " \n" ++ show item ++ "\n") ++ showListOfItems xs