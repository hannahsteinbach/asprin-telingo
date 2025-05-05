% FLUENTS
% initially (at(home))
holds(at(home)) :- initially.

% initially (has money)
holds(has_money) :-initially.

% initially (available car(home))
holds(available_car(home)) :- initially.

holds(sCost(0)) :- initially.
holds(sCost(NC)) :-
    prev(holds(sCost(N))),
    occurs(A),
    cost(A, C),
    num(N), num(C), NC = N + C, num(NC).

wnext(neg(sCost(N))) :-
    holds(sCost(N)),
    wnext(holds(sCost(M))), N != M.


holds(sTime(0)) :- initially.
holds(sTime(NC)) :-
    prev(holds(sTime(N))),
    occurs(A),
    time(A, C),
    num(N), num(C), NC = N + C, num(NC).

% time also proceeds with inaction, but only before goal is achieved.
holds(sTime(N+1)) :-
    prev(holds(sTime(N))),
    not occurs(A),
    not holds(goal_achieved),
    time(A, _), num(N).

wnext(neg(sTime(N))) :-
    holds(sTime(N)),
    wnext(holds(sTime(M))), N != M.


% ACTIONS WITH THEIR EXECUTABILITY CONDITIONS (ACTION PRECONDITION AXIOMS)

% walk(l1, l2) causes at(l2) if at(l1), road(l1, l2)
action(walk(X,Y)) :- road(X,Y).
prec(walk(X, Y), at(X), true) :- action(walk(X,Y)).

wnext(executable(walk)) :- holds(at(X)), action(walk(X,Y)).

% bus(l1, l2) causes at(l2) if at(l1), road(l1, l2)
action(bus(X,Y)) :- bus_station(X), bus_station(Y), road(X,Y).
prec(bus(X, Y), at(X), true) :- action(bus(X,Y)).

% bus(l1, l2) executable if has money
prec(bus(X, Y), has_money, true) :- action(bus(X,Y)).

wnext(executable(bus)) :- holds(at(X)), action(bus(X,Y)), holds(has_money).


% flight(l1, l2) causes at(l2) if at(l1), has_ticket(l1, l2)
% flight(l1, l2) executable if connected(l1, l2)
action(flight(X,Y)) :- connected(X,Y).
prec(flight(X, Y), at(X), true) :- action(flight(X,Y)).
prec(flight(X, Y), has_ticket(X, Y), true) :- action(flight(X,Y)).
wnext(executable(flight)) :- action(flight(X,Y)), holds(at(X)), holds(has_ticket(X, Y)).

% take_taxi(l1, l2) causes at(l2) if at(l1), road(l1, l2)
action(take_taxi(X,Y)) :- road(X,Y).
prec(take_taxi(X, Y), at(X), true) :- action(take_taxi(X,Y)).


% take_taxi(l1, l2) executable if available_taxi(l1)
prec(take_taxi(X, Y), available_taxi(X), true) :- action(take_taxi(X,Y)).

wnext(executable(take_taxi)) :- action(take_taxi(X,Y)), holds(available_taxi(X)), holds(at(X)).

% call_taxi(l) causes available_taxi(l) if has_money
action(call_taxi(X)) :- location(X).
prec(call_taxi(X), has_money, true) :- action(call_taxi(X)).
wnext(executable(call_taxi)) :- action(call_taxi(X)), holds(has_money).

% rent_car(l) causes available car(l) if has money
action(rent_car(X)) :- location(X).
prec(rent_car(X), has_money, true) :- action(rent_car(X)).
wnext(executable(rent_car)) :- action(rent_car(X)), holds(has_money).

% flight(l1, l2) executable if connected(l1, l2)
wnext(executable(flight)) :- action(flight(X, Y)), holds(connected(X,Y)).

% ADD THIS?
action(drive(X,Y)) :- road(X,Y).
prec(drive(X, Y), available_car(X), true) :- action(drive(X,Y)).
prec(drive(X, Y), at(X), true) :- action(drive(X,Y)).
wnext(executable(drive)) :- holds(available_car(X)), holds(at(X)), action(drive(X,Y)).


% buy ticket(l1, l2) executable if has_money
action(buy_ticket(X,Y)) :- airport(X), airport(Y), X != Y.
prec(buy_ticket(X, Y), has_money, true) :- action(buy_ticket(X,Y)).
wnext(executable(buy_ticket)) :- holds(has_money), action(buy_ticket(X,Y)).

