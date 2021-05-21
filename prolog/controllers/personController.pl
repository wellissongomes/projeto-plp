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
  utils:input("CPF: ", Ssn),
  
  ((db:customer(_, Ssn, _, _, _) -> writeln('\nJá existe um cliente cadastrado com o CPF informado.')) ;
  (db:employee(_, Ssn, Name, Age, _) -> format('\nOlá, ~w~n', [Name]) ;
   registerPerson(Name, Age)),
   utils:input("Digite seu endereço: ", Address),
   db:nextId(ID),
   saveUser(ID, Ssn, Name, Age, Address),
   clear,
   writeln("\nCliente cadastrado com sucesso!"),
   show:showCustomer(ID, Ssn, Name, Age, Address)),
   utils:wait.  

chooseRole(Role) :-
  writeln("\n(1) Confeitero"),
  writeln("(2) Vendedor"),
  utils:inputNumber("\nCargo: ", Number),
  (Number =:= 1 -> Role = "confeitero" ;
  Number =:= 2 -> Role = "vendedor"; chooseRole(Role)).

registerEmployee :- 
  utils:input("CPF: ", Ssn),
  (db:employee(_, Ssn, _, _, _) -> writeln("\nJá existe um funcionário cadastrado com o CPF informado.");
  (registerPerson(Name, Age),
  chooseRole(Role),
  db:nextId(ID),
  db:assertz(employee(ID, Ssn, Name, Age, Role)),
  clear,
  writeln("\nFuncionário cadastrado com sucesso!\n"),
  db:writeEmployee,
  show:showEmployee(ID, Ssn, Name, Age, Role))), utils:wait.

registerOwner :-
  writeln("\nNão existe dono!"),
  utils:input("\nDeseja cadastrar um dono? [S - SIM ou qualquer letra para NÃO]: ", Op),
  upcase_atom(Op,'S'),
  utils:input("CPF: ", Ssn),
  registerPerson(Name, Age),
  db:nextId(ID),
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
  clear,
  existsEmployee(_),
  writeln("\e[1mFuncionários\e[0m\n"),
  forall(db:employee(EmployeeID, Ssn, Name, Age, Role),
         show:showEmployee(EmployeeID, Ssn, Name, Age, Role));
  writeln("\nNão há funcionários presentes no sistema.").

showCustomers :-
  clear,
  existsCustomer(_),
  writeln("\e[1mClientes\e[0m\n"),
  forall(db:customer(CustomerID, Ssn, Name, Age, Role),
         show:showCustomer(CustomerID, Ssn, Name, Age, Role));
  writeln("\nNão há clientes presentes no sistema.").