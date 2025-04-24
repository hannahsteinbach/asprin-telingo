% clingo travel/travel.lp travel/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo travel/travel.lp travel/instances.lp travel/auxiliary.lp travel/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp travel/pref.lp meta-telingo-extension.lp -c horizon=2 0

#optimize(shortest_action_based).

% (P1) eventually(occ(bus(home,school)) | occ(taxi(home,school))).-> p. 566.
#preference(p1,less(weight)){
    W :: assigned_weight(p1, W)
}.

% (P2) always(¬occ(call_taxi(home))) -> p. 566.
#preference(p2,less(weight)){
    W :: assigned_weight(p2, W)
}.

% (P3) always(¬available_taxi(home)) -> p. 566.
#preference(p3,less(weight)){
    W :: assigned_weight(p3, W)
}.

% (P4) goal(has_coffee). -> p. 569
#preference(p4,less(weight)){
    W :: assigned_weight(p4, W)
}.

%(time) time = always(taxi <e (drive|bus) <e walk) -> p. 570
#preference(time, less(weight)) {
   W :: assigned_weight(time, W)
}.


% (cost) cost = always(walk <e (drive|bus) <e taxi) -> p. 571
#preference(cost, less(weight)) {
    W :: assigned_weight(cost, W)
}.

% (comfort) comfort = always(flight <e (drive|bus) <e walk) -> p. 573
#preference(comfort, less(weight)) {
    W :: assigned_weight(comfort, W)
}.

% (safety) safety = always(walk <e flight <e (drive | bus)). -> p. 573
#preference(safety, less(weight)) {
    W :: assigned_weight(safety, W)
}.


% Ψ1 = comfort > safety -> p. 573
#preference(p5,lexico){1 ::**safety; 2::**comfort}.

%  Ψ2 = cost > time. -> p. 573
#preference(p6,lexico){1 ::**time; 2::**cost}.

% combine these four desires: -> p. 573
#preference(combined, pareto){**p5; **p6}.

% Ψ1 = time n cost (is this actually v?) -> p. 579
#preference(p7,and){ **time; **cost}.

% Ψ2 = time & cost. -> p. 579
#preference(p8,pareto){ **time; **cost}.


% TO DO: v (or n) and | more intricate, how to handle several transportation measures?
% Ψ3 = time u cost -> p. 580


% Ψ4 = time | cost -> p. 580
#preference(time_disj, less(weight)){
    W :: assigned_weight(time_disj, W)
    }.

#preference(cost_disj, less(weight)){
    W :: assigned_weight(cost_disj, W)
    }.

#preference(trajectory_disj,pareto){ **time_disj; **cost_disj}.

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
#preference(shortest_formula_based,less(weight)){
    W :: always(sigma(W))
    }.

% for unbound n (4.4.2)-> how to compare directly?  p. 592
#preference(shortest_action_based,  more(cardinality)) {
    true(occurs(stop_noop), T) : time(T)
}.

% cheapest trajectory -> p. 593
#preference(cheapest,less(weight)){
    W :: cost_overall(W)
    }.

% combine coffee and cheapest, prioritize getting coffee
#preference(p9,lexico){
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

preference(time).
assigned_weight(time, 1, 0) :- eventually(occurs(take_taxi)).
assigned_weight(time, 2, 4) :- eventually(occurs(take_car)).
assigned_weight(time, 2, 4) :- eventually(occurs(bus)).
assigned_weight(time, 3, 5) :-  eventually(occurs(walk)).
assigned_weight(time, 4, 10) :-  eventually(occurs(flight)). % how to handle this, not part of the ranking at all

preference(cost).
assigned_weight(cost, 1, 0) :- eventually(occurs(walk)).
assigned_weight(cost, 2, 4) :- eventually(occurs(take_car)).
assigned_weight(cost, 2, 4) :- eventually(occurs(bus)).
assigned_weight(cost, 3, 5) :-  eventually(occurs(take_taxi)).
assigned_weight(cost, 4, 10) :-  eventually(occurs(flight)).

preference(comfort).
assigned_weight(comfort, 1, 0) :- eventually(occurs(flight)).
assigned_weight(comfort, 2, 4) :- eventually(occurs(take_car)).
assigned_weight(comfort, 2, 4) :- eventually(occurs(bus)).
assigned_weight(comfort, 3, 5) :- eventually(occurs(walk)).
assigned_weight(comfort, 4, 10) :- eventually(occurs(take_taxi)).

preference(safety).
assigned_weight(safety, 1, 0) :- eventually(occurs(walk)).
assigned_weight(safety, 2, 4) :- eventually(occurs(flight)).
assigned_weight(safety, 3, 5) :- eventually(occurs(take_car)).
assigned_weight(safety, 3, 5) :-  eventually(occurs(bus)).
assigned_weight(safety, 4, 10) :- eventually(occurs(take_taxi)).


% shortest trajectory
time_of_goal(I) :- true(holds(goal_achieved), I),
                   not true(holds(goal_achieved), J) : time(J), J < I.



% cheapest trajectory
cost_overall(C) :- true(holds(sCost(C)), horizon).


% disjuncion general preference
transport_mode(take_taxi; take_car; bus; walk; flight).
transportation(A) :- eventually(occurs(A)), transport_mode(A).

preference(time_disj).
assigned_weight(time_disj, 1, 0) :- not transportation(X) : transport_mode(X), X != take_taxi.
assigned_weight(time_disj, 2, 10) :- transportation(X), X != take_taxi.

preference(cost_disj).
assigned_weight(cost_disj, 1, 0) :- not transportation(X) : transport_mode(X), X != walk.
assigned_weight(cost_disj, 2, 10) :- transportation(X), X != walk.


%#show assigned_weight/3.
#show assigned_weight/2.
#show cost_overall/1.
#show time_of_goal/1.