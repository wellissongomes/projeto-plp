module EmployeeController (
  hasPermission
) where

import Prelude hiding (id)

import Employee

hasPermission :: Int -> [Employee] -> Bool
hasPermission id employees = not $ null [e | e <- employees, (Employee.id e) == id, (Employee.role e) == "vendedor"]