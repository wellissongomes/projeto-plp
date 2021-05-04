:- module(purchaseController, [showPurchases/0, makePurchase/0]).

:- use_module('./persistence/db.pl').
:- use_module('../util/show.pl').

showPurchases :-
  forall(db:purchase(PurchId, EmpId, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustId, Score, Price)).

showPurchase(ID) :- 
  db:purchase(ID, EmpId, CustId, Score, Price, _),
  show:showPurchase(ID, EmpId, CustId, Score, Price).

calculatePriceCandy(PurchaseID, TotalPrice) :-
  findall(Price, (db:purchase_candy(PurchaseID, CandyID), db:candy(CandyID, _, _, Price, _)), Prices),
  sum_list(Prices, TotalPrice).

calculatePriceDrink(PurchaseID, TotalPrice) :-
  findall(Price, (db:purchase_drink(PurchaseID, DrinkID), db:drink(DrinkID, _, _, Price, _)), Prices),
  sum_list(Prices, TotalPrice).

chooseCandies(PurchaseID) :- 
  utils:inputNumber("Digite o id do doce: ", CandyID),
  assertz(db:purchase_candy(PurchaseID, CandyID)),
  db:writePurchaseCandy,
  utils:input("Deseja escolher mais doce? [S/N]: ", I),
  (I =:= "S" -> chooseCandies(PurchaseID) ; !).

chooseDrinks(PurchaseID) :- 
  utils:inputNumber("Digite o id da bebida: ", DrinkID),
  assertz(db:purchase_drink(PurchaseID, DrinkID)),
  db:writePurchaseDrink,
  utils:input("Deseja escolher mais bebida? [S/N]: ", I),
  (I =:= "S" -> chooseDrinks(PurchaseID) ; !).

makePurchase :- 
  nextId(ID),
  utils:inputNumber('ID employee: ', EmployeeID),
  utils:inputNumber('ID customer: ', CustomerID),
  chooseCandies(ID),
  chooseDrinks(ID),
  calculatePriceCandy(PurchaseID, TotalPriceCandy),
  calculatePriceDrink(PurchaseID, TotalPriceDrink),

  PurchasePrice is TotalPriceCandy + TotalPriceDrink,
  assertz(db:purchase(ID, EmployeeID, CustomerID, 5, PurchasePrice, false)),
  db:writePurchase.