% clingo travel/travel.lp travel/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo travel/travel.lp travel/instances.lp travel/auxiliary.lp travel/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp travel/pref.lp meta-telingo-extension.lp -c horizon=2 0
#const maxCost=100.

#optimize(time_weak).

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

% does not work:
#preference(p4_alt,more(cardinality)){
    and(finally, holds(has_coffee))
}.

%(time) time = always(taxi <e (drive|bus) <e walk) -> p. 570
#preference(time, more(cardinality)){
    and(initially, always(time_aux))
}.

% time WEAK
#preference(time_weak, more(cardinality)){
    and(initially, always(time_weak_aux))
}.


% (cost) cost = always(walk <e (drive|bus) <e taxi) -> p. 571
#preference(cost, more(cardinality)){
    and(initially, always(cost_aux))
}.

% cost WEAK
#preference(cost_weak, more(cardinality)){
    and(initially, always(cost_weak_aux))
}.


% (comfort) comfort = always(flight <e (drive|bus) <e walk) -> p. 573
#preference(comfort, more(cardinality)){
    and(initially, always(comfort_aux))
}.

% comfort WEAK
#preference(comfort_weak, more(cardinality)){
    and(initially, always(comfort_weak_aux))
}.


% (safety) safety = always(walk <e flight <e (drive | bus)). -> p. 573
#preference(safety, more(cardinality)){
    and(initially, always(safety_aux))
}.

% safety WEAK
#preference(safety_weak, more(cardinality)){
    and(initially, always(safety_weak_aux))
}.

% Ψ1 = comfort > safety -> p. 573
#preference(p5,lexico){1 ::**safety; 2::**comfort}.

%  Ψ2 = cost > time. -> p. 573
#preference(p6,lexico){1 ::**time; 2::**cost}.

% combine these four desires: -> p. 573
#preference(combined, pareto){**p5; **p6}.


% add coffee as a goal in travel.lp! (different action theory) -> p. 579
% (time_coffee) time_coffee = always(occ(buy_coffee) | (take_taxi <e (drive | bus) <e walk)) -> p. 579
#preference(time_coffee, more(cardinality)){
    and(initially, always(time_coffee_aux))
}.

% add coffee as a goal in travel.lp! (different action theory) -> p. 579
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
    **time_coffee
    }.


% for n = 5 (4.4.1)  p. 592
#preference(t(W), more(cardinality)){
    and(initially,sigma(W))} : W = 0..5.

#preference(shortest_formula_based,lexico){
    -W :: **t(W) : W = 0..5
    }.

% for unbound n (4.4.2)-> p. 592
% run with test.lp
% short = always((stop v noop) <e (a1 v ... v ak)).
#preference(shortest_action_based,  more(cardinality)) {
    and(initially, always(short_aux_test))
}.

% cheapest trajectory -> p. 593
#preference(c(W), more(cardinality)){
    eventually(cost_overall(W))}: W = 0..maxCost.

#preference(cheapest,lexico){
    -W :: **c(W) : W = 0..maxCost
    }.

#preference(time_own,more(weight)){
    W :: assigned_weight(time_own, W)
    }.

#preference(cost_own,more(weight)){
    W :: assigned_weight(cost_own, W)
    }.

#preference(comfort_own,more(weight)){
    W :: assigned_weight(comfort_own, W)
    }.

#preference(safety_own,more(weight)){
    W :: assigned_weight(safety_own, W)
    }.


assigned_weight(P, W) :- assigned_weight(P, X, W), #false: assigned_weight(P, Y, Z), Y < X.

assigned_weight(time_own, 1, 10) :- always(time_1).
assigned_weight(time_own, 2, 5) :- always(time_2).
assigned_weight(time_own, 3, 1) :- always(time_3).

assigned_weight(cost_own, 1, 10) :- always(cost_1).
assigned_weight(cost_own, 2, 5) :- always(cost_2).
assigned_weight(cost_own, 3, 1) :- always(cost_3).

assigned_weight(comfort_own, 1, 10) :- always(comfort_1).
assigned_weight(comfort_own, 2, 5) :- always(comfort_2).
assigned_weight(comfort_own, 3, 1) :- always(comfort_3).

assigned_weight(safety_own, 1, 10) :- always(safety_1).
assigned_weight(safety_own, 2, 5) :- always(safety_2).
assigned_weight(safety_own, 3, 1) :- always(safety_3).

%#show assigned_weight/3.
%#show assigned_weight/2.
