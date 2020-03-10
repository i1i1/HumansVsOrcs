:- dynamic([path/2, seen/4]).
:- consult([backtracking, breadth, rand]).

human(X, Y):-     h(X, Y).
orc(X, Y):-       o(X, Y).
touchdown(X, Y):- t(X, Y).
cell(I, J):-      I >= 0, I < 20, J >= 0, J < 20.
not(X):- \+X.

main:-
    print_map,

    try_run('Random',        rand),
    try_run('Backtracking',  backtracking),
    try_run('Breadth first', breadth).


try_run(N, P):- run(N, P); format('Map is not solvable with ~w\n\n', [N]).
run(Name, Pred):-
    retractall(path(_, _)),
    retractall(seen(_, _, _, _)),

    statistics(walltime, [_|[_]]),
    Pred,
    statistics(walltime, [_|[ExecutionTime]]),

    path(X, Moves),

    format('~s search\n', [Name]),
    format('~w\n', [X]),
    print_moves(Moves),
    format("~w msec\n\n", [ExecutionTime]),!.


%% Some helpers for algorithmes
pass(Xp, Yp, X, Y):-
	direction(Dx, Dy),
	pass_to_direction(Xp, Yp, Dx, Dy, X, Y),
	not(step(Xp, Yp, X, Y)).

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

%% Returns path to touchdown (N, Moves) if there is
touchdown_nearby(Xp, Yp, Np, PMoves, PPass, N, Moves):-
    touchdown_nearby_r1(Xp, Yp, Np, PMoves, PPass, N, Moves).

touchdown_nearby_r1(Xp, Yp, Np, PMoves, _, N, Moves):-
    step(Xp, Yp, X, Y), touchdown(X, Y),

    append(PMoves, [[X, Y, 0]], Moves),
    (human(X, Y), N is Np; N is Np + 1).

touchdown_nearby_r2(Xp, Yp, Np, PMoves, _, N, Moves):-
    step(Xp, Yp, X1, Y1), not(orc(X1, Y1)),
    step(X1, Y1, X2, Y2), touchdown(X2, Y2),

    append(PMoves, [[X1, Y1, 0], [X2, Y2, 0]], Moves),
    (human(X1, Y1), N1 is Np; N1 is Np + 1),
    (human(X2, Y2), N  is N1; N  is N1 + 1).


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
