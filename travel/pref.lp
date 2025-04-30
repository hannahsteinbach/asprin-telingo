% clingo travel/travel.lp travel/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo travel/travel.lp travel/instances.lp travel/auxiliary.lp travel/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp travel/pref.lp meta-telingo-extension.lp -c horizon=2 0
#const maxCost=100.

#optimize(time_or_cost_test).

% (P1) eventually(occ(bus(home,school)) | occ(taxi(home,school))).-> p. 566.
#preference(p1,more(cardinality)){
    and(initially, eventually(or(occurs(bus(home,school)), occurs(take_taxi(home,school)))))
}.

% (P2) always(¬occ(call_taxi(home))) -> p. 566.
#preference(p2,more(cardinality)){
    and(initially, always(negation(occurs(call_taxi(home)))))
}.

% (P3) always(¬available_taxi(home)) -> p. 566.
#preference(p3,more(cardinality)){
    and(initially, always(negation(holds(available_taxi(home)))))
}.

% (P4) goal(has_coffee). -> p. 569
#preference(p4,more(cardinality)){
    eventually(p4_aux)
}.

%(time) time = always(taxi <e (drive|bus) <e walk) -> p. 570
#preference(time, more(cardinality)){
    and(initially, always(time_aux))
}.

% (cost) cost = always(walk <e (drive|bus) <e taxi) -> p. 571
#preference(cost, more(cardinality)){
    and(initially, always(cost_aux))
}.

% (comfort) comfort = always(flight <e (drive|bus) <e walk) -> p. 573
#preference(comfort, more(cardinality)){
    and(initially, always(comfort_aux))
}.

% (safety) safety = always(walk <e flight <e (drive | bus)). -> p. 573
#preference(safety, more(cardinality)){
    and(initially, always(safety_aux))
}.

% Ψ1 = comfort > safety -> p. 573
#preference(p5,lexico){1 ::**safety; 2::**comfort}.

%  Ψ2 = cost > time. -> p. 573
#preference(p6,lexico){1 ::**time; 2::**cost}.

% combine these four desires: -> p. 573
#preference(combined, pareto){**p5; **p6}.


% add coffee as a goal in travel.lp! (different action theory)
% (time_coffee) time_coffee = always(occ(buy_coffee) | (take_taxi <e (drive | bus) <e walk)) -> p. 579
#preference(time_coffee, more(cardinality)){
    and(initially, always(time_coffee_aux))
}.

% add coffee as a goal in travel.lp! (different action theory)
% (cost_coffee) cost_coffee = always(occ(buy_coffee) | (walk <e (drive | bus) <e tak_taxi)). -> p. 579
#preference(cost_coffee, more(cardinality)){
    and(initially, always(cost_coffee_aux))
}.

% Ψ1 = time n cost  -> p. 579
#preference(time_n_cost, more(cardinality)){
    and(initially, always(time_n_cost_aux))
    }.

% Ψ2 = time & cost. -> p. 579
#preference(time_and_cost_test,more(cardinality)){and(time_coffee_aux,cost_coffee_aux)}.
#preference(time_and_cost,and){ **time_coffee; **cost_coffee}.

% Ψ3 = time u cost -> p. 580, must have either taxi or walk (or both)
#preference(time_v_cost, more(cardinality)){
    and(initially, always(time_v_cost_aux))
    }.

% Ψ4 = time | cost -> p. 580
#preference(time_or_cost_test,more(cardinality)){or(time_coffee_aux,cost_coffee_aux)}.
#preference(time_or_cost,pareto){ **time_coffee; **cost_coffee}.


% Ψ5 =! time -> p. 580
#preference(negated_time, neg){
    **time
    }.


% test
%#preference(p10,lexico){1 ::**shortest; 2::**cheapest}.
#preference(p11,lexico){1 ::**time; 2::**p4}.


% shortest trajectory -> p. 592 (two options)
#preference(shortest,less(weight)){
    W :: time_of_goal(W)
    }.

% for n = 5 (4.4.1)  p. 592
#preference(t(W), more(cardinality)){
    and(initially,sigma(W))} : W = 0..5.

#preference(shortest_formula_based,lexico){
    -W :: **t(W) : W = 0..5
    }.

% for unbound n (4.4.2)-> how to compare directly? idk p. 592
#preference(shortest_action_based,  more(cardinality)) {
    true(occurs(stop_noop), T) : time(T)
}.

% cheapest trajectory -> p. 593
#preference(c(W), more(cardinality)){
    eventually(cost_overall(W))}: W = 0..maxCost.

#preference(cheapest,lexico){
    -W :: **c(W) : W = 0..maxCost
    }.

%#preference(cheapest,less(weight)){
%    W :: cost_overall(W)
%    }.

% combine coffee and cheapest, prioritize getting coffee
#preference(comb,lexico){
 2::**p4; 1::**cheapest
    }.

% combine coffee and shortest, prioritize getting coffee
#preference(p10,lexico){
 2::**p4; 1::**shortest
    }.

assigned_weight(P, W) :- assigned_weight(P, X, W), #false: assigned_weight(P, Y, Z), Y < X.

preference(p1).
assigned_weight(p1, 1, 0) :- eventually(p1_aux).
assigned_weight(p1, 2, 1) :- negation(eventually(p1_aux)).

preference(p2).
assigned_weight(p2, 1, 0) :- negation(eventually(p2_aux)).
assigned_weight(p2, 2, 1) :- eventually(p2_aux).

preference(p3).
assigned_weight(p3, 1, 0) :- negation(eventually(p3_aux)).
assigned_weight(p3, 2, 1) :- eventually(p3_aux).

preference(p4).
assigned_weight(p4, 1, 0) :- eventually(p4_aux).
assigned_weight(p4, 2, 1) :- negation(eventually(p4_aux)).

% shortest trajectory
time_of_goal(I) :- true(holds(goal_achieved), I),
                   not true(holds(goal_achieved), J) : time(J), J < I.



% basic desires
preference(time_cost_disj).
assigned_weight(time_cost_disj, 1, 0) :- not transportation(X) : transport_mode(X), X != take_taxi, X != walk.
assigned_weight(time_cost_disj, 2, 10) :- transportation(X), X != take_taxi, X!= walk.

% Ensure both actions (take_taxi and walk) are in the trajectory.
assigned_weight(time_cost_conj, 2, 10) :- transportation(X), X != walk.
assigned_weight(time_cost_conj, 2, 10) :- transportation(X), X != take_taxi.


% general preferences
transport_mode(take_taxi; drive; bus; walk; flight).
transportation(A) :- eventually(occurs(A)), transport_mode(A).

preference(time_general).
assigned_weight(time_general, 1, 0) :- not transportation(X) : transport_mode(X), X != take_taxi.
assigned_weight(time_general, 2, 10) :- transportation(X), X != take_taxi.

preference(cost_general).
assigned_weight(cost_general, 1, 0) :- not transportation(X) : transport_mode(X), X != walk.
assigned_weight(cost_general, 2, 10) :- transportation(X), X != walk.

%#show assigned_weight/3.
%#show assigned_weight/2.
%#show time_of_goal/1.
