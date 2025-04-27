%p1
eventually(p1_aux) :- eventually(occurs(bus(home, school))).
eventually(p1_aux) :- eventually(occurs(take_taxi(home, school))).

%p2
eventually(p2_aux) :- eventually(occurs(call_taxi(home))).


%p3
eventually(p3_aux) :- eventually(holds(available_taxi(home))).

%p4
eventually(p4_aux) :- eventually(holds(has_coffee)).

% time

% cost

% comfort

% safety


occurs(take_taxi) :- occurs(take_taxi(X,Y)).
occurs(take_car) :- occurs(take_car(X,Y)).
occurs(bus) :- occurs(bus(X,Y)).
occurs(walk) :-  occurs(walk(X,Y)).
occurs(flight) :-  occurs(flight(X,Y)).


% shortest, for n = 3
always(sigma(0)) :- initially, holds(goal_achieved).
always(sigma(1))  :- initially, not holds(goal_achieved), next(holds(goal_achieved)).
always(sigma(2)) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            next(next(holds(goal_achieved))).
always(sigma(3)) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            not next(next(holds(goal_achieved))), next(next(next(holds(goal_achieved)))).
always(sigma(4)) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            not next(next(holds(goal_achieved))), not next(next(next(holds(goal_achieved)))),
            next(next(next(next(holds(goal_achieved))))).
always(sigma(5)) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            not next(next(holds(goal_achieved))), not next(next(next(holds(goal_achieved)))),
            not next(next(next(next(holds(goal_achieved))))), next(next(next(next(next(holds(goal_achieved)))))).

always(occurs(stop_noop)) :- 1{occurs(stop); occurs(noop)}.
