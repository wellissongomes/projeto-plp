module EmployeeController (
  existsEmployee,
  hasPermission
) where

import Prelude hiding (id)

import Employee

existsEmployee :: Int -> [Employee] -> Bool
existsEmployee id employees = not $ null [e | e <- employees, (Employee.id e) == id]

hasPermission :: Int -> [Employee] -> Bool
hasPermission id employees = not $ null [e | e <- employees, (Employee.id e) == id, (Employee.role e) == "vendedor"]