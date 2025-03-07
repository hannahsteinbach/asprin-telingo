% clingo examples/dinner.lp examples/instances.lp auxiliary.lp pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp pref.lp meta-telingo-extension.lp -c horizon=2 0
% clingo examples/dinner.lp examples/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0

% #optimize(p14).

% (P1) hasIngredients(spaghetti) & knowsHowToMake(spaghetti)
#preference(p1,more(cardinality)){
   always(p1_aux)
   }.

% (P2) x(hasIngredients(x) & knowsHowToMake(x))
#preference(p2,more(cardinality)){
  always(p2_aux)
}.

% (P3) final(kitchenClean)
#preference(p3, more(cardinality)) {
   always_before(p3_aux)
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
#preference(p6, more(cardinality)) {
    eventually(p6_aux)
}.

% (P7) xy(eventually(occ(orderRestaurant(x, y))))
#preference(p7,more(cardinality)){
   eventually(p7_aux)
}.

% (P8) always(¬(xy occ(drive(x, y)) & isSnowing))
%#preference(p8,less(cardinality)){
%   eventually(occurs(driveinSnow))
%}.

#preference(p8,more(cardinality)){
   always(p8_aux)
}.

% (P9) always(¬(x(occ(eat(x)) & chinese(x))))
%#preference(p9, less(cardinality)) {
%    eventually(occurs(eatChinese))
%}.

#preference(p9, more(cardinality)) {
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
%    || always(p2_aux)
%}.

#preference(p12, less(weight)) {
     W :: assigned_weight(p12, W)
}.

% (P13) P10 & P11
#preference(p13, less(weight)) {
    W :: p13_aux(W)
}.

% *** (P14) P10 | P11 ***
#preference(p14, less(weight)) {
    W :: p14_aux(W)
}.



preference(p10).
preference(p11).
preference(p12).

% store applied weights explicitly
%assigned_weight(p10, eatSpaghetti, 0) :- eventually(occurs(eat(spaghetti))).
%assigned_weight(p10, eatPizza, 4) :- and(eventually(occurs(eat(pizza))), negation(eventually(occurs(eat(spaghetti))))).
%assigned_weight(p10, eatCrepes, 5) :- and(eventually(occurs(eat(crepes))), and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).

% added this for anything else than eating spaghetti, pizza, or crepes
%assigned_weight(p10, eatElse , 10) :- and(negation(eventually(occurs(eat(crepes)))),
%                                            and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).


% does not work with initially
assigned_weight(p10, 1, 0) :- eventually(occurs(eat(spaghetti))).
assigned_weight(p10, 2, 4) :- eventually(occurs(eat(pizza))).
assigned_weight(p10, 3, 5) :-  eventually(occurs(eat(crepes))).
assigned_weight(p10, 4, 10) :-  and(negation(eventually(occurs(eat(crepes)))),
                            and(negation(eventually(occurs(eat(spaghetti)))), negation(eventually(occurs(eat(pizza)))))).




assigned_weight(P, W) :- assigned_weight(P, X, W), #false: assigned_weight(P, Y, Z), Y < X.

%assigned_weight(p11, orderTakeout, 0) :- eventually(occurs(orderTakeout)).
%assigned_weight(p11, cookHome, 2) :- and(always(holds(at(home))), eventually(occurs(cook))).
%assigned_weight(p11, orderRestaurant, 7) :- eventually(occurs(orderRestaurant)).
%assigned_weight(p11, cookAway, 9) :- and(negation(always(holds(at(home)))), eventually(occurs(cook))).

% but i dont think it works like this (7 if it should be 9 for example with n=6)
assigned_weight(p11, 1, 0) :- eventually(p6_aux).
assigned_weight(p11, 2, 2) :- and(eventually(p5_aux), always(p4_aux)).
assigned_weight(p11, 3, 7) :- eventually(p7_aux).
assigned_weight(p11, 4, 9) :- and(eventually(p5_aux), negation(always(p4_aux))).

% also add assigned_weight for p12
assigned_weight(p12, 1, 0) :- always(p2_aux), and(eventually(p5_aux), always(p4_aux)).
assigned_weight(p12, 2, 10) :- always(p2_aux), negation(and(eventually(p5_aux), always(p4_aux))).
assigned_weight(p12, 3, 0) :- negation(always(p2_aux)).

% added this for cases when person drives7walks somewhere without achieving something (not buying ingredients,
% not going to a restaurant to order anything)
%assigned_weight(p11, driveNotOrderingNotCooking, 10) :- and(negation(always(holds(at(home)))), and(negation(eventually(occurs(orderRestaurant))), negation(eventually(occurs(cook))))).


% sum up all assigned weights for the final preference score
%total_weight(Sum) :- Sum = #sum { W : assigned_weight(_,_, W) }.

% sum up all assigned weights for the final preference score for each preference, get smallest weight of *all* preferences
%total_weight(P, Sum) :- Sum = #sum { W : assigned_weight(P, _, W) }.

%smallest_weight(W0) :- total_weight(P0, W0), total_weight(P1, W1), P1 != P0, W0 <= W1.

% for 13
p13_aux(W0+W1) :- assigned_weight(p10, W0), assigned_weight(p11, W1).

% for p14
p14_aux(W0) :- assigned_weight(p10, W0), assigned_weight(p11, W1), W0 <= W1.
p14_aux(W0) :- assigned_weight(p11, W0), assigned_weight(p10, W1), W0 <= W1.

%#show total_weight/1.
%#show total_weight/2.
#show assigned_weight/3.
#show assigned_weight/2.
%#show smallest_weight/1.
%#show smallest_weight_assigned/1.
#show p13_aux/1.
#show p14_aux/1.