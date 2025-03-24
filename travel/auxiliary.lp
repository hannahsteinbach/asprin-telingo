%p2
eventually(p2_aux) :- eventually(occurs(bus(home, school))).
eventually(p2_aux) :- eventually(occurs(take_taxi(home, school))).


% time

% cost

% comfort

% safety


occurs(take_taxi) :- occurs(take_taxi(X,Y)).
occurs(take_car) :- occurs(take_car(X,Y)).
occurs(bus) :- occurs(bus(X,Y)).
occurs(walk) :-  occurs(walk(X,Y)).
occurs(flight) :-  occurs(flight(X,Y)).
