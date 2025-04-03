% FLUENTS

% 2: ceiling, 3: floor, 4: drawer
holds(at(monkey, 1)) :- initially.
holds(at(banana, 2)) :- initially.
holds(at(coconut, 3)) :- initially.
holds(at(drawer, 4)) :- initially.
holds(at(chocolate, 4)) :- initially.
holds(at(box, 5)) :- initially.

% ACTIONS WITH THEIR EXECUTABILITY CONDITIONS (ACTION PRECONDITION AXIOMS)
action(walk(X,Y)) :- location(X), location(Y), X != Y.
prec(walk(X,Y), at(monkey, Y), false) :- action(walk(X,Y)).
prec(walk(X,Y), at(monkey, X), true) :- action(walk(X,Y)).
prec(walk(X,Y), onBox, false) :- action(walk(X,Y)).

action(push(X,Y)) :- location(X), location(Y), X!=Y.
prec(push(X,Y), at(monkey,X), true) :- action(push(X,Y)).
prec(push(X,Y), at(box,X), true) :- action(push(X,Y)).
prec(push(X,Y), onBox, false) :- action(push(X,Y)).


action(climb).
prec(climb, onBox, false) :- action(climb).
prec(climb, at(monkey,X), true) :- action(climb), holds(at(box,X)).

action(descend).
prec(descend, onBox, true) :- action(descend).

action(grasp).
prec(grasp, onBox, true) :- action(grasp).
prec(grasp, at(monkey, X), true) : holds(at(box,X)) :- action(grasp).
prec(grasp, at(banana, X), true) : holds(at(box,X)) :- action(grasp).

action(open).
prec(open, drawerOpen, false) :- action(open).
prec(open, at(monkey,X), true) : holds(at(drawer,X)) :- action(open).

action(take_chocolate).
prec(take_chocolate, drawerOpen, true) :- action(take_chocolate).
prec(take_chocolate, at(monkey, X), true) : holds(at(chocolate,X)) :- action(take_chocolate).


action(take_coconut).
prec(take_coconut, at(monkey, X) , true) : holds(at(coconut,X)) :- action(take_coconut).

:- prec(A,F,true), occurs(A), not prev(holds(F)).
:- prec(A,F,false), occurs(A), prev(holds(F)).

% ACTIONS WITH THEIR EFFECTS (EFFECTS)
eff(walk(X,Y), at(monkey, Y), true) :- action(walk(X,Y)).
eff(walk(X,Y), at(monkey, X), false) :- action(walk(X,Y)).

eff(push(X,Y), at(monkey, Y), true) :- action(push(X,Y)).
eff(push(X,Y), at(box, Y), true) :- action(push(X,Y)).

eff(push(X,Y), at(monkey, X), false) :- action(push(X,Y)).
eff(push(X,Y), at(box, X), false) :- action(push(X,Y)).

eff(grasp, hasBanana, true) :- action(grasp).

eff(climb, onBox, true) :- action(climb).

eff(descend, onBox, false) :- action(descend).

eff(open, drawerOpen, true) :- action(open).

eff(take_coconut, hasCoconut, true) :- action(take_coconut).

eff(take_chocolate, hasChocolate, true) :- action(take_chocolate).

% Update by effects
holds(F) :- occurs(A), eff(A, F, true).
neg(F) :- occurs(A), eff(A, F, false).

{occurs(X) : action(X)}1.

% Inertia
wnext(holds(F)) :- holds(F), not wnext(neg(F)).

% GOAL
:- finally, not holds(hasChocolate).
:- finally, not holds(hasBanana), not holds(hasCoconut).


#external initially.
#external finally.
#external prev(holds(F)) : prec(A,F,true).
#external wnext(neg(F)) : prec(A,F,true).
%#external at(X) : location(X).
#external wnext(neg(F)) : prec(A,F,true).


#show show(occurs(X)) : action(X).
%#show show(holds(at(X, Y))) : entity(X), location(Y).
%#show show(holds(F)) : eff(A, F, true).
%#show show(holds(F)) : eff(A, F, false).
%#show show(holds(at(Y,X))) : entity(Y), location(X).
%#show show(holds(has_money)).