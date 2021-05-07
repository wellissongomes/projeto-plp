:- module(purchaseController, [showPurchases/0, registerPurchase/0]).

:- use_module('./persistence/db.pl').
:- use_module('../util/show.pl').

showPurchases :-
  forall(db:purchase(PurchId, EmpId, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustId, Score, Price)),
  wait.

showPurchasesByEmployee(EmployeeID) :-
  forall(db:purchase(PurchId, EmployeeID, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmployeeID, CustId, Score, Price)),
  wait.

showPurchasesByCustomer(CustomerID) :-
  forall(db:purchase(PurchId, EmpId, CustomerID, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustomerID, Score, Price)),
  wait.

showPurchasesWellRated :-
forall((db:purchase(PurchId, EmpId, CustId, Score, Price, _),
        Score >= 4),
        show:showPurchase(PurchId, EmpId, CustId, Score, Price)),
  wait.

showPurchase(ID) :- 
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

registerPurchase :- 
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