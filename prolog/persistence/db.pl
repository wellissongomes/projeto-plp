:- module(db, [init/0, writePurchase/0, nextId/1]).

% PurchaseID, EmployeeID, CustomerID, Score, Price, HasBeenReviwed
initPurchase :- dynamic purchase/6.
readPurchase :- consult('./data/purchase.bd').
startPurchase :- exists_file('./data/purchase.bd') -> readPurchase ; initPurchase.
writePurchase :- tell('./data/purchase.bd'), listing(purchase), told.

initId :- assertz(id(0)).
readId :- consult('./data/id.bd').
startId :- exists_file('./data/id.bd') -> readId ; initId.
writeId :- tell('./data/id.bd'), listing(id), told.
nextId(N) :- id(X), retract(id(X)), N is X + 1, assert(id(N)), writeId.


init :- startPurchase, startId.