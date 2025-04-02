% clingo monkey/monkey.lp monkey/instances.lp  0 --output=reify | clingo - meta-telingo.lp -c horizon=2 0 --project
% clingo monkey/monkey.lp monkey/instances.lp monkey/auxiliary.lp monkey/pref-externals.lp  0 --output=reify | asprin - meta-telingo.lp monkey/pref.lp meta-telingo-extension.lp -c horizon=2 0

%#optimize(p2).

% (P1) hasCoconut < hasBanana
#preference(p1,more(cardinality)){eventually(holds(hasBanana))}.

% (P2) banana should be obtained before the chocolate
#preference (p2, more(cardinality)){always(p2_aux)}.

#show show(eventually(p2_aux)) : always(p2_aux).