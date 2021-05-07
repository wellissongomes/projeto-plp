:- module(personController, [registerCustomer/0, registerEmployee/0, showEmployees/0, showCustomers/0]).

:- use_module('../persistence/db.pl').
:- use_module('./util/utils.pl').
:- use_module('../util/show.pl').

registerCustomer :- 
  db:nextId(ID),
  registerPerson(Ssn, Name, Age),
  utils:input("Digite seu endereço: ", Address),
  db:assertz(customer(ID, Ssn, Name, Age, Address)),
  db:writeCustomer,
  clear,
  writeln("Cliente cadastrado com sucesso!\n"),
  show:showCustomer(ID, Ssn, Name, Age, Address),
  utils:wait.

registerEmployee :- 
  db:nextId(ID),
  registerPerson(Ssn, Name, Age),
  writeln("\n(1) Confeitero"),
  writeln("(2) Vendedor"),
  utils:inputNumber("\nCargo: ", Number),
  (Number =:= 1 -> Role = "confeitero" ; Role = "vendedor"),
  db:assertz(employee(ID, Ssn, Name, Age, Role)),
  clear,
  db:writeEmployee,
  writeln("Funcionário cadastrado com sucesso!\n"),
  show:showEmployee(ID, Ssn, Name, Age, Role),
  utils:wait.

registerPerson(Ssn, Name, Age) :-
  utils:input("CPF: ", Ssn),
  utils:input("Nome: ", Name),
  utils:inputNumber("Idade: ", Age).

showEmployees :-
  forall(db:employee(EmployeeID, Ssn, Name, Age, Role),
         show:showEmployee(EmployeeID, Ssn, Name, Age, Role)),
  wait.

showCustomers :-
  forall(db:customer(CustomerID, Ssn, Name, Age, Role),
         show:showCustomer(CustomerID, Ssn, Name, Age, Role)),
  wait.