% add this
action(buy_coffee).
prec(buy_coffee, has_money, true) :- action(buy_coffee).
prec(buy_coffee, at(coffeeshop), true) :- action(buy_coffee).
wnext(executable(buy_coffee)) :- holds(at(coffeeshop)), holds(has_money).

:- prec(A,F,true), occurs(A), not prev(holds(F)).
:- prec(A,F,false), occurs(A), prev(holds(F)).

%executable(A) :- prec(A,F,true), prev(holds(F)).
%executable(A) :- prec(A,F,false), not prev(holds(F)).

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
eff(drive(X,Y), at(Y), true) :- action(drive(X,Y)).
eff(drive(X,Y), at(X), false) :- action(drive(X,Y)).
eff(flight(X,Y), has_ticket(X,Y), false) :- action(flight(X,Y)).
eff(take_taxi(X,Y), available_taxi(X), false) :- action(take_taxi(X,Y)).
eff(drive(X,Y), available_car(X), false) :- action(drive(X,Y)).
eff(drive(X,Y), available_car(Y), true) :- action(drive(X,Y)). % add this?


% Update by effects
holds(F) :- occurs(A), eff(A, F, true).
neg(F) :- occurs(A), eff(A, F, false).

%{occurs(X) : action(X)}1.
{ occurs(A) : action(A), A != stop, A != noop } 1 :- not holds(ended).

% INERTIA
wnext(holds(F)) :- holds(F), not wnext(neg(F)).

% holds(F) :- occurs(A), condeffect(A, X, F, true), holds(G) : condition(A,X,G,true);
%                                                 not holds(G) : condition(A,X,G,false).

% neg(F) :- occurs(A), condeffect(A, X, F, false), holds(G) : condition(A,X,G,true);
%                                                 not holds(G) : condition(A,X,G,false).


% GOAL
% holds(goal_achieved) :- finally, holds(at(school)). this doesnt work for shortest trajectory, because sigma will always be the horizon even if goal is achieved earlier
holds(goal_achieved) :-  holds(at(school)).

% for preferences time_coffee, cost_coffee, time_n_cost, time_and_cost, time_v_cost, time_or_cost:
%holds(goal_achieved) :- holds(at(school)), holds(has_coffee).
:- finally, not holds(goal_achieved).

% as soon as the goal is achieved, fire stop (once)
wnext(occurs(stop)) :- holds(goal_achieved), not holds(ended).
prec(stop, goal_achieved, true).   % stop executable if goal
wnext(executable(stop)) :- holds(goal_achieved), not holds(ended).


eff(stop, ended,     true).        % stop causes ended

% after ended holds, fire noop every step
wnext(occurs(noop)) :- holds(ended).
prec(noop, ended,    true).        % noop executable if ended
wnext(executable(noop)) :-  holds(ended).

eff(noop, ended, true).        % noop causes ended


#external initially.
#external finally.
#external occurs(stop).
#external wnext(occurs(noop)).
#external holds(ended).
#external eventually(holds(goal_achieved)).
#external eventually(holds(at(school))).
#external holds(has_coffee).
#external prev(holds(sCost(N))) : holds(sCost(N)).
#external wnext(holds(sCost(M))) : holds(sCost(M)).
#external prev(holds(sTime(N))) : holds(sTime(N)).
#external wnext(holds(sTime(M))) : holds(sTime(M)).
#external prev(holds(F)) : prec(A,F,true).
#external wnext(neg(F)) : prec(A,F,true).
#external at(X) : location(X).
#external wnext(neg(F)) : prec(A,F,true).
#external eventually(holds(has_coffee)).

%#show show(holds(goal_achieved)).
%#show show(holds(ended)).
%#show show(occurs(noop)).
%#show show (executable(X)) : occurs(X).
%#show show(neg(holds(ended))).
%#show show(occurs(stop)).
#show show(occurs(X)) : action(X).
%#show show(holds(sCost(N))) : holds(sCost(N)).
%#show show(holds(sTime(N))) : holds(sTime(N)).
%#show show(holds(F)) : eff(A, F, true).
%#show show(holds(at(X))) : location(X).
%#show show(holds(has_money)).