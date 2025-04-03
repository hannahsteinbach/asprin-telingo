% clingo monkey/monkey.lp monkey/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo monkey/monkey.lp monkey/instances.lp monkey/auxiliary.lp monkey/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp monkey/pref.lp meta-telingo-extension.lp -c horizon=2 0

#optimize(p2).

% (P1) hasBanana > hasCoconut
#preference(p1,less(weight)){
    W :: assigned_weight(p1, W)
    }.

% (P2) banana should be obtained before the chocolate
#preference(p2,less(weight)){
    W :: assigned_weight(p2, W)
    }.

assigned_weight(P, W) :- assigned_weight(P, X, W), #false: assigned_weight(P, Y, Z), Y < X.

preference(p1).
assigned_weight(p1, 1, 0) :- eventually(p1_aux).
assigned_weight(p1, 2, 1) :- negation(eventually(p1_aux)).

preference(p2).
assigned_weight(p2, 1, 0) :- always(p2_aux).
assigned_weight(p2, 2, 1) :- negation(always(p2_aux)).

#show assigned_weight/3.
#show assigned_weight/2.