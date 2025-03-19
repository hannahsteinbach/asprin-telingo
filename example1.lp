% clingo example1.lp pref1-externals.lp  0 --output=reify | asprin - ../../meta/meta-telingo.lp pref1.lp meta-telingo-extension.lp -c length=3 0 -c type="less(cardinality)"

%
% Domain predicates
%

dom(1..2).


%
% Temporal program
%

{next(a(X))}             :- dom(X), initially.
next(next(always(b(X)))) :- a(X).
c(X)                     :- prev(always(b(X))).


%
% Display
%

#show show(a(X)) : dom(X). % corresponds to #show a(X) : a(X), dom(X).
#show show(b(X)) : dom(X). % corresponds to #show b(X) : b(X), dom(X).
#show show(c(X)) : dom(X). % corresponds to #show c(X) : c(X), dom(X).


%
% Externals (for all temporal atoms in the bodies)
%

#external initially.
#external a(X) : dom(X).
#external prev(always(b(X))) : dom(X).

(occurs(walk(frenchRest,home)),4) (occurs(walk(home,frenchRest)),1) (occurs(eat(duck)),3) (occurs(orderRestaurant(duck,frenchRest)),2)