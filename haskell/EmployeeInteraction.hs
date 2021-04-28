module EmployeeInteraction where

import DB
import Customer
import Utils

import Employee

registerCustomer :: DB -> Interaction -> Int -> IO ()
registerCustomer db employeeInteraction employeeId = do
  let customers = DB.customers db
  let employees = DB.employees db

  let customerId = (DB.currentIdCustomer db) + 1

  ssn <- input "CPF: "
  if existsPerson customers ssn then do
    putStr "CPF já cadastrado.\n"
    registerCustomer db employeeInteraction employeeId
  else if existsPerson employees ssn then do
    let employee = getEntityById employees employeeId
    let employeeSsn = Employee.ssn employee
    let employeeName = Employee.name employee
    let employeeAge = Employee.age employee
    address <- input $ employeeName ++ ", informe seu endereço: "

    let customer = (Customer customerId employeeSsn  employeeName employeeAge address)

    saveCustomer db employeeInteraction employeeId customerId customer customers

  else do
    name <- input "Nome: "
    age <- input "Idade: "
    address <- input "Endereço: "

    let customer = (Customer customerId ssn name (read age) address)

    saveCustomer db employeeInteraction employeeId customerId customer customers

saveCustomer :: DB -> Interaction -> Int -> Int -> Customer -> [Customer] -> IO()
saveCustomer db employeeInteraction employeeId customerId customer customers = do
  DB.entityToFile customer "cliente.txt" "custId.txt"
  let newDB = db {DB.customers = customers ++ [customer], DB.currentIdCustomer = customerId}

  clear
  putStr "Cliente cadastrado com sucesso!"
  putStr $ show customer
  waitThreeSeconds
  employeeInteraction newDB employeeId