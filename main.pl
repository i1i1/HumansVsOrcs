:- dynamic([cell/2, path/2, seen/3]).
:- consult([backtracking, breadth, rand]).

human(X, Y):-     h(X, Y).
orc(X, Y):-       o(X, Y).
touchdown(X, Y):- t(X, Y).


main:-
    create_field(20, 20),

    print_map,

    try_run('Breadth first', breadth),
    try_run('Backtracking',  backtracking),
    try_run('Random',        rand).


try_run(N, P):- run(N, P); format('Map is not solvable with ~w\n', [N]).
run(Name, Pred):-
    retractall(path(_,_)),
    retractall(seen(_,_,_)),

    statistics(walltime, [_|[_]]),
    Pred,
    statistics(walltime, [_|[ExecutionTime]]),

    path(X, Moves),

    format('~s search\n', [Name]),
    format('~w\n', [X]),
    print_moves(Moves),
    format("~w msec\n\n", [ExecutionTime]),!.

%% Field creator
create_field(X, Y):- create_field_iter(0, 0, X, Y).
create_field_iter(X, Y, X, Y):- !.
create_field_iter(X, J, X, Y):-
    J1 is J + 1,
    create_field_iter(0, J1, X, Y).
create_field_iter(I, J, X, Y):-
    asserta(cell(I, J)),
    I1 is I + 1,
    create_field_iter(I1, J, X, Y).


%% Some dirty prints which produce nice output
print_moves([]):- !.
print_moves(Moves):-
    [[X, Y, Pass] | T] = Moves,
    (Pass == 0, format('~w ~w\n', [X, Y]); format('P ~w ~w\n', [X, Y])),
    print_moves(T).


print_map:-
    nl,
    writeln("   |-----------------------------------------|"),
    print_row(19).

print_row(-1):-
    writeln("---|-----------------------------------------|"),
    print_numbers, nl.
print_row(J):-
    %% Some format magick from http://swi-prolog.996271.n3.nabble.com/Printing-numbers-with-leading-zeros-tp2371p2372.html
    format("~|~` t~w~2| | ", J),
    print_row_items(0, J),
    J1 is J-1,
    print_row(J1).
print_numbers:- write("Y/X|"), print_number(0, 20).

print_number(End, End):- writeln(" |").
print_number(I, End):-
    Val is mod(I, 10),
    format(" ~w", [Val]),
    I1 is I + 1,
    print_number(I1, End).

print_row_items(20, _):- writeln("|").
print_row_items(I, J):-
    (
        (I is 0, J is 0,  write('B ')),!;
        (touchdown(I, J), write('T ')),!;
        (human(I, J),     write('H ')),!;
        (orc(I, J),       write('O ')),!;
        write('. ')
    ),
    I1 is I+1,
    print_row_items(I1, J).


pass(Xp, Yp, X, Y):- direction(Dx, Dy), pass_to_direction(Xp, Yp, Dx, Dy, X, Y).

direction( 0,  1).
direction( 1,  1).
direction( 1,  0).
direction( 1, -1).
direction( 0, -1).
direction(-1, -1).
direction(-1,  0).
direction(-1,  1).

%% Throw ball from position (X; Y) in direction (Xd; Yd)
pass_to_direction(X, Y, Xd, Yd, Xr, Yr):-
    Xnew is X + Xd, Ynew is Y + Yd,
    cell(Xnew, Ynew), not(orc(Xnew, Ynew)), (
        (human(Xnew, Ynew), Xr is Xnew, Yr is Ynew),!;
        pass_to_direction(Xnew, Ynew, Xd, Yd, Xr, Yr)
    ).

step(Xp, Yp, X, Y):- neighbourhood(Xp, Yp, X, Y), cell(X, Y).

neighbourhood(Xp, Yp, X, Y):- X is Xp,     Y is Yp + 1.
neighbourhood(Xp, Yp, X, Y):- X is Xp,     Y is Yp - 1.
neighbourhood(Xp, Yp, X, Y):- X is Xp + 1, Y is Yp.
neighbourhood(Xp, Yp, X, Y):- X is Xp - 1, Y is Yp.
