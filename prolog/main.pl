:- use_module('./util/utils.pl').
:- use_module('./util/show.pl').
:- use_module('./persistence/db.pl').

main :-
  db:init,
  start.

start :- 
  db:nextId(ID),
  utils:inputNumber('ID employee: ', YID),
  utils:inputNumber('ID customer: ', CID),
  utils:inputNumber('Score: ', Scoree),
  utils:inputNumber('Price: ', Pricee),

  assertz(db:purchase(ID, YID, CID, Scoree, Pricee, false)),
  db:writePurchase,

  forall(db:purchase(PurchId, EmpId, CustId, Score, Price, _),
         show:showPurchase(PurchId, EmpId, CustId, Score, Price)).
  
  halt.