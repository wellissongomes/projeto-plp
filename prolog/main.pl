:- use_module('./util/utils.pl').
:- use_module('./util/show.pl').
:- use_module('./persistence/db.pl').
:- use_module('./controllers/purchaseController.pl').
:- use_module('./controllers/personController.pl').
:- use_module('./controllers/itemController.pl').

main :-
  db:init,
  start.

start :- 
  clear,
  % assertz(db:candy(1, "chocolate", "chocolate branco", 100.50, 5)),
  % assertz(db:drink(1, "agua", "agua sem gas", 1.50, 5)),
  % db:writeCandy,
  % db:writeDrink,
  % purchaseController:registerPurchase,
  % clear,
  % purchaseController:showPurchase(3),
  % utils:wait,
  % showPurchases,
  % personController:registerCustomer,
  % personController:registerEmployee,
  % itemController:registerCandy,
  % itemController:registerDrink,
  % itemController:showCandies,
  % itemController:showDrinks,
  % show:showItem(1, "chocolate", "chocolate branco", 100.5, 5),
  % itemController:removeCandy(25),
  % itemController:removeDrink(35),
  % personController:showEmployees,
  % personController:showCustomers,
  % purchaseController:showPurchasesByEmployee(1),
  % purchaseController:showPurchasesByCustomer(2),
  % purchaseController:showPurchasesWellRated,
  show:showChat(),
  halt.