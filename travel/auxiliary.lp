%p4
p4_aux :- finally, holds(has_coffee).

% time

% cost

% comfort

% safety


occurs(take_taxi) :- occurs(take_taxi(X,Y)).
occurs(drive) :- occurs(drive(X,Y)).
occurs(bus) :- occurs(bus(X,Y)).
occurs(walk) :-  occurs(walk(X,Y)).
occurs(flight) :-  occurs(flight(X,Y)).


% shortest, for n = 5
sigma(0) :- initially, holds(goal_achieved).
sigma(1)  :- initially, not holds(goal_achieved), next(holds(goal_achieved)).
sigma(2) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            next(next(holds(goal_achieved))).
sigma(3) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            not next(next(holds(goal_achieved))), next(next(next(holds(goal_achieved)))).
sigma(4) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            not next(next(holds(goal_achieved))), not next(next(next(holds(goal_achieved)))),
            next(next(next(next(holds(goal_achieved))))).
sigma(5) :- initially, not holds(goal_achieved), not next(holds(goal_achieved)),
            not next(next(holds(goal_achieved))), not next(next(next(holds(goal_achieved)))),
            not next(next(next(next(holds(goal_achieved))))), next(next(next(next(next(holds(goal_achieved)))))).

always(occurs(stop_noop)) :- 1{occurs(stop); occurs(noop)}.

% cheapest trajectory
eventually(cost_overall(C)) :- holds(sCost(C)), finally.
#show show(cost_overall(C)) : holds(sCost(C)).

% PAPER
% (time) time = always(taxi <e (drive|bus) <e walk) -> p. 570
always(time_aux) :- initially, always(and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))).

% (cost) cost = always(walk <e (drive|bus) <e taxi) -> p. 571
always(cost_aux) :- initially, always(and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi)))))).

% (comfort) comfort = always(flight <e (drive|bus) <e walk) -> p. 573
always(comfort_aux) :- initially, always(and(if(and(executable(flight), or(executable(drive), executable(bus))),
            and(occurs(flight), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))).

% (safety) safety = always(walk <e flight <e (drive | bus)). -> p. 573
always(safety_aux) :- initially, always(and(if(and(executable(walk), executable(flight)),
            and(occurs(walk), negation(flight))), if(and(executable(flight), or(executable(drive), executable(bus))),
            and(occurs(flight), negation(or(occurs(drive), occurs(bus))))))).


% WEAK

% (time weak) time = always(taxi <e (drive|bus) <e walk) -> p. 570
always(time_weak_aux) :- initially, always(and(or(occurs(take_taxi), negation(or(occurs(drive), occurs(bus)))),
                         or(or(occurs(drive), occurs(bus)), negation(occurs(walk))))).

% (cost weak) cost = always(walk <e (drive| bus) <e taxi)-> p. 571
always(cost_weak_aux) :- initially, always(and(or(occurs(walk), negation(or(occurs(drive), occurs(bus)))),
                         or(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi))))).

% (comfort weak) comfort = always(flight <e (drive ∨ bus) <e walk) -> p. 573
always(comfort_weak_aux) :- initially, always(and(or(occurs(flight), negation(or(occurs(drive), occurs(bus)))),
                         or(or(occurs(drive), occurs(bus)), negation(occurs(walk))))).

% (safety weak) safety = always(walk <e flight <e (drive ∨ bus)) -> p. 573
always(safety_weak_aux) :- initially, always(and(or(occurs(walk), negation(occurs(flight))),
                         or(occurs(flight), negation(or(occurs(drive), occurs(bus)))))).

% ME (what about not mentioned actions?)
% time = always(taxi <e (drive|bus) <e walk)
% if taxi is executable, take taxi, it not executable and drive/bus are executable, take those, if not executable, walk (never fly)
always(time_1) :- initially, eventually(executable(take_taxi)), eventually(occurs(take_taxi)), not eventually(occurs(drive)),
           not eventually(occurs(bus)), not eventually(occurs(walk)), not eventually(occurs(flight)).
always(time_2) :- initially, not eventually(occurs(take_taxi)), eventually(occurs(drive)), not eventually(occurs(walk)),
                  not eventually(occurs(flight)).
always(time_2) :- initially, not eventually(occurs(take_taxi)), eventually(occurs(bus)), not eventually(occurs(walk)),
                  not eventually(occurs(flight)).
always(time_3) :- initially, not eventually(occurs(take_taxi)), not eventually(occurs(drive)),
                  not eventually(occurs(bus)), eventually(occurs(walk)), not eventually(occurs(flight)).

