% clingo examples/dinner.lp examples/instances.lp auxiliary.lp pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp pref.lp meta-telingo-extension.lp -c horizon=2 0
% clingo examples/dinner.lp examples/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0

#optimize(p1).

% (P1) hasIngredients(spaghetti) & knowsHowToMake(spaghetti)
#preference(p1,less(weight)){
   W :: assigned_weight(p1, W)
   }.


% (P2) x(hasIngredients(x) & knowsHowToMake(x))
#preference(p2,less(weight)){
   W :: assigned_weight(p2, W)
   }.


% (P3) final(kitchenClean)
#preference(p3,less(weight)){
   W :: assigned_weight(p3, W)
   }.


% (P4) always(at(home))
#preference(p4,less(weight)){
   W :: assigned_weight(p4, W)
   }.


% (P5) x eventually(occ(cook(x)))
#preference(p5,less(weight)){
   W :: assigned_weight(p5, W)
}.

% (P6) xy(eventually(occ(orderTakeout(x, y))))
#preference(p6,less(weight)){
   W :: assigned_weight(p6, W)
}.


% (P7) xy(eventually(occ(orderRestaurant(x, y))))
#preference(p7,less(weight)){
   W :: assigned_weight(p7, W)
}.

% (P8) always(¬(xy occ(drive(x, y)) & isSnowing))
#preference(p8,less(weight)){
   W :: assigned_weight(p8, W)
}.

% (P9) always(¬(x(occ(eat(x)) & chinese(x))))
#preference(p9,less(weight)){
   W :: assigned_weight(p9, W)
}.


% (P10) occ'(eat(spaghetti))[0] >> occ'(eat(pizza))[0.4] >> occ'(eat(crêpes))[0.5]
% We wish to satisfy the TPF theta i with the lowest index i. Consequently, if Claire eats pizza and crêpes,
% this is no better nor worse with respect to (P10) than situations in which Claire eats only pizza, and it is strictly
% better than situations in which she just eats crêpes. Note that there is always implicitly one last option,
% which is to satisfy none of the theta i , and this option is the least preferred
% -> everything else is less preferred, gets 10

#preference(p10, less(weight)) {
    W :: assigned_weight(p10, W)
}.


% *** (P11) P6[0] >> P5 & P4[0.2] >> P7[0.7] >> P5 & ¬P4[0.9] ***
% P6: eventually(occurs(orderTakeout)
% P4: always(holds(at(home)))
% P5: eventually(occurs(cook))
% P7: eventually(occurs(orderRestaurant))

#preference(p11, less(weight)) {
    W :: assigned_weight(p11, W)
}.

% (P12) P2 : P5 & P4
%#preference(p12, aso) {
%    and(eventually(p5_aux), always(p4_aux))
%    >> negation(and(eventually(p5_aux), always(p4_aux)))
%    || and(p2_aux, initially)
%}.

#preference(p12, less(weight)) {
     W :: assigned_weight(p12, W)
}.

% (P13) P10 & P11
#preference(p13, less(weight)) {
    W :: assigned_weight(p13, W)
}.

% *** (P14) P10 | P11 ***
#preference(p14, less(weight)) {
    W :: assigned_weight(p14, W)
}.


assigned_weight(P, W) :- assigned_weight(P, X, W), #false: assigned_weight(P, Y, Z), Y < X.

preference(p1).
assigned_weight(p1, 1, 0) :- and(p1_aux, initially).
assigned_weight(p1, 2, 1) :- negation(and(p1_aux, initially)).

preference(p2).
assigned_weight(p2, 1, 0) :- and(p2_aux, initially).
assigned_weight(p2, 2, 1) :- negation(and(p2_aux, initially)).

preference(p3).
assigned_weight(p3, 1, 0) :- eventually(p3_aux).
assigned_weight(p3, 2, 1) :- negation(eventually(p3_aux)).

preference(p4).
assigned_weight(p4, 1, 0) :- always(p4_aux).
assigned_weight(p4, 2, 1) :- negation(always(p4_aux)).

preference(p5).
assigned_weight(p5, 1, 0) :- eventually(p5_aux).
assigned_weight(p5, 2, 1) :- negation(eventually(p5_aux)).

preference(p6).
assigned_weight(p6, 1, 0) :- eventually(p6_aux).
assigned_weight(p6, 2, 1) :- negation(eventually(p6_aux)).

assigned_weight(p7, 1, 0) :- eventually(p7_aux).
assigned_weight(p7, 2, 1) :- negation(eventually(p7_aux)).

assigned_weight(p8, 1, 0) :- always(p8_aux).
assigned_weight(p8, 2, 1) :- negation(always(p8_aux)).

assigned_weight(p9, 1, 0) :- always(p9_aux).
assigned_weight(p9, 2, 1) :- negation(always(p9_aux)).


preference(p10).
preference(p11).
preference(p12).


% does not work with initially
assigned_weight(p10, 1, 0) :- eventually(occurs(eat(spaghetti))).
assigned_weight(p10, 2, 4) :- eventually(occurs(eat(pizza))).
assigned_weight(p10, 3, 5) :-  eventually(occurs(eat(crepes))).
assigned_weight(p10, 4, 10) :-  and(negation(eventually(occurs(eat(crepes)))),
                            and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).

assigned_weight(p11, 1, 0) :- eventually(p6_aux).
assigned_weight(p11, 2, 2) :- and(eventually(p5_aux), always(p4_aux)).
assigned_weight(p11, 3, 7) :- eventually(p7_aux).
assigned_weight(p11, 4, 9) :- and(eventually(p5_aux), negation(always(p4_aux))).

% also add assigned_weight for p12
assigned_weight(p12, 1, 0) :- and(p2_aux, initially), and(eventually(p5_aux), always(p4_aux)).
assigned_weight(p12, 2, 10) :- and(p2_aux, initially), negation(and(eventually(p5_aux), always(p4_aux))).
assigned_weight(p12, 3, 0) :- negation(and(p2_aux, initially)).



% sum up all assigned weights for the final preference score
%total_weight(Sum) :- Sum = #sum { W : assigned_weight(_,_, W) }.

% sum up all assigned weights for the final preference score for each preference, get smallest weight of *all* preferences
%total_weight(P, Sum) :- Sum = #sum { W : assigned_weight(P, _, W) }.

%smallest_weight(W0) :- total_weight(P0, W0), total_weight(P1, W1), P1 != P0, W0 <= W1.

% for 13
assigned_weight(p13, W1) :- assigned_weight(p10, W0), assigned_weight(p11, W1), W0 <= W1.
assigned_weight(p13, W1) :- assigned_weight(p11, W0), assigned_weight(p10, W1), W0 <= W1.

% for p14
assigned_weight(p14, W0) :- assigned_weight(p10, W0), assigned_weight(p11, W1), W0 <= W1.
assigned_weight(p14, W0)  :- assigned_weight(p11, W0), assigned_weight(p10, W1), W0 <= W1.

%#show total_weight/1.
%#show total_weight/2.
#show assigned_weight/3.
#show assigned_weight/2.
%#show smallest_weight/1.
%#show smallest_weight_assigned/1.