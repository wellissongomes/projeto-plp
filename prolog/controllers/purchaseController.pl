:- module(purchaseController, [showPurchases/0, makePurchase/0]).

:- use_module('./persistence/db.pl').
:- use_module('../util/show.pl').

showPurchases :-
  forall(db:purchase(PurchId, EmpId, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustId, Score, Price)).

showPurchase(ID) :- 
  db:purchase(ID, EmpId, CustId, Score, Price, _),
  show:showPurchase(ID, EmpId, CustId, Score, Price).

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
  utils:inputNumber("Digite a quantidade: ", Quantity),
  assertz(db:purchase_candy(PurchaseID, CandyID, Quantity)),
  db:writePurchaseCandy,
  utils:input("Deseja escolher mais doce? [S/N]: ", I),
  (I =:= "S" -> chooseCandies(PurchaseID) ; !).

chooseDrinks(PurchaseID) :- 
  utils:inputNumber("Digite o id da bebida: ", DrinkID),
  utils:inputNumber("Digite a quantidade: ", Quantity),
  assertz(db:purchase_drink(PurchaseID, DrinkID, Quantity)),
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