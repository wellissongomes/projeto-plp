:- module(itemController, [registerCandy/0, registerDrink/0, showCandies/0, showDrinks/0, removeCandy/1,
                           removeDrink/1, showCandyMenuWellRated/0, showCandyMenu/0]).

:- use_module('../persistence/db.pl').
:- use_module('./util/utils.pl').
:- use_module('../util/show.pl').

registerItem(Description, Price) :-
  utils:input("Descrição: ", Description),
  utils:inputNumber("Preço: R$", Price).

registerCandy :-
  db:nextId(ID),
  utils:input("Nome do doce: ", Name),
  registerItem(Description, Price),
  Score is 5,
  assertz(db:candy(ID, Name, Description, Price, Score)),
  db:writeCandy,
  clear,
  writeln("Doce cadastrado com sucesso!\n"),
  show:showItem(ID, Name, Description, Price, Score),
  wait.

registerDrink :-
  db:nextId(ID),
  utils:input("Nome da bebida: ", Name),
  registerItem(Description, Price),
  Score is 5,
  assertz(db:drink(ID, Name, Description, Price, Score)),
  db:writeDrink,
  clear,
  writeln("Bebida cadastrado com sucesso!\n"),
  show:showItem(ID, Name, Description, Price, Score),
  wait.

showCandies :-
  db:candy(DBCandiesID, _, _, _, _),
  writeln("\n\e[1mDoces\e[0m\n"),
  forall(db:candy(CandyID, Name, Description, CandyPrice, CandyScore), 
         show:showItem(CandyID, Name, Description, CandyPrice, CandyScore));
  writeln("\nNão há doces presentes no sistema.").
  

showDrinks :-
  db:drink(DBDrinkID, _, _, _, _),
  writeln("\n\e[1mBebidas\e[0m\n"),
  forall(db:drink(DrinkID, Name, Description, DrinkPrice, DrinkScore), 
         show:showItem(DrinkID, Name, Description, DrinkPrice, DrinkScore));
  writeln("\nNão há bebidas presentes no sistema.").
  
removeCandy(CandyID) :-
  db:candy(CandyID, Name, Description, CandyPrice, CandyScore),
  retract(db:candy(CandyID, Name, Description, CandyPrice, CandyScore)),
  db:writeCandy,
  show:showItem(CandyID, Name, Description, CandyPrice, CandyScore),
  writeln("\nDoce removido com sucesso."),
  wait.

removeDrink(DrinkID) :-
  (db:drink(DrinkID, Name, Description, DrinkPrice, DrinkScore) ->
  retract(db:drink(DrinkID, Name, Description, DrinkPrice, DrinkScore)),
  db:writeDrink,
  show:showItem(DrinkID, Name, Description, DrinkPrice, DrinkScore),
  writeln("\nBebida removida com sucesso.") ;
  writeln("Bebida inexistente.")),
  wait.

showCandyMenuWellRated :-
  clear,
  writeln('\e[1mProdutos bem avaliados\e[0m'),
  writeln('\n\n\e[1mDOCES\e[0m\n'),
  ((db:candy(_, _, _, _, ScoreCandyT), ScoreCandyT >= 4),
  forall((db:candy(CandyID, Name, Description, Price, ScoreCandy),
          ScoreCandy >= 4),
          show:showItem(CandyID, Name, Description, Price, ScoreCandy));
  writeln("\nNão há doces bem avaliados no sistema.")),
  
  writeln('\n\n\e[1mBEBIDAS\e[0m\n'),
  ((db:drink(_, _, _, _, ScoreDrinkT), ScoreDrinkT >= 4),
  forall((db:drink(DrinkID, Name, Description, Price, ScoreDrink),
          ScoreDrink >= 4),
          show:showItem(DrinkID, Name, Description, Price, ScoreDrink));
  writeln("\nNão há bebidas bem avaliadas no sistema.")),
  wait.

showCandyMenu :-
  clear,
  writeln("\e[1mCardápio\e[0m\n"),
  showCandies,
  showDrinks,
  wait.