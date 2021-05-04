:- module(db, [init/0, writePurchase/0, nextId/1, writeDrink/0, writePurchaseDrink/0, writeEmployee/0, writeCustomer/0]).

% PurchaseID, EmployeeID, CustomerID, Score, Price, HasBeenReviwed
initPurchase :- dynamic purchase/6.
readPurchase :- consult('./data/purchase.bd').
startPurchase :- exists_file('./data/purchase.bd') -> readPurchase ; initPurchase.
writePurchase :- tell('./data/purchase.bd'), listing(purchase), told.

% CandyID, Name, Description, Price, ScoreCandy
initCandy :- dynamic candy/5.
readCandy :- consult('./data/candy.bd').
startCandy :- exists_file('./data/candy.bd') -> readCandy ; initCandy.
writeCandy :- tell('./data/candy.bd'), listing(candy), told.

% DrinkID, Name, Description, Price, ScoreDrink
initDrink :- dynamic drink/5.
readDrink :- consult('./data/drink.bd').
startDrink :- exists_file('./data/drink.bd') -> readDrink ; initDrink.
writeDrink :- tell('./data/drink.bd'), listing(drink), told.

% PurchaseID, CandyID, Quantity
initPurchaseCandy :- dynamic purchase_candy/3.
readPurchaseCandy :- consult('./data/purchase_candy.bd').
startPurchaseCandy :- exists_file('./data/purchase_candy.bd') -> readPurchaseCandy ; initPurchaseCandy.
writePurchaseCandy :- tell('./data/purchase_candy.bd'), listing(purchase_candy), told.

% PurchaseID, DrinkID, Quantity
initPurchaseDrink :- dynamic purchase_drink/3.
readPurchaseDrink :- consult('./data/purchase_drink.bd').
startPurchaseDrink :- exists_file('./data/purchase_drink.bd') -> readPurchaseDrink ; initPurchaseDrink.
writePurchaseDrink :- tell('./data/purchase_drink.bd'), listing(purchase_drink), told.

% EmployeeID, Ssn, Name, Age, Role
initEmployee :- dynamic employee/5.
readEmployee :- consult('./data/employee.bd').
startEmployee :- exists_file('./data/employee.bd') -> readEmployee ; initEmployee.
writeEmployee :- tell('./data/employee.bd'), listing(employee), told.

% CustomerID, Ssn, Name, Age, Address
initCustomer :- dynamic customer/5.
readCustomer :- consult('./data/customer.bd').
startCustomer :- exists_file('./data/customer.bd') -> readCustomer ; initCustomer.
writeCustomer :- tell('./data/customer.bd'), listing(customer), told.

initId :- assertz(id(0)).
readId :- consult('./data/id.bd').
startId :- exists_file('./data/id.bd') -> readId ; initId.
writeId :- tell('./data/id.bd'), listing(id), told.
nextId(N) :- id(X), retract(id(X)), N is X + 1, assert(id(N)), writeId.

init :- startPurchase, startId, startCandy, startPurchaseCandy, startDrink, startPurchaseDrink, startEmployee, startCustomer.