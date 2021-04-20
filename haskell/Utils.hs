module Utils where

import Candy
import Drink

import System.IO ( hFlush, stdout )
import System.Process

import Data.List.Split
import Data.Char(digitToInt)
import Control.Concurrent

import TypeClasses

oneSecond :: Int
oneSecond = 1000000

waitOneSecond = threadDelay oneSecond
waitTwoSeconds = threadDelay $ 2 * oneSecond
waitThreeSeconds = threadDelay $ 3 * oneSecond
waitFiveSeconds = threadDelay $ 5 * oneSecond

continue = do
  _ <- input "\nDigite algo para continuar: "
  return ()

getNewItems :: (Item e, Entity e) => [e] -> [Int] -> [(Int, e)] -> IO [e]
getNewItems allItems itemsId itemTupleWithNewScore = do
  let currentItems = [i | i <- allItems, not $ (entityId i) `elem` itemsId]
  let newItems = currentItems ++ [i | (_, i) <- itemTupleWithNewScore]
  return newItems

displayEntity :: Show a => [a] -> String -> IO ()
displayEntity entities msg = do
  if not $ null entities then do
    putStr $ showList' entities
  else do
    putStr $ "Não há " ++ msg ++ " presentes no sistema.\n"

getEntityById :: Entity e => [e] -> Int -> e
getEntityById entities id = head [e | e <- entities, entityId e == id]

existsEntity :: Entity e => [e] -> Int -> Bool
existsEntity entities id = not $ null [e | e <- entities, entityId e == id]

existsEntityWithMsg :: Entity e => [e] -> String -> IO() -> IO ()
existsEntityWithMsg entities msg function = do
  if null entities then do
    putStr $ msg ++ "\n"
    waitTwoSeconds
    function
  else
    return ()

existsPerson :: Person a => [a] -> String -> Bool
existsPerson people ssn = not $ null [p | p <- people, personSSN p == ssn]

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

findElem' [] _ _ = -1
findElem' (x:xs) elem index
  | x == elem = index
  | otherwise = findElem' xs elem (index + 1)

findFirstOcurr str elem = findElem' str elem 0

getQuantityItem str = read (take ((findFirstOcurr str ',')) str) :: Int
stringToDrink str = read (drop ((findFirstOcurr str ',') + 1) str) :: Drink
stringToCandy str = read (drop ((findFirstOcurr str ',') + 1) str) :: Candy

stringToTupleOfDrinks str = (getQuantityItem str, stringToDrink str)
stringToTupleOfCandies str = (getQuantityItem str, stringToCandy str)

listOfTupleToListOfString :: (Show a, Stringfy b) => [(a, b)] -> [String]
listOfTupleToListOfString [] = []
listOfTupleToListOfString ((qtd, item):xs) = (show qtd ++ "," ++ toString item):(listOfTupleToListOfString xs)

showListOfItems :: (Show a, Show b) => [(a, b)] -> String
showListOfItems [] = ""
showListOfItems ((qtd, item):xs) = ("Quantidade: " ++ show qtd ++ " \n" ++ show item ++ "\n") ++ showListOfItems xs

clear = do
    _ <- system "clear"
    return ()

input :: String -> IO String
input text = do
    putStr text
    hFlush stdout
    getLine
