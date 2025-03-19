%
% Meta-encoding using hold(A,T)
%

conjunction(B,T) :- literal_tuple(B), time(T),
        hold(L,T) : literal_tuple(B, L), L > 0;
    not hold(L,T) : literal_tuple(B,-L), L > 0.

body(normal(B),T) :- rule(_,normal(B)), conjunction(B,T), time(T).
body(sum(B,G),T)  :- rule(_,sum(B,G)), time(T),
    #sum { W,L :     hold(L,T), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,T), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,T) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,T), time(T).
{ hold(A,T) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,T), time(T).

time(0..length).

#show.
#show (S,T) : output(show(S),_), true(S,T).


%
% Connect true/2 with hold/2
%

true(O,T) :- output(O,B), time(T), hold(L,T) : literal_tuple(B,L).
hold(L,T) :- output(O,B), time(T), true(O,T),  literal_tuple(B,L).


%
% formulas from output
%
formula(O) :- output(O,_).


%
% Logical connectives using true/2
%

%  bot
formula(bot).
:- true(bot,K).

% and
formula(A) :- formula(and(A,B)).
formula(B) :- formula(and(A,B)).
%
true(and(A,B),K) :- true(A,K), true(B,K), time(K), formula(and(A,B)).
true(A,K)            :- true(and(A,B),K), time(K), formula(and(A,B)).
true(B,K)            :- true(and(A,B),K), time(K), formula(and(A,B)).

% or
formula(A) :- formula(or(A,B)).
formula(B) :- formula(or(A,B)).
%
true(or(A,B),K)             :- true(A,K), time(K), formula(or(A,B)).
true(or(A,B),K)             :- true(B,K), time(K), formula(or(A,B)).
true(A,K) | true(B,K) :- true(or(A,B),K), time(K), formula(or(A,B)).

% if
formula(A) :- formula(if(A,B)).
formula(B) :- formula(if(A,B)).
%
true(if(A,B),K) :- true(B,K) : true(A,K); time(K), formula(if(A,B)).
true(B,K)  :- true(A,K), true(if(A,B),K), time(K), formula(if(A,B)).


%
% Temporal connectives using true/2
%

% initially
true(initially,K)  :- #false : time(X), X=K-1; time(K), formula(initially).
:- true(initially,K),          time(X), X=K-1, time(K), formula(initially).
%
% finally (replace - by + in initially)
true(finally,K)    :- #false : time(X), X=K+1; time(K), formula(finally).
:- true(finally,K),            time(X), X=K+1, time(K), formula(finally).

% prev
formula(A) :- formula(prev(A)).
%
          :- true(prev(A),K), not time(X), X=K-1, time(K), formula(prev(A)).
true(A,X) :- true(prev(A),K),     time(X), X=K-1, time(K), formula(prev(A)).
true(prev(A),K) :- true(A,X),     time(X), X=K-1, time(K), formula(prev(A)).
%
% next (replace - by + in prev)
formula(A) :- formula(next(A)).
%
          :- true(next(A),K), not time(X), X=K+1, time(K), formula(next(A)).
true(A,X) :- true(next(A),K),     time(X), X=K+1, time(K), formula(next(A)).
true(next(A),K) :- true(A,X),     time(X), X=K+1, time(K), formula(next(A)).

% wprev
formula(A) :- formula(wprev(A)).
%
true(A,X)  :- true(wprev(A),K), time(X), X=K-1, time(K), formula(wprev(A)).
true(wprev(A),K) :- true(A,X) : time(X), X=K-1; time(K), formula(wprev(A)).
%
% wnext (replace - by + in wprev)
formula(A) :- formula(wnext(A)).
%
true(A,X)  :- true(wnext(A),K), time(X), X=K+1, time(K), formula(wnext(A)).
true(wnext(A),K) :- true(A,X) : time(X), X=K+1; time(K), formula(wnext(A)).

% until
formula(A) :- formula(until(A,B)).
formula(B) :- formula(until(A,B)).
%
true(until(A,B),K,X) : time(X), K<=X :- true(until(A,B),K),   time(K), formula(until(A,B)).
true(until(A,B),K)  :- time(X), K<=X,   true(until(A,B),K,X), time(K), formula(until(A,B)).
%
% true(until(A,B),K,X)
true(A,Y) :- time(Y), K<=Y, Y<X, true(until(A,B),K,X), time(X), K<=X, time(K), formula(until(A,B)).
true(B,X)                     :- true(until(A,B),K,X), time(X), K<=X, time(K), formula(until(A,B)).
true(until(A,B),K,X)                                :- time(X), K<=X, time(K), formula(until(A,B)),
                                                         true(A,Y) : time(Y), K<=Y, Y<X; true(B,X).
