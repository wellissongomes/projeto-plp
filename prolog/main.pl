:- use_module('./util/utils.pl').
:- use_module('./util/show.pl').
:- use_module('./persistence/db.pl').
:- use_module('./controllers/purchaseController.pl').
:- use_module('./controllers/personController.pl').

main :-
  db:init,
  start.

start :- 
  clear,
  % assertz(db:candy(1, "chocolate", "chocolate branco", 100.50, 5)),
  % assertz(db:drink(1, "agua", "agua sem gas", 1.50, 5)),
  % db:writeCandy,
  % db:writeDrink,
  % purchaseController:makePurchase,
  % clear,
  % purchaseController:showPurchase(3),
  % utils:wait,
  % showPurchases,
  personController:makeCustomer,
  personController:makeEmployee,
  halt.