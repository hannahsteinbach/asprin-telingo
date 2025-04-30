%
% Meta-encoding using hold(A,T)
%
% In our meta-encoding input we consider rules of the input program to
% apply for all time points of a trace. That is, using temporal logic
% terminology, rules are interpreted as being encosed in an always
% operator; or, using telingo's input language, as being under the
% subprogram #always.
%
% This property can be seen encoded in the rules below.
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

time(0..horizon).

#show.
#show (S,T) : output(show(S),_), true(S,T).

%
% Connect true/2 with hold/2
%

true(O,T) :- hold(L,T), output(O,B), literal_tuple(B,L).
hold(L,T) :- true(O,T), output(O,B), literal_tuple(B,L).

%
% the next rule is also needed to represent the facts
%  O.
% of the input logic program, for which clingo generates
%  output(O,0).
% and no literal_tuple of the form literal_tuple(0,L)
%
% 
true(O,T) :- time(T), output(O,B), not literal_tuple(B,_).

%
% Temporal connectives using true/2
%

% formulas
formula(O) :- output(O,_).

% initially
true(initially,0) :- formula(initially).
:- true(initially,T), T>0, formula(initially).


% finally
true(finally,horizon) :- formula(finally).
:- true(finally,T), T<horizon, formula(finally).

% prev
formula(F) :- formula(prev(F)).
true(F,T-1) :- true(prev(F),T), formula(prev(F)), time(T), time(T-1).
true(prev(F),T) :- true(F,T-1), formula(prev(F)), time(T), time(T-1).
:- true(prev(F),0), formula(prev(F)). % if it is initial state, there is no previous


% wprev 
% ME, same as prev but there can also be a previous state for the initial state (that is just true)
formula(F) :- formula(wprev(F)).
true(F,T-1) :- true(wprev(F),T), formula(wprev(F)), time(T), time(T-1).
true(wprev(F),T) :- true(F,T-1), formula(wprev(F)), time(T), time(T-1).
true(wprev(F),0) :- formula(wprev(F)). 

% next 
% ME
formula(F) :- formula(next(F)).
true(F,T+1) :- true(next(F),T), formula(next(F)), time(T), time(T+1).
true(next(F),T) :- true(F,T+1), formula(next(F)), time(T), time(T+1).
:- true(next(F),horizon), formula(next(F)).


% same as next but there can also be a next state for the final state (that is just true)
formula(F) :- formula(wnext(F)).
true(F,T+1) :- true(wnext(F),T), formula(wnext(F)), time(T), time(T+1).
true(wnext(F),T) :- true(F,T+1), formula(wnext(F)), time(T), time(T+1).
true(wnext(F),horizon) :- formula(wnext(F)).

% eventually, T1 has to be true at least once after T0
formula(F) :- formula(eventually(F)).
true(F,T1): time(T1), T0 <= T1 :- formula(eventually(F)), true(eventually(F),T0), time(T0).
true(eventually(F),T0) :- true(F,T1), formula(eventually(F)), time(T0), time(T1), T0 <= T1.


% insert rules below to handle head and body ocurance of eventually/1.

% hint: to handle occurances of eventually(F) in the body, we can use
% a conditional literal that ranges over the possible time points in
% which we will derive F to be true


% eventually_before, T0 has to be true at least once before T1
formula(F) :- formula(eventually_before(F)).
true(F,T0): time(T0), T0 <= T1 :- true(eventually_before(F),T1), formula(eventually_before(F)), time(T1).
true(eventually_before(F),T1) :- true(F,T0), formula(eventually_before(F)), time(T1), time(T0), T0 <= T1.


% always, T1 has to be true always after T0
formula(F) :- formula(always(F)).
true(F,T1):-  true(always(F),T0), formula(always(F)), time(T0), time(T1), T0 <= T1. 
true(always(F),T0) :- formula(always(F)), time(T0), true(F,T1) : time(T1), T0 <= T1.


% always_before,  T0 has to be true always before T1
formula(F) :- formula(always_before(F)).
true(F,T0) :- true(always_before(F),T1), formula(always_before(F)), time(T0), time(T1), T0 <= T1.
true(always_before(F),T1) :- formula(always_before(F)), time(T1), true(F,T0) : time(T0), T0 <= T1.


% UNTIL
% F must hold at least until G becomes true
formula(F) :- formula(until(F,G)).
formula(G) :- formula(until(F,G)).

