:- use_module('./util/utils.pl').
:- use_module('./util/show.pl').
:- use_module('./persistence/db.pl').
:- use_module('./controllers/purchaseController.pl').

main :-
  db:init,
  start.

start :- 
  clear,
  % purchaseController:makePurchase,
  % clear,
  purchaseController:showPurchase(1),
  % showPurchases,
  halt.