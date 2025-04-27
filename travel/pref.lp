% clingo travel/travel.lp travel/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo travel/travel.lp travel/instances.lp travel/auxiliary.lp travel/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp travel/pref.lp meta-telingo-extension.lp -c horizon=2 0

#optimize(safety).

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

% Transportation preferences
#preference(taxi, more(cardinality)) {
    eventually(occurs(take_taxi))
}.

#preference(take_car, more(cardinality)) {
    eventually(occurs(take_car))
}.

#preference(bus, more(cardinality)) {
    eventually(occurs(bus))
}.

#preference(walk, more(cardinality)) {
    eventually(occurs(walk))
}.

#preference(flight, more(cardinality)) {
    eventually(occurs(flight))
}.

% Negated transportation preferences
#preference(taxi_neg, less(cardinality)) {
    eventually(occurs(take_taxi))
}.

#preference(take_car_neg, less(cardinality)) {
    eventually(occurs(take_car))
}.

#preference(bus_neg, less(cardinality)) {
    eventually(occurs(bus))
}.

#preference(walk_neg, less(cardinality)) {
    eventually(occurs(walk))
}.

#preference(flight_neg, less(cardinality)) {
    eventually(occurs(flight))
}.


%(time) time = always(taxi <e (drive|bus) <e walk) -> p. 570
% taxi <e (drive|bus)
#preference(time_taxi, pareto){**taxi; **take_car_neg; **bus_neg; **flight_neg; **walk_neg}.
% #preference(time_taxi, pareto){**taxi; **take_car_neg; **bus_neg; **flight_neg; **walk_neg}.

% (drive|bus)
#preference(car_bus, less(weight)) {
    W :: assigned_weight(car_bus, W)
}.
% rewrite this so i dont have to use pareto?? maybe? idk yet
% (drive|bus) <e walk)
#preference(time_take_car_bus, pareto){**car_bus; **walk_neg}.
#preference(time, lexico){
    4 :: **time_taxi;
    3 :: **time_take_car_bus;
    2 :: **walk;
    1 :: **flight
 }. %exclude flight?


% (cost) cost = always(walk <e (drive|bus) <e taxi) -> p. 571
% walk <e (drive|bus)
#preference(cost_walk, pareto){**walk; **take_car_neg; **bus_neg}.

% (drive|bus) <e taxi
#preference(cost_take_car_bus, pareto){**car_bus; **taxi_neg}.

#preference(cost, lexico){
    3 :: **cost_walk;
    2 :: **cost_take_car_bus;
    1 :: **taxi
 }.


% (comfort) comfort = always(flight <e (drive|bus) <e walk) -> p. 573
% flight <e (drive|bus)
#preference(comfort_flight, pareto){**flight; **take_car_neg; **bus_neg}.

% (drive|bus) <e walk)
#preference(comfort_take_car_bus, pareto){**car_bus; **walk_neg}.

#preference(comfort, lexico){
    3 :: **comfort_flight;
    2 :: **comfort_take_car_bus;
    1 :: **walk
 }.


% (safety) safety = always(walk <e flight <e (drive | bus)). -> p. 573
% walk <e flight
#preference(safety_walk, pareto){**walk; **flight_neg}.

% flight <e (drive | bus)
#preference(safety_flight, pareto){**flight; **take_car_neg; **bus_neg}.

#preference(safety, lexico){
    3 :: **safety_walk;
    2 :: **safety_flight;
    1 :: **car_bus
 }.



% Ψ1 = comfort > safety -> p. 573
#preference(p5,lexico){1 ::**safety; 2::**comfort}.

%  Ψ2 = cost > time. -> p. 573
#preference(p6,lexico){1 ::**time; 2::**cost}.

% combine these four desires: -> p. 573
#preference(combined, pareto){**p5; **p6}.

% Ψ1 = time n cost  -> p. 579
#preference(time_cost_conj, less(weight)){
    W :: assigned_weight(time_cost_conj, W)
    }.

% Ψ2 = time & cost. -> p. 579
#preference(trajectory_conj,and){ **time_general; **cost_general}.


% TO DO: v (or n) and | more intricate, how to handle several transportation measures?
% Ψ3 = time u cost -> p. 580, must have either taxi or walk (or both)
#preference(time_cost_disj, less(weight)){
    W :: assigned_weight(time_cost_disj, W)
    }.

% Ψ4 = time | cost -> p. 580
#preference(time_general, less(weight)){
    W :: assigned_weight(time_general, W)
    }.

#preference(cost_general, less(weight)){
    W :: assigned_weight(cost_general, W)
    }.

#preference(trajectory_disj,pareto){ **time_general; **cost_general}.

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

preference(time).
assigned_weight(time, 1, 0) :- eventually(occurs(take_taxi)),
                               not eventually(occurs(take_car)),
                               not eventually(occurs(bus)),
                               not eventually(occurs(walk)),
                               not eventually(occurs(flight)).
assigned_weight(time, 2, 4) :- eventually(occurs(take_car)),
                               not eventually(occurs(walk)),
                               not eventually(occurs(flight)).
assigned_weight(time, 2, 4) :- eventually(occurs(bus)),
                               not eventually(occurs(walk)),
                               not eventually(occurs(flight)).
assigned_weight(time, 3, 5) :- eventually(occurs(walk)),
                               not eventually(occurs(flight)).
assigned_weight(time, 4, 10) :-  eventually(occurs(flight)). % how to handle this, not part of the ranking at all


preference(cost).
assigned_weight(cost, 1, 0) :- eventually(occurs(walk)),
                               not eventually(occurs(take_taxi)),
                               not eventually(occurs(take_car)),
                               not eventually(occurs(bus)),
                               not eventually(occurs(flight)).
assigned_weight(cost, 2, 4) :- eventually(occurs(take_car)),
                               not eventually(occurs(take_taxi)),
                               not eventually(occurs(flight)).
assigned_weight(cost, 2, 4) :- eventually(occurs(bus)),
                               not eventually(occurs(take_taxi)),
                               not eventually(occurs(flight)).
assigned_weight(cost, 3, 5) :-  eventually(occurs(take_taxi)),
                                not eventually(occurs(flight)).
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

% basic desires
preference(time_cost_disj).
assigned_weight(time_cost_disj, 1, 0) :- not transportation(X) : transport_mode(X), X != take_taxi, X != walk.
assigned_weight(time_cost_disj, 2, 10) :- transportation(X), X != take_taxi, X!= walk.

% Ensure both actions (take_taxi and walk) are in the trajectory.
assigned_weight(time_cost_conj, 2, 10) :- transportation(X), X != walk.
assigned_weight(time_cost_conj, 2, 10) :- transportation(X), X != take_taxi.


% general preferences
transport_mode(take_taxi; take_car; bus; walk; flight).
transportation(A) :- eventually(occurs(A)), transport_mode(A).

preference(time_general).
assigned_weight(time_general, 1, 0) :- not transportation(X) : transport_mode(X), X != take_taxi.
assigned_weight(time_general, 2, 10) :- transportation(X), X != take_taxi.

preference(cost_general).
assigned_weight(cost_general, 1, 0) :- not transportation(X) : transport_mode(X), X != walk.
assigned_weight(cost_general, 2, 10) :- transportation(X), X != walk.

not eventually(occurs(walk)).
#show assigned_weight/3.
%#show assigned_weight/2.
%#show cost_overall/1.
%#show time_of_goal/1.