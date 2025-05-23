
% FLUENTS

% clingo travel/test.lp travel/auxiliary.lp travel/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp travel/pref.lp meta-telingo-extension.lp -c horizon=1 0
% ACTIONS WITH THEIR EXECUTABILITY CONDITIONS (ACTION PRECONDITION AXIOMS)

action(do_f).
action(wait).

:- prec(A,F,true), occurs(A), not prev(holds(F)).
:- prec(A,F,false), occurs(A), prev(holds(F)).


% ACTIONS WITH THEIR EFFECTS (EFFECTS)
eff(do_f, f, true) :- action(do_f).
executable(do_f).
executable(wait).

% Update by effects
holds(F) :- occurs(A), eff(A, F, true).

{ occurs(A) : action(A), A != stop, A != noop } 1 :- not holds(ended).

% INERTIA
wnext(holds(F)) :- holds(F), not wnext(neg(F)).


% GOAL
holds(goal_achieved) :- holds(f).
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
#external eventually(holds(f)).
#external prev(holds(F)) : prec(A,F,true).
#external wnext(neg(F)) : prec(A,F,true).

#show show(occurs(X)) : action(X).
#show show(holds(F)) : eff(A, F, true).