% insert rules below to handle head and body occurance of until/2.

true(until(F,G),K,X): time(X), K <= X  :- true(until(F,G),K) , formula(until(F,G)).

true(G, X) :-   formula(until(F, G)), true(until(F,G),K,X).
true(F, Y) :-  formula(until(F, G)), true(until(F,G),K, X), K <= Y, Y < X, time(Y).

true(until(F,G),K, X)  :- true(G, X), formula(until(F,G)), time(K), time(X), K <= X, true(F, Y): time(Y), K <= Y, Y < X.
true(until(F,G),K) :- true(until(F,G),K,X), K <= X.


% RELEASE 
% G has to hold for all K <= X or F holds at some point Y  K <= Y < X 
% wenn F auftritt, kann G aufhören 

formula(F) :- formula(release(F,G)).
formula(G) :- formula(release(F,G)).

true(release(F,G),K,X):- true(release(F,G),K) , formula(release(F,G)), time(X), K <= X.

true(G, X); true(F, Y): time(Y), K <= Y, Y < X :- formula(release(F,G)), true(release(F,G),K, X).

true(release(F,G),K, X)  :- formula(release(F,G)), time(K), true(F, Y), time(Y), K <= Y, Y < X, time(X).
true(release(F,G),K, X)  :- formula(release(F,G)), time(K), time(X), true(G, X), time(X), K <= X. 		
 
true(release(F,G),K) :- time(K), formula(release(F,G)), true(release(F,G),K,X): time(X), K <= X.



% WHILE
% F has to hold as long as G does. If G stops to hold, F can also stop. If G never holds, F has to hold until the end
formula(F) :- formula(while(F,G)).
formula(G) :- formula(while(F,G)).

true(while(F,G),K,X):- true(while(F,G),K), formula(while(F,G)), time(X), K <= X.

true(G,Y) :- formula(while(F,G)), time(Y), true(while(F,G),K,X), true(F,X), K <= Y, Y < X.
true(F,X) :- formula(while(F,G)), time(X), true(while(F,G),K,X), true(G,Y) :  time(Y), K <= Y, Y < X.

true(while(F,G),K,X) :-  true(F,X), K <= X, formula(while(F,G)), time(K), true(G,Y) : time(Y), K <= Y, Y < X.

true(while(F,G),K) :- time(K), formula(while(F,G)), true(while(F,G),K,X): time(X), K <= X.


% SINCE 
% F must have held continously since G became true at some point x before, G must be true at some point x <= k!

formula(F) :- formula(since(F,G)).
formula(G) :- formula(since(F,G)).

true(since(F,G),K,X): time(X), X <= K  :- true(since(F,G),K) , formula(since(F,G)).

true(G, X) :-   formula(since(F, G)), true(since(F,G),K,X).
true(F, Y) :-  formula(since(F, G)), true(since(F,G),K, X), X < Y, Y <= K, time(Y).
 
true(since(F,G),K, X)  :- true(G, X), formula(since(F,G)), time(K), time(X), X <= K, true(F, Y): time(Y), X < Y, Y <= K.
true(since(F,G),K) :- true(since(F,G),K,X), X <= K.


% TRIGGER 

% G is true for all X <= K OR F is true at least once between X and K 

formula(F) :- formula(trigger(F,G)).
formula(G) :- formula(trigger(F,G)).

true(trigger(F,G),K,X) :- true(trigger(F,G),K) , formula(trigger(F,G)), time(X), X <= K.

true(G, X); true(F, Y): time(Y), X < Y, Y <= K :- formula(trigger(F,G)), true(trigger(F,G),K, X).

true(trigger(F,G),K, X)  :- formula(trigger(F,G)), time(K), true(F, Y), time(Y), X < Y, Y <= K, time(X).
true(trigger(F,G),K, X)  :- formula(trigger(F,G)), time(K), time(X), true(G, X), time(X), X <= K. 

true(trigger(F,G),K) :- time(K), formula(trigger(F,G)), true(trigger(F,G),K,X): time(X), X <= K.


%
% Boolean operators to be used in nested formulas
%

% negation
formula(F) :- formula(negation(F)).

not true(F,T):- formula(negation(F)), true(negation(F), T).
true(negation(F), T) :- formula(negation(F)), time(T), not true(F, T).

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
