module EmployeeInteraction where

import DB
import Customer
import Utils

registerCustomer :: DB -> Interaction -> Int -> IO ()
registerCustomer db employeeInteraction employeeId = do
  let customers = DB.customers db

  let customerId = (DB.currentIdCustomer db) + 1

  ssn <- input "CPF: "
  if existsPerson customers ssn then do
    putStr "CPF já cadastrado.\n"
    registerCustomer db employeeInteraction employeeId
  else do
    name <- input "Nome: "
    age <- input "Idade: "
    address <- input "Endereço: "

    let customer = (Customer customerId ssn name (read age) address)

    DB.entityToFile customer "cliente.txt" "custId.txt"
    let newDB = db {DB.customers = customers ++ [customer], DB.currentIdCustomer = customerId}

    clear
    putStr "Cliente cadastrado com sucesso!"
    putStr $ show customer
    waitThreeSeconds
  
    employeeInteraction newDB employeeId