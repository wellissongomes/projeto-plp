:- module(show, [showPurchase/5]).

:- use_module('./persistence/db.pl').


showItem(ItemId, Name, Description, Price, ScoreItem) :-
  writeln('---------------'),
  writeln(ItemId),
  writeln(Name),
  writeln(Description),
  writeln(Price),
  writeln(ScoreItem).

showPurchase(PurchId, EmpId, CustId, Score, Price) :- 
  writeln('\n---------------'),
  format('ID da compra: ~d~n', [PurchId]),
  format('ID do func: ~d~n', [EmpId]),
  format('ID do cliente: ~d~n', [CustId]),
  format('Avaliação: ~d~n', [Score]),
  format('Preço: R$~2f~n', [Price]),
  writeln('\n\nDOCES\n'),
  forall((db:purchase_candy(PurchId, CandyId),
         db:candy(CandyId, Name, Description, CandyPrice, ScoreCandy)),
         showItem(CandyId, Name, Description, CandyPrice, ScoreCandy)),
 
  writeln('\n\nBEBIDAS\n'),
 
  forall((db:purchase_drink(PurchId, DrinkID),
         db:drink(DrinkID, Name, Description, DrinkPrice, ScoreDrink)),
         showItem(DrinkID, Name, Description, DrinkPrice, ScoreDrink)),
  writeln('---------------').