:- module(show, [showPurchase/5]).

showPurchase(PurchId, EmpId, CustId, Score, Price) :- 
  writeln('\n---------------'),
  format('ID da compra: ~d~n', [PurchId]),
  format('ID do func: ~d~n', [EmpId]),
  format('ID do cliente: ~d~n', [CustId]),
  format('Avaliação: ~d~n', [Score]),
  format('Preço: R$~2f~n', [Price]),
  writeln('---------------').