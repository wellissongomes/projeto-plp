:- module(chat, [slogan/0, chatLogin/0, loginScreen/0, ownerOptions/0, customerOptions/0, employeeOptions/0]).

slogan :-
  string_concat("--------------------------------------------------------------------------------------\n",
     "                                                                                     |\n",CANDY_STR1),
  string_concat(CANDY_STR1, " ██████  █████  ███    ██ ██████  ██    ██     ██       █████  ███    ██ ██████      |\n",CANDY_STR2),
  string_concat(CANDY_STR2, "██      ██   ██ ████   ██ ██   ██  ██  ██      ██      ██   ██ ████   ██ ██   ██     |\n",CANDY_STR3),
  string_concat(CANDY_STR3, "██      ███████ ██ ██  ██ ██   ██   ████       ██      ███████ ██ ██  ██ ██   ██     |\n",CANDY_STR4),
  string_concat(CANDY_STR4, "██      ██   ██ ██  ██ ██ ██   ██    ██        ██      ██   ██ ██  ██ ██ ██   ██     |\n",CANDY_STR5),
  string_concat(CANDY_STR5, " ██████ ██   ██ ██   ████ ██████     ██        ███████ ██   ██ ██   ████ ██████      |\n                                                                                     |\n",CANDY_STR6),
  string_concat(CANDY_STR6, "   ___     .----.     ___",CHOCO_STR1),
  string_concat(CHOCO_STR1, "       ___  ___  ___  ___  ___.---------------.             |\n",CHOCO_STR2),
  string_concat(CHOCO_STR2, "   \\  -.  /      \\  .-  /",CHOCO_STR3),
  string_concat(CHOCO_STR3, "     .'\\__\\'\\__\\'\\__\\'\\__\\'\\__,`   .  ____ ___ \\            |\n",CHOCO_STR4),
  string_concat(CHOCO_STR4, "   > -=.\\/        \\/.=- <",CHOCO_STR5),
  string_concat(CHOCO_STR5, "     |\\/ __\\/ __\\/ __\\/ __\\/ _:\\   |`.  \\  \\___ \\           |\n",CHOCO_STR6),
  string_concat(CHOCO_STR6, "   > -='/\\        /\\'=- <",CHOCO_STR7),
  string_concat(CHOCO_STR7, "     \\'\\__\\'\\__\\'\\__\\'\\__\\'\\_`. \\__|--`. \\  \\___ \\          |\n",CHOCO_STR8),
  string_concat(CHOCO_STR8, "  /__.-'  \\      /  '-.__\\",CHOCO_STR9),
  string_concat(CHOCO_STR9, "     \\\\/ __\\/ __\\/ __\\/ __\\/ __:                 \\         |\n",CHOCO_STR10),
  string_concat(CHOCO_STR10, "           '-..-'",CHOCO_STR11),
  string_concat(CHOCO_STR11, "               \\\\'\\__\\'\\__\\'\\__\\ \\__\\'\\_:-----------------'         |\n",CHOCO_STR12),
  string_concat(CHOCO_STR12,  "                                 \\\\/   \\/   \\/   \\/   \\/ :                 |         |\n",CHOCO_STR13),
  string_concat(CHOCO_STR13, "                                  \\|______________________:________________|         |\n                                                                                     |\n",CHOCO_STR14),
  string_concat(CHOCO_STR14, "--------------------------------------------------------------------------------------\n\n",CHOCO_STR15),
  writeln(CHOCO_STR15).

chatLogin :-
  writeln('Como você deseja logar no sistema?\n'),
  writeln('(1) logar como dono'),
  writeln('(2) logar como funcionário'),
  writeln('(3) logar como cliente'),
  writeln('(4) sair\n'),
  writeln('----------------------'),
  write('Número: '),
  read(Z).

loginScreen :-
  slogan,
  chatLogin.

ownerOptions :-
  writeln('--------------------------'),
  writeln('Funcionalidades do dono  |'),
  writeln('--------------------------'),
  writeln('O que você deseja fazer?'),
  writeln('(1) Cadastrar funcionário'),
  writeln('(2) Cadastrar doce'),
  writeln('(3) Cadastrar bebida'),
  writeln('(4) Remover doce'),
  writeln('(5) Remover bebida'),
  writeln('(6) Listar funcionários'),
  writeln('(7) Listar doces'),
  writeln('(8) Listar bebidas'),
  writeln('(9) Listar vendas'),
  writeln('(10) VOLTAR'),
  writeln('--------------------------'),
  write('Número: '),
  read(Z).

customerOptions :-
  writeln('----------------------------------'),
  writeln('Funcionalidades do Cliente       |'),
  writeln('----------------------------------'),
  writeln('O que você deseja fazer?'),
  writeln('(1) Listar produtos bem avaliados'),
  writeln('(2) Exibir cardápio'),
  writeln('(3) Realizar compra'),
  writeln('(4) Listar suas compras'),
  writeln('(5) Avaliar uma compra'),
  writeln('(6) VOLTAR'),
  writeln('----------------------------------'),
  write('Número: '),
  read(Z).

employeeOptions :-
  writeln('---------------------------------'),
  writeln('Funcionalidades do Funcionário  |'),
  writeln('---------------------------------'),
  writeln('O que você deseja fazer?'),
  writeln('(1) Cadastrar cliente'),
  writeln('(2) Cadastrar venda'),
  writeln('(3) Listar clientes'),
  writeln('(4) Listar suas vendas'),
  writeln('(5) VOLTAR'),
  writeln('---------------------------------'),
  write('Número: '),
  read(Z).