%
% since (replace < by > in until)
formula(A) :- formula(since(A,B)).
formula(B) :- formula(since(A,B)).
%
true(since(A,B),K,X) : time(X), K>=X :- true(since(A,B),K),   time(K), formula(since(A,B)).
true(since(A,B),K) :-  time(X), K>=X,   true(since(A,B),K,X), time(K), formula(since(A,B)).
%
% true(since(A,B),K,X)
true(A,Y) :- time(Y), K>=Y, Y>X, true(since(A,B),K,X), time(X), K>=X, time(K), formula(since(A,B)).
true(B,X)                     :- true(since(A,B),K,X), time(X), K>=X, time(K), formula(since(A,B)).
true(since(A,B),K,X)                                :- time(X), K>=X, time(K), formula(since(A,B)),
                                                         true(A,Y) : time(Y), K>=Y, Y>X; true(B,X).

% release
formula(A) :- formula(release(A,B)).
formula(B) :- formula(release(A,B)).
%
true(release(A,B),K,X) :- true(release(A,B),K),    time(X), K<=X, time(K), formula(release(A,B)).
true(release(A,B),K)   :- true(release(A,B),K,X) : time(X), K<=X; time(K), formula(release(A,B)).
%
% true(release(A,B),K,X)
true(B,X) | true(A,Y) : time(Y), K<=Y, Y<X :- true(release(A,B),K,X), time(X), K<=X, time(K), formula(release(A,B)).
true(release(A,B),K,X)              :- true(B,X),                     time(X), K<=X, time(K), formula(release(A,B)).
true(release(A,B),K,X)              :- true(A,Y), time(Y), K<=Y, Y<X, time(X), K<=X, time(K), formula(release(A,B)).
%
% trigger (replace < by > in since)
formula(A) :- formula(trigger(A,B)).
formula(B) :- formula(trigger(A,B)).
%
true(trigger(A,B),K,X) :- true(trigger(A,B),K),    time(X), K>=X, time(K), formula(trigger(A,B)).
true(trigger(A,B),K)   :- true(trigger(A,B),K,X) : time(X), K>=X; time(K), formula(trigger(A,B)).
%
% true(trigger(A,B),K,X)
true(B,X) | true(A,Y) : time(Y), K>=Y, Y>X :- true(trigger(A,B),K,X), time(X), K>=X, time(K), formula(trigger(A,B)).
true(trigger(A,B),K,X)              :- true(B,X),                     time(X), K>=X, time(K), formula(trigger(A,B)).
true(trigger(A,B),K,X)              :- true(A,Y), time(Y), K>=Y, Y>X, time(X), K>=X, time(K), formula(trigger(A,B)).

% while
formula(A) :- formula(while(A,B)).
formula(B) :- formula(while(A,B)).
%
true(A,X)  :- true(while(B),K,X), true(while(A,B),K), time(X), K<=X, time(K), formula(while(A,B)).
true(while(A,B),K) :- true(A,X) : true(while(B),K,X), time(X), K<=X; time(K), formula(while(A,B)).
%
% true(while(B),K,X)
true(B,Y)  :- true(while(B),K,X), time(Y), K<=Y, Y<X, time(X), K<=X, time(K), formula(while(_,B)).
true(while(B),K,X) :- true(B,Y) : time(Y), K<=Y, Y<X; time(X), K<=X, time(K), formula(while(_,B)).
%
% while_before (replace < by > in while)
formula(A) :- formula(while_before(A,B)).
formula(B) :- formula(while_before(A,B)).
%
true(A,X)  :- true(while_before(B),K,X), true(while_before(A,B),K), time(X), K>=X, time(K), formula(while_before(A,B)).
true(while_before(A,B),K) :- true(A,X) : true(while_before(B),K,X), time(X), K>=X; time(K), formula(while_before(A,B)).
%
% true(while_before(B),K,X)
true(B,Y)  :- true(while_before(B),K,X), time(Y), K>=Y, Y>X, time(X), K>=X, time(K), formula(while_before(_,B)).
true(while_before(B),K,X) :- true(B,Y) : time(Y), K>=Y, Y>X; time(X), K>=X, time(K), formula(while_before(_,B)).


% eventually
formula(A) :- formula(eventually(A)).
%
true(A,X) : time(X), K<=X :- true(eventually(A),K), time(K), formula(eventually(A)).
true(eventually(A),K)  :- time(X), K<=X, true(A,X), time(K), formula(eventually(A)).
%
% eventually_before (replace < by > in eventually)
formula(A) :- formula(eventually_before(A)).
%
true(A,X) : time(X), K>=X :- true(eventually_before(A),K), time(K), formula(eventually_before(A)).
true(eventually_before(A),K)  :- time(X), K>=X, true(A,X), time(K), formula(eventually_before(A)).

% always
formula(A) :- formula(always(A)).
%
true(A,X)  :- true(always(A),K), time(X), K<=X, time(K), formula(always(A)).
true(always(A),K) :- true(A,X) : time(X), K<=X; time(K), formula(always(A)).
%
% always_before (replace < by > in always)
formula(A) :- formula(always_before(A)).
%
true(A,X)  :- true(always_before(A),K), time(X), K>=X, time(K), formula(always_before(A)).
true(always_before(A),K) :- true(A,X) : time(X), K>=X; time(K), formula(always_before(A)).


%
% Defined predicates
%

#defined literal_tuple/1.
#defined literal_tuple/2.
#defined rule/2.
#defined atom_tuple/2.
#defined weighted_literal_tuple/3.

