module CardapioController where
import Cardapio
import Doce
import Bebida

adicionaDoceCardapio :: Doce -> Cardapio -> [Doce]
adicionaDoceCardapio doce cardapio = (Cardapio.doces cardapio) ++ [doce]

adicionaBebidaCardapio :: Bebida -> Cardapio -> [Bebida]
adicionaBebidaCardapio bebida cardapio = (Cardapio.bebidas cardapio) ++ [bebida]

removeDoceCardapio :: Int -> Cardapio -> [Doce]
removeDoceCardapio id cardapio = [d | d <- (Cardapio.doces cardapio), (Doce.id d) /= id]

removeBebidaCardapio :: Int -> Cardapio -> [Bebida]
removeBebidaCardapio id cardapio = [b | b <- (Cardapio.bebidas cardapio), (Bebida.id b) /= id]