:- module(show, [showPurchase/5]).

:- use_module('./persistence/db.pl').

showItem(ItemId, Name, Description, Price, ScoreItem) :-
  writeln('\n-----------------------'),
  format('ID: ~d~n', [ItemId]),
  format('Nome: ~w~n', [Name]),
  format('Descrição: ~w~n', [Description]),
  format('Avaliação (0 - 5): ~d~n', [ScoreItem]),
  format('Preço: R$~2f~n', [Price]),
  writeln('-----------------------').

showPurchase(PurchId, EmpId, CustId, Score, Price) :- 
  format('\nID da compra: ~d~n', [PurchId]),
  format('ID do funcionário: ~d~n', [EmpId]),
  format('ID do cliente: ~d~n', [CustId]),
  format('Avaliação (0 - 5): ~d~n', [Score]),
  format('Valor total a pagar: R$~2f~n', [Price]),
  writeln('\nPedido:'),
  writeln('\n\nDOCES\n'),
  forall((db:purchase_candy(PurchId, CandyId, Quantity),
         db:candy(CandyId, Name, Description, CandyPrice, ScoreCandy)),
         (format('Quantidade: ~d~n', [Quantity]),
         showItem(CandyId, Name, Description, CandyPrice, ScoreCandy))),
 
  writeln('\n\nBEBIDAS\n'),
 
  forall((db:purchase_drink(PurchId, DrinkID, Quantity),
         db:drink(DrinkID, Name, Description, DrinkPrice, ScoreDrink)),
         (format('Quantidade: ~d~n', [Quantity]),
         showItem(DrinkID, Name, Description, DrinkPrice, ScoreDrink))).

showPerson(Ssn, Name, Age) :-
  format('CPF: ~w~n', [Ssn]),
  format('Nome: ~w~n', [Name]),
  format('Idade: ~d~n', [Age]).

showEmployee(EmployeeID, Ssn, Name, Age, Role) :-
  writeln('\n-----------------------'),
  format('ID: ~d~n', [EmployeeID]),
  showPerson(Ssn, Name, Age),
  format('Função: ~w~n', [Role]),
  writeln('-----------------------').

showCustomer(CustomerID, Ssn, Name, Age, Address) :-
  writeln('\n-----------------------'),
  format('ID: ~d~n', [CustomerID]),
  showPerson(Ssn, Name, Age),
  format('Endereço: ~w~n', [Address]),
  writeln('-----------------------').

showChat :-
  string_concat("--------------------------------------------------------------------------------------\n",
     "                                                                                     |\n",CANDY_STR1),
  string_concat(CANDY_STR1, " ██████  █████  ███    ██ ██████  ██    ██     ██       █████  ███    ██ ██████      |\n",CANDY_STR2),
  string_concat(CANDY_STR2, "██      ██   ██ ████   ██ ██   ██  ██  ██      ██      ██   ██ ████   ██ ██   ██     |\n",CANDY_STR3),
  string_concat(CANDY_STR3, "██      ███████ ██ ██  ██ ██   ██   ████       ██      ███████ ██ ██  ██ ██   ██     |\n",CANDY_STR4),
  string_concat(CANDY_STR4, "██      ██   ██ ██  ██ ██ ██   ██    ██        ██      ██   ██ ██  ██ ██ ██   ██     |\n",CANDY_STR5),
  string_concat(CANDY_STR5, " ██████ ██   ██ ██   ████ ██████     ██        ███████ ██   ██ ██   ████ ██████      |\n                                                                                     |\n",CANDY_STR6),
  string_concat(CANDY_STR6, "   ___     .----.     ___",CHOCO_STR1),
  string_concat(CHOCO_STR1, "       ___  ___  ___  ___  ___.---------------.             |\n",CHOCO_STR2),
  string_concat(CHOCO_STR2, "   \\  -.  /      \\  .-  /",CHOCO_STR3),
  string_concat(CHOCO_STR3, "     .'\\__\\'\\__\\'\\__\\'\\__\\'\\__,`   .  ____ ___ \\            |\n",CHOCO_STR4),
  string_concat(CHOCO_STR4, "   > -=.\\/        \\/.=- <",CHOCO_STR5),
  string_concat(CHOCO_STR5, "     |\\/ __\\/ __\\/ __\\/ __\\/ _:\\   |`.  \\  \\___ \\           |\n",CHOCO_STR6),
  string_concat(CHOCO_STR6, "   > -='/\\        /\\'=- <",CHOCO_STR7),
  string_concat(CHOCO_STR7, "     \\'\\__\\'\\__\\'\\__\\'\\__\\'\\_`. \\__|--`. \\  \\___ \\          |\n",CHOCO_STR8),
  string_concat(CHOCO_STR8, "  /__.-'  \\      /  '-.__\\",CHOCO_STR9),
  string_concat(CHOCO_STR9, "     \\\\/ __\\/ __\\/ __\\/ __\\/ __:                 \\         |\n",CHOCO_STR10),
  string_concat(CHOCO_STR10, "           '-..-'",CHOCO_STR11),
  string_concat(CHOCO_STR11, "               \\\\'\\__\\'\\__\\'\\__\\ \\__\\'\\_:-----------------'         |\n",CHOCO_STR12),
  string_concat(CHOCO_STR12,  "                                 \\\\/   \\/   \\/   \\/   \\/ :                 |         |\n",CHOCO_STR13),
  string_concat(CHOCO_STR13, "                                  \\|______________________:________________|         |\n                                                                                     |\n",CHOCO_STR14),
  string_concat(CHOCO_STR14, "--------------------------------------------------------------------------------------\n\n",CHOCO_STR15),
  writeln(CHOCO_STR15),
  writeln('Como você deseja logar no sistema?\n'),
  writeln('(1) logar como dono'),
  writeln('(2) logar como funcionário'),
  writeln('(3) logar como cliente'),
  writeln('(4) sair\n'),
  writeln('----------------------'),
  write('Número: '),
  read(Z).
  