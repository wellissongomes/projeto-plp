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
  chat:loginScreen,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> (personController:existsOwner,
                callOwnerInteraction;
                personController:registerOwner,
                start);
   Op =:= 2 -> (utils:inputNumber("Digite o id do funcionário: ", EmployeeID),
                personController:existsEmployee(EmployeeID),
                employeeInteraction(EmployeeID);
                writeln("Funcionário inexistente."),
                wait,
                start);
   Op =:= 3 -> (utils:inputNumber("Digite o id do cliente: ", CustomerID),
                personController:existsCustomer(CustomerID),
                customerInteraction(CustomerID);
                writeln("Cliente inexistente."),
                wait,
                start);
   Op =:= 4 -> writeln("\nVolte sempre!"), halt;
   start).

callOwnerInteraction :-
  utils:inputNumber("Digite o id do dono: ", OwnerID),
  personController:existsOwnerByID(OwnerID),
  ownerInteraction(OwnerID);
  writeln("Não existe dono com o ID informado."),
  wait,
  start.

ownerInteraction(OwnerID) :-
  clear,
  chat:slogan,
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

customerInteraction(CustomerID) :-
  clear,
  chat:slogan,
  chat:customerOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> itemController:showCandyMenuWellRated;
   Op =:= 2 -> itemController:showCandyMenu;
   Op =:= 3 -> purchaseController:registerPurchase;
   Op =:= 4 -> purchaseController:showPurchasesByCustomer(CustomerID);
   Op =:= 5 -> utils:inputNumber("Digite o id da compra: ", PurchaseID), purchaseController:makePurchaseReview(PurchaseID);
   Op =:= 6 -> start;
   customerInteraction(CustomerID)),
   customerInteraction(CustomerID).

employeeInteraction(EmployeeID) :-
  clear,
  chat:slogan,
  personController:existsEmployee(EmployeeID),
  chat:employeeOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> personController:registerCustomer;
   Op =:= 2 -> purchaseController:registerPurchase;
   Op =:= 3 -> personController:showCustomers;
   Op =:= 4 -> purchaseController:showPurchasesByEmployee(EmployeeID);
   Op =:= 5 -> start;
   employeeInteraction(EmployeeID)),
   employeeInteraction(EmployeeID).
