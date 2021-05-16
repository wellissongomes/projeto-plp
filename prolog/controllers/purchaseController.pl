:- module(purchaseController, [showPurchases/0, purchaseReview/0, registerPurchaseByCustomer/1, registerPurchaseByEmployee/1]).

:- use_module('./persistence/db.pl').
:- use_module('../util/show.pl').

showPurchases :-
  db:purchase(Purch, _, _, _, _, _),
  writeln("\e[1mVendas\e[0m\n"),
  forall(db:purchase(PurchId, EmpId, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustId, Score, Price));
  writeln("Não há vendas presentes no sistema.").

showPurchasesByEmployee(EmployeeID) :-
  clear,
  db:purchase(_,EmployeeID, _, _, _, _),
  writeln("\e[1mVendas\e[0m\n"),
  forall(db:purchase(PurchId, EmployeeID, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmployeeID, CustId, Score, Price));
  writeln("Não há vendas feitas pelo funcionário logado.").

showPurchasesByCustomer(CustomerID) :-
  clear,
  db:purchase(_,_, CustomerID, _, _, _),
  writeln("\e[1mCompras\e[0m\n"),
  forall(db:purchase(PurchId, EmpId, CustomerID, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustomerID, Score, Price));
  writeln("Não há compras feitas pelo cliente logado.").

showPurchase(ID) :- 
  clear,
  writeln("\e[1mCompra\e[0m\n"),
  db:purchase(ID, EmpId, CustId, Score, Price, _),
  show:showPurchase(ID, EmpId, CustId, Score, Price),
  wait.

totalPriceItem((Price, Quantity), TotalPrice) :- TotalPrice is (Price * Quantity).

calculatePriceCandy(PurchaseID, TotalPrice) :-
  findall((Price, Quantity), (db:purchase_candy(PurchaseID, CandyID, Quantity), db:candy(CandyID, _, _, Price, _)), ItemsTuple),
  maplist(totalPriceItem, ItemsTuple, Prices),
  sum_list(Prices, TotalPrice).

calculatePriceDrink(PurchaseID, TotalPrice) :-
  findall((Price, Quantity), (db:purchase_drink(PurchaseID, DrinkID, Quantity), db:drink(DrinkID, _, _, Price, _)), ItemsTuple),
  maplist(totalPriceItem, ItemsTuple, Prices),
  sum_list(Prices, TotalPrice).

chooseCandies(PurchaseID) :- 
  utils:inputNumber("Digite o id do doce: ", CandyID),

  (db:purchase_candy(PurchaseID, CandyID, _) -> (writeln("\nVocê já selecionou esse doce.\n"), chooseCandies(PurchaseID)) ;

   (\+db:candy(CandyID, _, _, _, _) -> (writeln("\nNão há um doce com esse id.\n"), chooseCandies(PurchaseID)) ;
    (utils:inputNumber("Digite a quantidade: ", Quantity),

    (Quantity =< 0 -> (writeln("\nA quantidade não pode ser menor ou igual a 0.\n"), chooseCandies(PurchaseID)) ; 
     assertz(db:purchase_candy(PurchaseID, CandyID, Quantity)),
     db:writePurchaseCandy,

     findall(PurchaseCandyID, db:purchase_candy(PurchaseID, PurchaseCandyID, _), PurchaseCandiesID),
     findall(DBCandyID, db:candy(DBCandyID, _, _, _, _), CandiesID),
     length(PurchaseCandiesID, CurrentCandiesID),
     length(CandiesID, TotalCandiesID),

     (TotalCandiesID =:= CurrentCandiesID -> (writeln("\nVocê já adicionou todos os doces disponíveis.\n"), !) ; 
     utils:input("Deseja escolher mais doce? [S - SIM ou qualquer letra para NÃO]: ", I),
     (upcase_atom(I,'S') -> chooseCandies(PurchaseID) ; !)
     )
    ))
   )
  ).

chooseDrinks(PurchaseID) :- 
  utils:inputNumber("Digite o id da bebida: ", DrinkID),

  (db:purchase_drink(PurchaseID, DrinkID, _) -> (writeln("\nVocê já selecionou essa bebida.\n"), chooseDrinks(PurchaseID)) ;

   (\+db:drink(DrinkID, _, _, _, _) -> (writeln("\nNão há uma bebida com esse id.\n"), chooseDrinks(PurchaseID)) ;
    (utils:inputNumber("Digite a quantidade: ", Quantity),

    (Quantity =< 0 -> (writeln("\nA quantidade não pode ser menor ou igual a 0.\n"), chooseDrinks(PurchaseID)) ; 
     assertz(db:purchase_drink(PurchaseID, DrinkID, Quantity)),
     db:writePurchaseDrink,

     findall(PurchaseDrinkID, db:purchase_drink(PurchaseID, PurchaseDrinkID, _), PurchaseDrinksID),
     findall(DBDrinkID, db:drink(DBDrinkID, _, _, _, _), DrinksID),
     length(PurchaseDrinksID, CurrentDrinksID),
     length(DrinksID, TotalDrinksID),

     (TotalDrinksID =:= CurrentDrinksID -> (writeln("\nVocê já adicionou todas as bebidas disponíveis.\n"), !) ; 
     utils:input("Deseja escolher mais bebida? [S - SIM ou qualquer letra para NÃO]: ", I),
     (upcase_atom(I,'S') -> chooseDrinks(PurchaseID) ; !)
     )
    ))
   )
  ).

