module CustomerController (
  existsCustomer
) where

import Prelude hiding (id)

import Customer

existsCustomer id customers = not $ null [c | c <- customers, (Customer.id c) == id]