rand:-
    rand_try_iter(0, 100),

    %% Finding shortest path
    bagof(N, path(N, _), Paths),
    min_list(Paths, N1),
    path(N1, Moves),

    %% Asserting shortest one and removing rest
    retractall(path(_, _)),
    assertz(path(N1, Moves)).

%% Loop for random search
rand_try_iter(E, E):- !.
rand_try_iter(I, E):-
    rand_turn(0, 0, 0, [], 0),
    I1 is I + 1,
    rand_try_iter(I1, E).


%% Win condition
rand_turn(Xp, Yp, N, Moves, _):-
    touchdown(Xp, Yp),
    assertz(path(N, Moves)), !.

%% Death condition
rand_turn(Xp, Yp, _, _, _):- orc(Xp, Yp), !.

%% Both step and pass
rand_turn(Xp, Yp, N, Moves, Pass):-
    bagof([X0, Y0, 0], step(Xp, Yp, X0, Y0), Steps),
    bagof([X1, Y1, 1], pass(Xp, Yp, X1, Y1), Passes),
    (Pass == 0, append(Steps, Passes, Options) ; Options = Steps),

    random_member([X, Y, IsPass], Options),

    ((IsPass == 0, human(X, Y)), N1 is N; N1 is N+1),
    append(Moves, [[X, Y, IsPass]], NMoves),
    NPass is Pass + IsPass,
    rand_turn(X, Y, N1, NMoves, NPass).
