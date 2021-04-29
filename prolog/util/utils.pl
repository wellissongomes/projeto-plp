:- module(utils, [inputNumber/2, input/2, clear/0]).

inputNumber(Text, N) :- input(Text, Output), atom_number(Output, N).


input(Text, V) :- read_pending_chars(user_input, _, _),
                  write(Text), flush_output(user),
                  read_line_to_string(user_input, V).

clear :- tty_clear.