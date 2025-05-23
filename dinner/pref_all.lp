% clingo dinner/dinner.lp dinner/instances.lp dinner/auxiliary.lp dinner/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp dinner/pref.lp meta-telingo-extension.lp -c horizon=2 0
% clingo dinner/dinner.lp dinner/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0

% #optimize(p11).

% (P1) hasIngredients(spaghetti) & knowsHowToMake(spaghetti)
#preference(p1,more(cardinality)){
   and(initially, p1_aux)
   }.


% (P2) x(hasIngredients(x) & knowsHowToMake(x))
#preference(p2,more(cardinality)){
   and(initially, p2_aux)
   }.


% (P3) final(kitchenClean)
#preference(p3,more(cardinality)){
   eventually(p3_aux)
   }.


% (P4) always(at(home))
#preference(p4,more(cardinality)){
   always(p4_aux)
   }.


% (P5) x eventually(occ(cook(x)))
#preference(p5,more(cardinality)){
   eventually(p5_aux)
}.


% (P6) xy(eventually(occ(orderTakeout(x, y))))
#preference(p6,more(cardinality)){
   eventually(p6_aux)
}.


% (P7) xy(eventually(occ(orderRestaurant(x, y))))
#preference(p7,more(cardinality)){
   eventually(p7_aux)
}.

% (P8) always(¬(xy occ(drive(x, y)) & isSnowing))
#preference(p8,more(cardinality)){
   always(p8_aux)
}.

% (P9) always(¬(x(occ(eat(x)) & chinese(x))))
#preference(p9,more(cardinality)){
   always(p9_aux)
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


preference(p10).
assigned_weight(p10, 1, 0) :- eventually(occurs(eat(spaghetti))).
assigned_weight(p10, 2, 4) :- eventually(occurs(eat(pizza))).
assigned_weight(p10, 3, 5) :-  eventually(occurs(eat(crepes))).
assigned_weight(p10, 4, 10) :-  and(negation(eventually(occurs(eat(crepes)))),
                            and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).

preference(p11).
assigned_weight(p11, 1, 0) :- eventually(p6_aux).
assigned_weight(p11, 2, 2) :- and(eventually(p5_aux), always(p4_aux)).
assigned_weight(p11, 3, 7) :- eventually(p7_aux).
assigned_weight(p11, 4, 9) :- and(eventually(p5_aux), negation(always(p4_aux))).


preference(p12).
assigned_weight(p12, 1, 0) :- if(and(p2_aux, initially), and(eventually(p5_aux), always(p4_aux))).
assigned_weight(p12, 2, 10) :- not if(and(p2_aux, initially), and(eventually(p5_aux), always(p4_aux))).

preference(p13).
assigned_weight(p13, W1) :- assigned_weight(p10, W0), assigned_weight(p11, W1), W0 <= W1.
assigned_weight(p13, W1) :- assigned_weight(p11, W0), assigned_weight(p10, W1), W0 <= W1.

preference(p14).
assigned_weight(p14, W0) :- assigned_weight(p10, W0), assigned_weight(p11, W1), W0 <= W1.
assigned_weight(p14, W0)  :- assigned_weight(p11, W0), assigned_weight(p10, W1), W0 <= W1.

#show assigned_weight/2.