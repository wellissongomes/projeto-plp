:- module(personController, [makeCustomer/0, makeEmployee/0]).

:- use_module('./persistence/db.pl').

makeCustomer :- 
  db:nextId(ID),
  makePerson(Ssn, Name, Age),
  utils:input("Digite seu endereço: ", Address),
  db:assertz(customer(ID, Ssn, Name, Age, Address)),
  db:writeCustomer,
  clear,
  writeln("Cliente cadastrado com sucesso!\n"),
  show:showCustomer(ID, Ssn, Name, Age, Address),
  utils:wait.

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
  utils:wait.

makePerson(Ssn, Name, Age) :-
  utils:input("CPF: ", Ssn),
  utils:input("Nome: ", Name),
  utils:inputNumber("Idade: ", Age).