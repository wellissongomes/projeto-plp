:- module(personController, [registerCustomer/0, registerEmployee/0, showEmployees/0, showCustomers/0]).

:- use_module('../persistence/db.pl').
:- use_module('./util/utils.pl').
:- use_module('../util/show.pl').

existsCustomer(CustomerID) :-
  db:customer(CustomerID, _, _, _, _).

existsEmployee(EmployeeID) :-
  db:employee(EmployeeID, _, _, _, _).

existsSellerByID(EmployeeID) :-
  db:employee(EmployeeID, _, _, _, "vendedor").

existsOwner :-
  db:employee(_, _, _, _, "dono").

existsOwnerByID(OwnerID) :-
  db:employee(OwnerID, _, _, _, "dono").

saveUser(ID, Ssn, Name, Age, Address) :-
  db:assertz(customer(ID, Ssn, Name, Age, Address)),
  db:writeCustomer.

registerCustomer :- 
  db:nextId(ID),
  utils:input("CPF: ", Ssn),

  ((db:customer(_, Ssn, _, _, _) -> writeln('\nJá existe um cliente cadastrado com o CPF informado.')) ;

  (db:employee(_, Ssn, Name, Age, _) -> format('\nOlá, ~w~n', [Name]) ;
   registerPerson(Name, Age)),
   
   utils:input("Digite seu endereço: ", Address),
   saveUser(ID, Ssn, Name, Age, Address),
   clear,
   writeln("\nCliente cadastrado com sucesso!"),
   show:showCustomer(ID, Ssn, Name, Age, Address)),
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
  writeln("\nFuncionário cadastrado com sucesso!\n"),
  show:showEmployee(ID, Ssn, Name, Age, Role),
  utils:wait.

registerOwner :-
  writeln("Não existe dono!"),
  utils:input("\nDeseja cadastrar um dono? [s/n]: ", Op),
  Op =:= "s",
  db:nextId(ID),
  registerPerson(Ssn, Name, Age),
  db:assertz(employee(ID, Ssn, Name, Age, "dono")),
  clear,
  db:writeEmployee,
  writeln("Dono cadastrado com sucesso!\n"),
  show:showEmployee(ID, Ssn, Name, Age, "dono"),
  utils:wait;
  !.

registerPerson(Name, Age) :-
  utils:input("Nome: ", Name),
  utils:inputNumber("Idade: ", Age).

showEmployees :-
  existsEmployee(Employee),
  writeln("\e[1mFuncionários\e[0m\n"),
  forall(db:employee(EmployeeID, Ssn, Name, Age, Role),
         show:showEmployee(EmployeeID, Ssn, Name, Age, Role));
  writeln("Não há funcionários presentes no sistema.").

showCustomers :-
  clear,
  existsCustomer(Customer),
  writeln("\e[1mClientes\e[0m\n"),
  forall(db:customer(CustomerID, Ssn, Name, Age, Role),
         show:showCustomer(CustomerID, Ssn, Name, Age, Role));
  writeln("Não há clientes presentes no sistema.").