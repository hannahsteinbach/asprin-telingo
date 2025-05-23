#optimize(p13).

#preference(p13, less(weight)) {
    W :: assigned_weight(p13, W)
}.

assigned_weight(p13, W1) :- assigned_weight(p10, W0), assigned_weight(p11, W1), W0 <= W1.
assigned_weight(p13, W1) :- assigned_weight(p11, W0), assigned_weight(p10, W1), W0 <= W1.

    
assigned_weight(P, W) :- assigned_weight(P, X, W), #false: assigned_weight(P, Y, Z), Y < X.


assigned_weight(p10, 1, 0) :- eventually(occurs(eat(spaghetti))).
assigned_weight(p10, 2, 4) :- eventually(occurs(eat(pizza))).
assigned_weight(p10, 3, 5) :-  eventually(occurs(eat(crepes))).
assigned_weight(p10, 4, 10) :-  and(negation(eventually(occurs(eat(crepes)))),
                            and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).

assigned_weight(p11, 1, 0) :- eventually(p6_aux).
assigned_weight(p11, 2, 2) :- and(eventually(p5_aux), always(p4_aux)).
assigned_weight(p11, 3, 7) :- eventually(p7_aux).
assigned_weight(p11, 4, 9) :- and(eventually(p5_aux), negation(always(p4_aux))).

#show assigned_weight/2. 