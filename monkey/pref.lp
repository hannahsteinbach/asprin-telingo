% clingo monkey/monkey.lp monkey/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo monkey/monkey.lp monkey/instances.lp monkey/auxiliary.lp monkey/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp monkey/pref.lp meta-telingo-extension.lp -c horizon=2 0

#optimize(p2).

% (P1) eventually(hasBanana) > eventually(hasCoconut). -> p. 594
#preference(hasBanana, more(cardinality)){
    eventually(banana_aux)}.

#preference(hasChocolate, more(cardinality)){
    eventually(chocolate_aux)}.

#preference(p1,lexico){1 ::**hasChocolate; 2::**hasBanana}.


% (P2) eventually(hasBanana n eventually(hasChocolate)) n until(not hasChocolate, hasBanana) -> p. 595
%  -> obtain banana before chocolate

#preference(p2,more(cardinality)){
    and(and(eventually(holds(hasBanana)),
    eventually(holds(hasChocolate))),
    until(negation(holds(hasChocolate)), holds(hasBanana)))
    }.