% cost = always(walk <e (drive ∨ bus) <e taxi)
% if walk is executable, then walk, it not executable and drive/bus are executable, take those, if not executable, take taxi (never fly)
always(cost_1) :- initially, eventually(executable(walk)), eventually(occurs(walk)), not eventually(occurs(drive)),
           not eventually(occurs(bus)), not eventually(occurs(take_taxi)), not eventually(occurs(flight)).
always(cost_2) :- initially, not eventually(occurs(walk)), eventually(occurs(drive)), not eventually(occurs(take_taxi)),
                  not eventually(occurs(flight)).
always(cost_2) :- initially, not eventually(occurs(walk)), eventually(occurs(bus)), not eventually(occurs(take_taxi)),
                  not eventually(occurs(flight)).
always(cost_3) :- initially, not eventually(occurs(walk)), not eventually(occurs(drive)),
                  not eventually(occurs(bus)), eventually(occurs(take_taxi)), not eventually(occurs(flight)).


% (comfort weak) comfort = always(flight <e (drive ∨ bus) <e walk) -> p. 573
always(comfort_1) :- initially, eventually(executable(flight)), eventually(occurs(flight)), not eventually(occurs(drive)),
           not eventually(occurs(bus)), not eventually(occurs(walk)), not eventually(occurs(take_taxi)).
always(comfort_2) :- initially, not eventually(occurs(flight)), eventually(occurs(drive)), not eventually(occurs(walk)),
                  not eventually(occurs(take_taxi)).
always(comfort_2) :- initially, not eventually(occurs(flight)), eventually(occurs(bus)), not eventually(occurs(walk)),
                  not eventually(occurs(take_taxi)).
always(comfort_3) :- initially, not eventually(occurs(flight)), not eventually(occurs(drive)),
                  not eventually(occurs(bus)), eventually(occurs(walk)), not eventually(occurs(take_taxi)).

% (safety weak) safety = always(walk <e flight <e (drive ∨ bus)) -> p. 573
always(safety_1) :- initially, eventually(executable(walk)), eventually(occurs(walk)), not eventually(occurs(flight)),
           not eventually(occurs(drive)), not eventually(occurs(bus)), not eventually(occurs(take_taxi)).
always(safety_2) :- initially, not eventually(occurs(walk)), eventually(occurs(flight)), not eventually(occurs(drive)),
                  not eventually(occurs(bus)), not eventually(occurs(take_taxi)).
always(safety_3) :- initially, not eventually(occurs(walk)),  not eventually(occurs(flight)),
                    eventually(occurs(bus)), not eventually(occurs(take_taxi)).
always(safety_3) :- initially, not eventually(occurs(walk)),  not eventually(occurs(flight)),
                    eventually(occurs(drive)), not eventually(occurs(take_taxi)).


% (time_coffee) time_coffee = always(occ(buy coffee) ∨ (take taxi <e (drive ∨ bus) <e walk)) -> p. 579
always(time_coffee_aux) :- initially, always(or(occurs(buy_coffee), and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk))))))).

% (cost_coffee) cost_coffee = always(occ(buy coffee) ∨ (walk <e (drive ∨ bus) <e take taxi)). -> p. 579
always(cost_coffee_aux) :- initially, always(or(occurs(buy_coffee), and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi))))))).


% time n cost, combine time_coffee and cost_coffee within one formula
always(time_n_cost_aux) :- initially, always(and(or(occurs(buy_coffee), and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi)))))),
            or(occurs(buy_coffee), and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))))).

always(time_v_cost_aux) :- initially,  always(or(or(occurs(buy_coffee), and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi)))))),
            or(occurs(buy_coffee), and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))))).


% short
always(short_aux) :- initially, always(if(and(or(executable(stop), executable(noop)), or(executable(drive), or(executable(bus), or(executable(walk),
            or(executable(take_taxi), or(executable(flight), or(executable(buy_ticket), or(executable(rent_car),
            or(executable(call_taxi), executable(buy_coffee)))))))))), and(or(occurs(stop), occurs(noop)),
             negation(or(occurs(drive), or(occurs(bus), or(occurs(walk), or(occurs(take_taxi),
             or(occurs(flight), or(occurs(buy_ticket), or(occurs(rent_car), or(occurs(call_taxi), occurs(buy_coffee))))))))))))).

always(short_aux_test) :- initially, always(if(and(or(executable(stop), executable(noop)), or(executable(wait), executable(do_f))),
                    and(or(occurs(stop), occurs(noop)), negation(or(occurs(wait), occurs(do_f)))))).

