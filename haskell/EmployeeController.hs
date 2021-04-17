module EmployeeController (
  hasPermission,
  existsOwner
) where

import Prelude hiding (id)

import Employee

hasPermission :: Int -> [Employee] -> String -> Bool
hasPermission id employees role = not $ null [e | e <- employees, (Employee.id e) == id, (Employee.role e) == role]

existsOwner :: [Employee] -> Bool
existsOwner employees =  not $ null [e | e <- employees, (Employee.role e) == "dono"]