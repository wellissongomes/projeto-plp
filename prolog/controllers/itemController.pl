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
  forall(db:candy(CandyID, Name, Description, CandyPrice, CandyScore), 
         show:showItem(CandyID, Name, Description, CandyPrice, CandyScore)),
  wait.
  

showDrinks :-
  forall(db:drink(DrinkID, Name, Description, DrinkPrice, DrinkScore), 
         show:showItem(DrinkID, Name, Description, DrinkPrice, DrinkScore)),
  wait.
  
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
  writeln('\n\nDOCES\n'),

  forall((db:candy(CandyID, Name, Description, Price, ScoreCandy),
          ScoreCandy >= 4),
          show:showItem(CandyID, Name, Description, Price, ScoreCandy)),
    
  writeln('\n\nBEBIDAS\n'),

  forall((db:drink(DrinkID, Name, Description, Price, ScoreDrink),
          ScoreDrink >= 4),
          show:showItem(DrinkID, Name, Description, Price, ScoreDrink)),
  wait.

showCandyMenu :-
  writeln('\n\nDOCES\n'),

  forall((db:candy(CandyID, Name, Description, Price, ScoreCandy)),
          show:showItem(CandyID, Name, Description, Price, ScoreCandy)),
    
  writeln('\n\nBEBIDAS\n'),

  forall((db:drink(DrinkID, Name, Description, Price, ScoreDrink)),
          show:showItem(DrinkID, Name, Description, Price, ScoreDrink)),
  wait.