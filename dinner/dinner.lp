% ACTION PRECONDITION AXIOMS

% Poss(drive(x, y), s) ≡ location(x) ∧ location(y) ∧ x != y ∧ at(x, s)
action(drive(X,Y)) :- location(X), location(Y), X != Y.
prec(drive(X, Y), at(X), true) :- action(drive(X,Y)).

% Poss(walk(x, y), s) ≡ location(x) ∧ location(y) ∧ x != y ∧ at(x, s)
action(walk(X,Y)) :- location(X), location(Y), X != Y.
prec(walk(X, Y), at(X), true) :- action(walk(X,Y)).

% Poss(cook(x), s) ≡ meal(x) ∧ knowsHowToMake(x) ∧ at(home, s) ∧ hasIngredients(x, s) ∧ kitchenClean(s)
action(cook(X)) :- knowsHowToMake(X), meal(X).
prec(cook(X), at(home), true) :- action(cook(X)).
prec(cook(X), hasIngredients(X), true) :- action(cook(X)).
prec(cook(X), kitchenClean, true) :- action(cook(X)).


% Poss(eat(x), s) ≡ meal(x) ∧ (∃y(at(y, s) ∧ readyToEat(x, y, s)))
action(eat(X)) :- meal(X).


prec(eat(X), readyToEat(X,Y), true) : holds(at(Y)) :- action(eat(X)).

%Poss(buyIngredients(x), s) ≡ meal(x) ∧ ¬hasIngredients(x) ∧ at(store, s)
action(buyIngredients(X)) :- meal(X).
prec(buyIngredients(X), at(store), true) :- action(buyIngredients(X)).
prec(buyIngredients(X), holds(hasIngredients(X)), false) :- action(buyIngredients(X)).

% Poss(orderTakeout(x, y), s) ≡ meal(x) ∧ takeOutRest(y) ∧ onMenu(x, y) ∧ at(home, s)
action(orderTakeout(X,Y)) :- meal(X), takeOutRest(Y), onMenu(X,Y).
prec(orderTakeout(X,Y), at(home), true) :- action(orderTakeout(X,Y)).

% Poss(orderRestaurant(x, y), s) ≡ meal(x) ∧ dineInRest(y) ∧ onMenu(x, y) ∧ at(y, s)
action(orderRestaurant(X,Y)) :- meal(X), dineInRest(Y), onMenu(X,Y).
prec(orderRestaurant(X,Y), at(Y), true) :- action(orderRestaurant(X,Y)).

% Poss(cleanDishes, s) ≡ at(home, s)
action(cleanDishes).
prec(cleanDishes, at(home), true) :- action(cleanDishes).

:- prec(A,F,true), occurs(A), not prev(holds(F)).


% EFFECTS

% a = drive(x, y) → at(y, do(a, s))
eff(drive(X,Y), at(Y), true) :- action(drive(X,Y)).

% a = drive(x, y) → ¬at(x, do(a, s))
eff(drive(X,Y), at(X), false) :- action(drive(X,Y)).

% a = walk(x, y) → at(y, do(a, s))
eff(walk(X,Y), at(Y), true) :- action(walk(X,Y)).

% a = walk(x, y) → ¬at(x, do(a, s))
eff(walk(X,Y), at(X), false) :- action(walk(X,Y)).

% isSnowing(s) ∧ a = walk(x, y) → cold(do(a, s))
condeffect(walk(X,Y), (), cold, true) :- action(walk(X,Y)).
condition(walk(X,Y), (), isSnowing, true) :- action(walk(X,Y)).

% a = cook(x) → readyToEat(x, home, do(a, s))
eff(cook(X), readyToEat(X, home), true) :- action(cook(X)).

% a = cook(x) → ¬hasIngredients(x, do(a, s))
eff(cook(X), hasIngredients(X), false) :- action(cook(X)).

