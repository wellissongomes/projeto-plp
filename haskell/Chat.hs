module Chat where



slogan:: String
slogan = " ██████  █████  ███    ██ ██████  ██    ██     ██       █████  ███    ██ ██████\n" ++
         "██      ██   ██ ████   ██ ██   ██  ██  ██      ██      ██   ██ ████   ██ ██   ██ \n" ++
         "██      ███████ ██ ██  ██ ██   ██   ████       ██      ███████ ██ ██  ██ ██   ██ \n" ++
         "██      ██   ██ ██  ██ ██ ██   ██    ██        ██      ██   ██ ██  ██ ██ ██   ██ \n" ++
         " ██████ ██   ██ ██   ████ ██████     ██        ███████ ██   ██ ██   ████ ██████\n" ++
        "  ___  ___  ___  ___  ___.---------------.\n" ++
        ".'\\__\\'\\__\\'\\__\\'\\__\\'\\__,`   .  ____ ___ \\\n" ++
        "|\\/ __\\/ __\\/ __\\/ __\\/ _:\\   |`.  \\  \\___ \\\n" ++
         "\\'\\__\\'\\__\\'\\__\\'\\__\\'\\_`.__  |--`. \\  \\___ \\\n" ++
         " \\\\/ __\\/ __\\/ __\\/ __\\/ __:                 \\\n" ++
         "  \\\\'\\__\\'\\__\\'\\__\\ \\__\\'\\_:-----------------'\n" ++
          "   \\\\/   \\/   \\/   \\/   \\/ :                 |\n" ++
          "    \\|______________________:________________|\n"

options :: String
options = 
          "\nComo você deseja logar no sistema?\n" ++
          "\n(1) Logar como dono\n" ++
          "(2) Logar como cliente\n" ++
          "(3) Logar como funcionário\n" ++
          "\n-----------------------\n"

ownerOptions :: String
ownerOptions = "\n-----------------------\n" ++
               "\nO que você deseja fazer?\n" ++
               "\n(1) Cadastrar funcionário\n" ++
               "(2) Cadastrar doce\n" ++
               "(3) Cadastrar bebida\n" ++
               "(4) Remover doce\n" ++
               "(5) Remover bebida\n" ++
               "(6) Listar funcionários\n" ++
               "(7) Listar doces\n" ++
               "(8) Listar bebidas\n" ++
               "(9) Listar vendas\n" ++
               "(10) VOLTAR\n" ++
               "\n-----------------------\n"

customerOptions :: String
customerOptions = "\n-----------------------\n" ++
                  "\nO que você deseja fazer?\n" ++
                  "\n(1) Listar produtos bem avaliados\n" ++
                  "(2) Exibir cardápio\n" ++
                  "(3) Realizar compra\n" ++
                  "(4) Listar suas compras\n" ++
                  "(5) Avaliar suas compras\n" ++
                  "(6) VOLTAR\n" ++
                  "\n-----------------------\n"

employeeOptions :: String
employeeOptions = "\n-----------------------\n" ++
                  "\nO que você deseja fazer?\n" ++
                  "\n(1) Cadastrar cliente\n" ++
                  "(2) Cadastrar venda\n" ++
                  "(3) Listar clientes\n" ++
                  "(4) Listar suas vendas\n" ++
                  "(5) VOLTAR\n" ++
                  "\n-----------------------\n"