% clingo travel/travel.lp travel/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo travel/travel.lp travel/instances.lp travel/auxiliary.lp travel/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp travel/pref.lp meta-telingo-extension.lp -c horizon=2 0

#optimize(p5).

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

% (time) time = always(taxi <e (drive|bus) <e walk)
#preference(time, less(weight)) {
   W :: assigned_weight(time, W)
}.


% (cost) cost = always(walk <e (drive|bus) <e taxi)
#preference(cost, less(weight)) {
    W :: assigned_weight(cost, W)
}.

% (comfort) comfort = always(walk <e (drive|bus) <e taxi)
#preference(comfort, less(weight)) {
    W :: assigned_weight(comfort, W)
}.

% (safety) safety = always(walk <e flight <e (drive | bus)).
#preference(safety, less(weight)) {
    W :: assigned_weight(safety, W)
}.


% combine preferences: add conjunction, disjunction, negation


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
assigned_weight(time, 1, 0) :- eventually(occurs(take_taxi)). % only for school or overall?
assigned_weight(time, 2, 4) :- eventually(occurs(take_car)).
assigned_weight(time, 2, 4) :- eventually(occurs(bus)).
assigned_weight(time, 3, 5) :-  eventually(occurs(walk)).

preference(cost).
assigned_weight(cost, 1, 0) :- eventually(occurs(walk)).
assigned_weight(cost, 2, 4) :- eventually(occurs(take_car)).
assigned_weight(cost, 2, 4) :- eventually(occurs(bus)).
assigned_weight(cost, 3, 5) :-  eventually(occurs(take_taxi)).

preference(comfort).
assigned_weight(comfort, 1, 0) :- eventually(occurs(flight)).
assigned_weight(comfort, 2, 4) :- eventually(occurs(take_car)).
assigned_weight(comfort, 2, 4) :- eventually(occurs(bus)).
assigned_weight(comfort, 3, 5) :- eventually(occurs(walk)).

preference(safety).
assigned_weight(safety, 1, 0) :- eventually(occurs(walk)).
assigned_weight(safety, 2, 4) :- eventually(occurs(flight)).
assigned_weight(safety, 2, 5) :- eventually(occurs(take_car)).
assigned_weight(safety, 3, 5) :-  eventually(occurs(bus)).

#show assigned_weight/3.