% a = cook(x) → ¬kitchenClean(do(a, s))
eff(cook(X), kitchenClean, false) :- action(cook(X)).

% a = eat(x) → sated(do(a, s))
eff(eat(X), sated, true) :- action(eat(X)).

% at(y, s) ∧ a = eat(x) → ¬readyToEat(x, y, do(a, s))
condeffect(eat(X), (Y), readyToEat(X,Y), false) :- action(eat(X)), location(Y).
condition(eat(X), (Y), at(Y), true) :- location(Y), action(eat(X)).

% a = buyIngredients(x) → hasIngredients(x, do(a, s))
eff(buyIngredients(X), hasIngredients(X), true) :- action(buyIngredients(X)).

% a = orderTakeout(x, y) → readyToEat(x, home, do(a, s))
eff(orderTakeout(X,Y), readyToEat(X,home), true) :- action(orderTakeout(X,Y)).

% a = orderRestaurant(x, y) → readyToEat(x, y, do(a, s))
eff(orderRestaurant(X,Y), readyToEat(X,Y), true) :- action(orderRestaurant(X,Y)).

% a = cleanDishes → kitchenClean(do(a, s))
eff(cleanDishes, kitchenClean, true) :- action(cleanDishes).

% FLUENTS
% at(home, S0)
holds(at(home)) :- initially.

% kitchenClean(S0)
holds(kitchenClean) :-initially.

% hasIngredients(crêpes, S0)
%0{holds(hasIngredients(crepes)); holds(hasIngredients(spaghetti))}1 :- initially.
holds(hasIngredients(crepes)) :- initially.


{holds(isSnowing)}.

% actions (these are all choices)
{occurs(X) : action(X)}1.



% Her goal is to be at home with her hunger sated
:- not eventually(holds(sated)).
:- finally, not holds(at(home)).

% Inertia
% wnext(holds(F)) :- holds(F), not neg(F).
% holds(F) :- prev(holds(F)), not neg(F).
wnext(holds(F)) :- holds(F), not wnext(neg(F)).


% Update by effects
holds(F) :- occurs(A), eff(A, F, true).
neg(F) :- occurs(A), eff(A, F, false).

holds(F) :- occurs(A), condeffect(A, X, F, true), holds(G) : condition(A,X,G,true);
                                                  not holds(G) : condition(A,X,G,false).

neg(F) :- occurs(A), condeffect(A, X, F, false), holds(G) : condition(A,X,G,true);
                                                 not holds(G) : condition(A,X,G,false).

% could write F as condeffect without conditions

#external initially.
#external finally.
#external eventually(holds(sated)).
%#external walk(X,Y) : location(X), location(Y).
#external drive(X,Y) : location(X), location(Y).
%#external cook(X) : meal(X).
%#external eat(X) : meal(X).
%#external hasIngredients(X) : meal(X).
%#external buyIngredients(X) : meal(X).
%#external orderTakeout(X,Y) : meal(X), takeOutRest(Y).
%#external orderRestaurant(X,Y) : meal(X), dineInRest(Y).
%#external readyToEat(X,Y) : eat(X), at(Y).
%#external holds(readyToEat(X,Y)) : readyToEat(X,Y).
%#external cleanDishes.
%#external kitchenClean.
#external isSnowing.
#external at(X) : location(X).
#external prev(holds(F)) : prec(A,F,true).
%#external prev(neg(F)) : prec(A,F,true).
#external wnext(neg(F)) : prec(A,F,true).
#external condition(A,X,G,false) : action(A), location(X), at(G). % do we need this?

% show statements
%#show show(holds(F)) : eff(A, F, true).
%#show show(holds(kitchenClean)).
%#show show(neg(kitchenClean)).
%#show show(neg(F)) : eff(A, F, true).
#show show(occurs(X)) : action(X).
%#show show(occurs(eat(X))) : action(eat(X)).
%#show show(holds(isSnowing)).
%#show show(holds(hasIngredients(X))) : meal(X).
