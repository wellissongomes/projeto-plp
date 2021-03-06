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
   Op =:= 2 -> ((personController:existsSeller -> 
                (utils:inputNumber("Digite o id do vendedor: ", EmployeeID),
                personController:existsEmployee(EmployeeID),
                callEmployeeInteraction(EmployeeID);
                writeln("\nNão existe vendedor com o ID informado."));
                writeln("\nNão existe vendendores cadastrados.")),
                wait,
                start);
   Op =:= 3 -> ((personController:existsCustomer(_)->
                (utils:inputNumber("Digite o id do cliente: ", CustomerID),
                personController:existsCustomer(CustomerID),
                customerInteraction(CustomerID);
                writeln("\nNão existe cliente com o ID informado."));
                writeln("\nNão existe clientes cadastrados.")),
                wait,
                start);
   Op =:= 4 -> writeln("\n\e[1mVolte sempre!\n\n\e[0m"), halt;
   start), 
   start;
   start.

callOwnerInteraction :-
  utils:inputNumber("Digite o id do dono: ", OwnerID),
  personController:existsOwnerByID(OwnerID),
  ownerInteraction;
  writeln("\nNão existe dono com o ID informado."),
  wait,
  start.

callEmployeeInteraction(EmployeeID) :-
  personController:existsSellerByID(EmployeeID),
  employeeInteraction(EmployeeID);
  writeln("\nO ID informado não pertence a um vendedor."),
  wait,
  start.

ownerInteraction :-
  clear,
  chat:slogan,
  chat:ownerOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> personController:registerEmployee;
   Op =:= 2 -> itemController:registerCandy;
   Op =:= 3 -> itemController:registerDrink;
   Op =:= 4 -> itemController:callRemoveCandy, wait;
   Op =:= 5 -> itemController:callRemoveDrink, wait;
   Op =:= 6 -> personController:showEmployees, wait;
   Op =:= 7 -> clear, itemController:showCandies, wait;
   Op =:= 8 -> clear, itemController:showDrinks, wait;
   Op =:= 9 -> purchaseController:showPurchases, wait;
   Op =:= 10 -> start;
   ownerInteraction),
   ownerInteraction;
   ownerInteraction.


customerInteraction(CustomerID) :-
  clear,
  chat:slogan,
  chat:customerOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> itemController:showCandyMenuWellRated;
   Op =:= 2 -> itemController:showCandyMenu;
   Op =:= 3 -> purchaseController:registerPurchaseByCustomer(CustomerID), wait;
   Op =:= 4 -> purchaseController:showPurchasesByCustomer(CustomerID), wait;
   Op =:= 5 -> purchaseController:callMakePurchaseReview, wait;
   Op =:= 6 -> start;
   customerInteraction(CustomerID)),
   customerInteraction(CustomerID);
   customerInteraction(CustomerID).

employeeInteraction(EmployeeID) :-
  clear,
  chat:slogan,
  personController:existsEmployee(EmployeeID),
  chat:employeeOptions,
  utils:inputNumber("Opção: ", Op),
  (Op =:= 1 -> personController:registerCustomer;
   Op =:= 2 -> purchaseController:registerPurchaseByEmployee(EmployeeID), wait;
   Op =:= 3 -> personController:showCustomers, wait;
   Op =:= 4 -> purchaseController:showPurchasesByEmployee(EmployeeID), wait;
   Op =:= 5 -> start;
   employeeInteraction(EmployeeID)),
   employeeInteraction(EmployeeID);
   employeeInteraction(EmployeeID).
