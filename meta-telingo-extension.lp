% Connective rules for initialization

and(X, Y) :- true(and(X, Y), 0).
or(X, Y) :- true(or(X, Y), 0).
if(X, Y) :- true(if(X, Y), 0).
prev(X) :- true(prev(X), 0).
next(X) :- true(next(X), 0).
wprev(X) :- true(wprev(X), 0).
wnext(X) :- true(wnext(X), 0).
until(X, Y) :- true(until(X, Y), 0).
since(X, Y) :- true(since(X, Y), 0).
release(X, Y) :- true(release(X, Y), 0).
trigger(X, Y) :- true(trigger(X, Y), 0).
while(X, Y) :- true(while(X, Y), 0).
while_before(X, Y) :- true(while_before(X, Y), 0).
eventually(X) :- true(eventually(X), 0).
eventually_before(X) :- true(eventually_before(X), 0).
always(X) :- true(always(X), 0).
always_before(X) :- true(always_before(X), 0).
negation(X) :- true(negation(X), 0).