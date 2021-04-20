module CustomerInteraction where

import DB
import Utils
import PurchaseController

backToCustomerInteraction :: DB -> Interaction -> Int -> IO ()
backToCustomerInteraction db customerInteraction currentCustomerId = do
  continue
  clear
  customerInteraction db currentCustomerId

customerViewCandyMenu :: DB -> Interaction -> Int -> IO ()
customerViewCandyMenu db customerInteraction currentCustomerId = do
  let purchases = (DB.purchases db)
  
  let hasPurchase = customerHasPurchase currentCustomerId purchases
  if hasPurchase then do
    putStr $ getPurchasesByCustomer currentCustomerId purchases
    backToCustomerInteraction db customerInteraction currentCustomerId
  else do
    putStr "Você ainda não tem compras realizadas.\n"
    backToCustomerInteraction db customerInteraction currentCustomerId
