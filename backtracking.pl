backtracking:- backtracking_step(0, 0, 0, [], 0).

%% Win condition
backtracking_step(Xp, Yp, Np, PMoves, PPass):-
    touchdown_nearby(Xp, Yp, Np, PMoves, PPass, N, Moves),
    assertz(path(N, Moves)), !.

%% Death condition
backtracking_step(Xp, Yp, _, _, _):- orc(Xp, Yp), !.

%% Try first with pass
backtracking_step(Xp, Yp, N, Moves, 0):-
    pass(Xp, Yp, X, Y),
    not(seen(X, Y, _, _)),

    N1 is N + 1,
    append(Moves, [[X, Y, 1]], NMoves),
    assertz(seen(X, Y, N1, 1)),
    backtracking_step(X, Y, N1, NMoves, 1).

%% Ordinary step
backtracking_step(Xp, Yp, N, Moves, P):-
    step(Xp, Yp, X, Y),
    (P == 0, not(seen(X, Y, _, 0)); not(seen(X, Y, _, _))),

    (human(X, Y), N1 is N; N1 is N+1),
    append(Moves, [[X, Y, 0]], NMoves),
    retractall(seen(X, Y, _, 1)),
    assertz(seen(X, Y, N1, P)),
    backtracking_step(X, Y, N1, NMoves, P).
