module Chat where

options :: String
options = "\n---------------\n" ++
          "Como você deseja logar no sistema?\n" ++
          "(1) Logar como dono\n" ++
          "(2) Logar como cliente\n" ++
          "(3) Logar como funcionário\n" ++
          "\n---------------\n"

ownerOptions :: String
ownerOptions = "\n---------------\n" ++
               "O que você deseja fazer?\n" ++
               "(1) Cadastrar funcionário\n" ++
               "(2) Cadastrar doce\n" ++
               "(3) Cadastrar bebida\n" ++
               "(4) Remover doce\n" ++
               "(5) Remover bebida\n" ++
               "(6) Listar funcionários\n" ++
               "(7) Listar doces\n" ++
               "(8) Listar bebidas\n" ++
               "(9) Listar vendas\n" ++
               "\n---------------\n"

customerOptions :: String
customerOptions = "\n---------------\n" ++
                  "O que você deseja fazer?\n" ++
                  "(1) Listar produtos bem avaliados\n" ++
                  "(2) Exibir cardápio\n" ++
                  "(3) Personalizar pedido\n" ++
                  "(4) Realizar compra\n" ++
                  "(5) Listar suas compras\n" ++
                  "(6) Avaliar suas compras\n" ++
                  "\n---------------\n"

employeeOptions :: String
employeeOptions = "\n---------------\n" ++
                  "O que você deseja fazer?\n" ++
                  "(1) Cadastrar cliente\n" ++
                  "(2) Cadastrar venda\n" ++
                  "(3) Listar clientes\n" ++
                  "(4) Listar suas vendas\n" ++
                  "\n---------------\n"