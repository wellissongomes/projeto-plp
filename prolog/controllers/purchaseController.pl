:- module(purchaseController, [showPurchases/0, purchaseReview/0, registerPurchaseByCustomer/1, registerPurchaseByEmployee/1]).

:- use_module('./persistence/db.pl').
:- use_module('../util/show.pl').

showPurchases :-
  clear,
  writeln("Compras\n"),
  forall(db:purchase(PurchId, EmpId, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustId, Score, Price)),
  wait.

showPurchasesByEmployee(EmployeeID) :-
  clear,
  writeln("Vendas\n"),
  forall(db:purchase(PurchId, EmployeeID, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmployeeID, CustId, Score, Price)),
  wait.

showPurchasesByCustomer(CustomerID) :-
  clear,
  writeln("Compras\n"),
  forall(db:purchase(PurchId, EmpId, CustomerID, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustomerID, Score, Price)),
  wait.

showPurchase(ID) :- 
  clear,
  writeln("Compra\n"),
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
  ((db:purchase_candy(PurchaseID, CandyID, _),
  utils:inputNumber("Digite a quantidade: ", Quantity),
  assertz(db:purchase_candy(PurchaseID, CandyID, Quantity)),
  db:writePurchaseCandy);
  writeln("\nEsse doce já foi adicionado à compra"),
  chooseCandies(PurchaseID)),
  findall(PurchaseCandyID, db:purchase_candy(PurchaseID, PurchaseCandyID, _), PurchaseCandiesID),
  findall(DBCandyID, db:candy(DBCandyID, _, _, _, _), CandiesID),
  length(CandiesID, LenCandies),
  length(PurchaseCandiesID, LenCurrentCandies),
  (LenCurrentCandies >= LenCandies, !);
  utils:input("Deseja escolher mais doce? [S/N]: ", I),
  (I =:= "S" -> chooseCandies(PurchaseID) ; !).

chooseDrinks(PurchaseID) :- 
  utils:inputNumber("Digite o id da bebida: ", DrinkID),
  ((db:purchase_drink(PurchaseID, DrinkID, _),
  utils:inputNumber("Digite a quantidade: ", Quantity),
  assertz(db:purchase_drink(PurchaseID, DrinkID, Quantity)),
  db:writePurchaseDrink);
  writeln("\nEssa bebida já foi adicionada à compra"),
  chooseDrinks(PurchaseID)),
  findall(PurchaseDrinkID, db:purchase_drink(PurchaseID, PurchaseDrinkID, _), PurchaseDrinksID),
  findall(DBDrinkID, db:drink(DBDrinkID, _, _, _, _), DrinksID),
  length(DrinksID, LenDrinks),
  length(PurchaseDrinksID, LenCurrentDrinks),
  (LenCurrentDrinks >= LenDrinks, !);
  utils:input("Deseja escolher mais bebida? [S/N]: ", I),
  (I =:= "S" -> chooseDrinks(PurchaseID) ; !).

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
  utils:inputNumber('ID employee: ', EmployeeID),
  registerPurchase(EmployeeID, CustomerID).

registerPurchaseByEmployee(EmployeeID) :- 
  utils:inputNumber('ID customer: ', CustomerID),
  registerPurchase(EmployeeID, CustomerID).

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