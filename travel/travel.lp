% FLUENTS
% initially (at(home))
holds(at(home)) :- initially.

% initially (has money)
holds(has_money) :-initially.

% initially (available car(home))
holds(available_car(home)) :- initially.


% ACTIONS WITH THEIR EXECUTABILITY CONDITIONS (ACTION PRECONDITION AXIOMS)

% walk(l1, l2) causes at(l2) if at(l1), road(l1, l2)
action(walk(X,Y)) :- road(X,Y).
prec(walk(X, Y), at(X), true) :- action(walk(X,Y)).

% bus(l1, l2) causes at(l2) if at(l1), road(l1, l2)
action(bus(X,Y)) :- bus_station(X), bus_station(Y), road(X,Y).
prec(bus(X, Y), at(X), true) :- action(bus(X,Y)).

% flight(l1, l2) causes at(l2) if at(l1), has_ticket(l1, l2)
action(flight(X,Y)) :- connected(X,Y).
prec(flight(X, Y), at(X), true) :- action(flight(X,Y)).
prec(flight(X, Y), has_ticket(X, Y), true) :- action(flight(X,Y)).

% take_taxi(l1, l2) causes at(l2) if at(l1), road(l1, l2)
action(take_taxi(X,Y)) :- road(X,Y).
prec(take_taxi(X, Y), at(X), true) :- action(take_taxi(X,Y)).

% call_taxi(l) causes available_taxi(l) if has_money
action(call_taxi(X)) :- location(X).
prec(call_taxi(X), has_money, true) :- action(call_taxi(X)).

% rent_car(l) causes available car(l) if has money
action(rent_car(X)) :- location(X).
prec(rent_car(X), has_money, true) :- action(rent_car(X)).

% bus(l1, l2) executable if has money
prec(bus(X, Y), has_money, true) :- action(bus(X,Y)).

% flight(l1, l2) executable if connected(l1, l2)
% prec(flight(X, Y), connected(X,Y), true) :- action(flight(X,Y)).

% take_taxi(l1, l2) executable if available_taxi(l1)
prec(take_taxi(X, Y), available_taxi(X), true) :- action(take_taxi(X,Y)).

% ADD THIS?
action(take_car(X,Y)) :- road(X,Y).
prec(take_car(X, Y), available_car(X), true) :- action(take_car(X,Y)).
prec(take_car(X, Y), at(X), true) :- action(take_car(X,Y)).

% buy ticket(l1, l2) executable if has_money
action(buy_ticket(X,Y)) :- airport(X), airport(Y), X != Y.
prec(buy_ticket(X, Y), has_money, true) :- action(buy_ticket(X,Y)).

% add this
action(buy_coffee).
prec(buy_coffee, has_money, true) :- action(buy_coffee).
prec(buy_coffee, at(coffeeshop), true) :- action(buy_coffee).

:- prec(A,F,true), occurs(A), not prev(holds(F)).


% ACTIONS WITH THEIR EFFECTS (EFFECTS)

% walk(l1, l2) causes at(l2) if at(l1), road(l1, l2)
eff(walk(X,Y), at(Y), true) :- action(walk(X,Y)).
eff(walk(X,Y), at(X), false) :- action(walk(X,Y)).

% bus(l1, l2) causes at(l2) if at(l1), road(l1, l2)
eff(bus(X,Y), at(Y), true) :- action(bus(X,Y)).
eff(bus(X,Y), at(X), false) :- action(bus(X,Y)).

% flight(l1, l2) causes at(l2) if at(l1), has ticket(l1, l2)
eff(flight(X,Y), at(Y), true) :- action(flight(X,Y)).
eff(flight(X,Y), at(X), false) :- action(flight(X,Y)).


% take_taxi(l1, l2) causes at(l2) if at(l1), road(l1, l2)
eff(take_taxi(X,Y), at(Y), true) :- action(take_taxi(X,Y)).
eff(take_taxi(X,Y), at(X), false) :- action(take_taxi(X,Y)).

% buy_ticket(l1, l2) causes has_ticket(l1, l2)
eff(buy_ticket(X,Y), has_ticket(X,Y), true) :- action(buy_ticket(X,Y)).

% call_taxi(l) causes available_taxi(l) if has money
eff(call_taxi(X), available_taxi(X), true) :- action(call_taxi(X)).

% rent_car(l) causes available_car(l) if has money
eff(rent_car(X), available_car(X), true) :- action(rent_car(X)).


% add action buy_coffee (page 567)
eff(buy_coffee, has_coffee, true) :- action(buy_coffee).

% ADD THIS?
% take_taxi(l1, l2) causes at(l2) if at(l1), road(l1, l2)
eff(take_car(X,Y), at(Y), true) :- action(take_car(X,Y)).
eff(take_car(X,Y), at(X), false) :- action(take_car(X,Y)).
eff(flight(X,Y), has_ticket(X,Y), false) :- action(flight(X,Y)).
eff(take_taxi(X,Y), available_taxi(X), false) :- action(take_taxi(X,Y)).
eff(take_car(X,Y), available_car(X), false) :- action(take_car(X,Y)).


% Update by effects
holds(F) :- occurs(A), eff(A, F, true).
neg(F) :- occurs(A), eff(A, F, false).

{occurs(X) : action(X)}1.

wnext(holds(F)) :- holds(F), not wnext(neg(F)).

% holds(F) :- occurs(A), condeffect(A, X, F, true), holds(G) : condition(A,X,G,true);
%                                                 not holds(G) : condition(A,X,G,false).

% neg(F) :- occurs(A), condeffect(A, X, F, false), holds(G) : condition(A,X,G,true);
%                                                 not holds(G) : condition(A,X,G,false).


% GOAL
:- finally, not holds(at(school)).

#external initially.
#external finally.
#external holds(has_coffee).
#external prev(holds(F)) : prec(A,F,true).
#external wnext(neg(F)) : prec(A,F,true).
%#external at(X) : location(X).
#external wnext(neg(F)) : prec(A,F,true).
#external eventually(holds(has_coffee)).


#show show(occurs(X)) : action(X).
%#show show(holds(F)) : eff(A, F, true).
%#show show(holds(at(X))) : location(X).
%#show show(holds(has_money)).