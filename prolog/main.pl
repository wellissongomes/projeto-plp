:- use_module('./util/utils.pl').
:- use_module('./util/chat.pl').
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
  % purchaseController:showPurchase(36),
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
  chat:loginScreen,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> ownerInteraction;
   Op =:= 2 -> employeeInteraction;
   Op =:= 3 -> customerInteraction;
   start),
  halt.

ownerInteraction :-
  chat:ownerOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> personController:registerEmployee;
   Op =:= 2 -> itemController:registerCandy;
   Op =:= 3 -> itemController:registerDrink;
   Op =:= 4 -> utils:inputNumber("Digite o id do doce: ", CandyID), itemController:removeCandy(CandyID);
   Op =:= 5 -> utils:inputNumber("Digite o id da bebida: ", DrinkID), itemController:removeDrink(DrinkID);
   Op =:= 6 -> personController:showEmployees;
   Op =:= 7 -> itemController:showCandies;
   Op =:= 8 -> itemController:showDrinks;
   Op =:= 9 -> purchaseController:showPurchases;
   Op =:= 10 -> start;
   ownerInteraction).

customerInteraction :-
  chat:customerOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> itemController:showCandyMenuWellRated, customerInteraction;
   Op =:= 2 -> itemController:showCandyMenu, customerInteraction;
   Op =:= 3 -> purchaseController:registerPurchase, customerInteraction;
   Op =:= 4 -> utils:inputNumber("Digite o id do cliente: ", CustomerID), purchaseController:showPurchasesByCustomer(CustomerID), customerInteraction;
   Op =:= 5 -> utils:inputNumber("Digite o id da compra: ", PurchaseID), purchaseController:makePurchaseReview(PurchaseID), customerInteraction;
   Op =:= 6 -> start;
   customerInteraction).

employeeInteraction :-
  chat:employeeOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> personController:registerCustomer;
   Op =:= 2 -> purchaseController:registerPurchase;
   Op =:= 3 -> personController:showCustomers;
   Op =:= 4 -> utils:inputNumber("Digite o id do funcionário: ", EmployeeID), purchaseController:showPurchasesByEmployee(EmployeeID);
   Op =:= 5 -> start;
   employeeInteraction).
