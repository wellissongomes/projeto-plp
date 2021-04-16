module EmployeeController (
  hasPermission
) where

import Prelude hiding (id)

import Employee

hasPermission :: Int -> [Employee] -> String -> Bool
hasPermission id employees role = not $ null [e | e <- employees, (Employee.id e) == id, (Employee.role e) == role]