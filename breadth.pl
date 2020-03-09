:- dynamic(breadth_stack).
breadth:-
    assertz((breadth_stack(S):- S = [[0, 0, 0, [], 0]])),
    breadth_aggr.

breadth_aggr:- %% Stop if stack length is 0
    breadth_stack(S),
    length(S, 0), !.
breadth_aggr:- %% Stop if path already found
    path(_, _), !.
breadth_aggr:-
    breadth_stack_pop(X, Y, N, Moves, Pass),
    breadth_step(X, Y, N, Moves, Pass),
    breadth_aggr.


breadth_stack_append(X, Y, N, Moves, Pass):-
    breadth_stack(Stack),
    append(Stack, [[X, Y, N, Moves, Pass]], NStack),
    retractall(breadth_stack(_)),
    assertz((breadth_stack(S):- S = NStack)).

breadth_stack_pop(X, Y, N, Moves, Pass):-
    breadth_stack([[X, Y, N, Moves, Pass] | Stack]),
    retractall(breadth_stack(_)),
    assertz((breadth_stack(S):- S = Stack)).


%% Win condition
breadth_step(Xp, Yp, N, Moves, _):-
    touchdown(Xp, Yp),
    assertz(path(N, Moves)), !.
%% Death condition
breadth_step(Xp, Yp, _, _, _):- orc(Xp, Yp), !.

%% Try first with pass
breadth_step(Xp, Yp, N, Moves, 0):-
    pass(Xp, Yp, X, Y),
    not(seen(X, Y, _)),

    N1 is N + 1,
    append(Moves, [[X, Y, 1]], NMoves),
    breadth_stack_append(X, Y, N1, NMoves, 1),
    assertz(seen(X, Y, N1)),
    false. % Fail in order to try all steps

%% Try just ordinary step
breadth_step(Xp, Yp, N, Moves, P):-
    step(Xp, Yp, X, Y),
    not(seen(X, Y, _)),

    (human(X, Y), N1 is N; N1 is N+1),
    append(Moves, [[X, Y, 0]], NMoves),
    breadth_stack_append(X, Y, N1, NMoves, P),
    assertz(seen(X, Y, N1)),
    false.

breadth_step(_, _, _, _, _):- true.
