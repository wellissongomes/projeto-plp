:- use_module('./util/utils.pl').
:- use_module('./util/show.pl').
:- use_module('./persistence/db.pl').
:- use_module('./controllers/purchaseController.pl').

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
  purchaseController:showPurchase(3),
  utils:wait,
  % showPurchases,
  % makeCustomer,
  halt.


% CustomerID, Ssn, Name, Age, Address
makeCustomer :- 
  db:nextId(ID),
  makePerson(Ssn, Name, Age),
  utils:input("Digite seu endereço: ", Address),
  db:assertz(customer(ID, Ssn, Name, Age, Address)),
  db:writeCustomer,
  clear,
  writeln("Cliente cadastrado com sucesso!\n"),
  show:showCustomer(ID, Ssn, Name, Age, Address),
  utils:wait,
  main.

makeEmployee :- 
  db:nextId(ID),
  makePerson(Ssn, Name, Age),
  writeln("\n(1) Confeitero"),
  writeln("(2) Vendedor"),
  utils:inputNumber("\nCargo: ", Number),
  (Number =:= 1 -> Role = "confeitero" ; Role = "vendedor"),
  db:assertz(employee(ID, Ssn, Name, Age, Role)),
  clear,
  db:writeEmployee,
  writeln("Funcionário cadastrado com sucesso!\n"),
  show:showEmployee(ID, Ssn, Name, Age, Role),
  utils:wait,
  main.

makePerson(Ssn, Name, Age) :-
  utils:input("CPF: ", Ssn),
  utils:input("Nome: ", Name),
  utils:inputNumber("Idade: ", Age).