registerPurchase(EmployeeID, CustomerID) :- 
  nextId(ID),
  chooseCandies(ID),
  chooseDrinks(ID),
  calculatePriceCandy(ID, TotalPriceCandy),
  calculatePriceDrink(ID, TotalPriceDrink),

  PurchasePrice is TotalPriceCandy + TotalPriceDrink,
  assertz(db:purchase(ID, EmployeeID, CustomerID, 5, PurchasePrice, false)),
  showPurchase(ID),
  db:writePurchase.

registerPurchaseByCustomer(CustomerID) :- 
  utils:inputNumber('ID do Empregado: ', EmployeeID),
  personController:existsEmployee(EmployeeID) -> 
  (personController:existsSellerByID(EmployeeID) ->
    registerPurchase(EmployeeID, CustomerID);
    writeln("O ID informado não pertence a um vendedor."), wait);
  writeln("Não existe funcionário com o ID informado."), wait.

registerPurchaseByEmployee(EmployeeID) :- 
  utils:inputNumber('ID do Cliente: ', CustomerID),
  personController:existsCustomer(CustomerID), 
  registerPurchase(EmployeeID, CustomerID);
  writeln("Não existe cliente com o ID informado."), wait.

callMakePurchaseReview :-
  utils:inputNumber("Digite o id da compra: ", PurchaseID),
  db:purchase(PurchaseID, _, _, _, _, _),
  makePurchaseReview(PurchaseID);
  writeln("Não existe compra com ID informado."),
  wait.

makePurchaseReview(PurchaseID) :-
  db:purchase(PurchaseID, EmployeeID, CustId, Score, Price, HasBeenReviwed),
  (\+HasBeenReviwed -> 
   utils:inputNumber("Digite a avaliação (VALOR INTEIRO ENTRE 0 E 5): ", NewScore),
   (NewScore < 0 -> clear, writeln("A avaliação não pode ser negativa.\n"), makePurchaseReview(PurchaseID) ;
    NewScore > 5 -> clear, writeln("A avaliação não pode ser maior que 5.\n"), makePurchaseReview(PurchaseID) ;
    retract(db:purchase(PurchaseID, EmployeeID, CustId, Score, Price, HasBeenReviwed)),
    assertz(db:purchase(PurchaseID, EmployeeID, CustId, NewScore, Price, true)),
    db:writePurchase,
    changeScoreCandies(PurchaseID, NewScore),
    changeScoreDrinks(PurchaseID, NewScore),
    showPurchase(PurchaseID) ;
    writeln("\nEssa compra já foi avaliada"))).

hasPurchase(PurchaseID) :- 
  db:purchase(PurchaseID, _, _, _, _, _).

purchaseReview :-
  utils:inputNumber("Digite o id da compra: ", PurchaseID),
  (\+hasPurchase(PurchaseID) -> writeln("\nCompra inexistente") ; makePurchaseReview(PurchaseID)),
  wait.

changeScoreCandy(CandyID, Score) :-
  db:candy(CandyID, Name, Description, Price, ScoreCandy),
  NewScore is (Score + ScoreCandy)//2,
  retract(db:candy(CandyID, Name, Description, Price, ScoreCandy)),
  assertz(db:candy(CandyID, Name, Description, Price, NewScore)),
  db:writeCandy.

changeScoreCandies(PurchaseID, Score) :-
  forall((db:purchase_candy(PurchaseID, CandyID, _),
          db:candy(CandyID, _, _, _, _)),
          changeScoreCandy(CandyID, Score)).

changeScoreDrink(DrinkID, Score) :-
  db:drink(DrinkID, Name, Description, Price, ScoreDrink),
  NewScore is (Score + ScoreDrink)//2,
  retract(db:drink(DrinkID, Name, Description, Price, ScoreDrink)),
  assertz(db:drink(DrinkID, Name, Description, Price, NewScore)),
  db:writeDrink.

changeScoreDrinks(PurchaseID, Score) :-
  forall((db:purchase_drink(PurchaseID, DrinkID, _),
          db:drink(DrinkID,  _, _, _, _)),
          changeScoreDrink(DrinkID, Score)).