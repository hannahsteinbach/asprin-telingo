% p1
#external and(initially, eventually(or(occurs(bus(home,school)), occurs(take_taxi(home,school))))).


% p2
#external and(initially, always(negation(occurs(call_taxi(home))))).

% p3
#external and(initially, always(negation(holds(available_taxi(home))))).

% p4
#external eventually(p4_aux).

% cost, time, comfort, safety
%show show(cost_aux).
%#show show(time_aux).
%#show show(comfort_aux).
%#show show(safety_aux).

% cost and time
#show show(occurs(drive)).
#show show(occurs(bus)).
#show show(occurs(walk)).
#show show(occurs(take_taxi)).
#show show(occurs(flight)).
#show show(occurs(stop)).
#show show(occurs(noop)).

#show show(executable(drive)).
#show show(executable(bus)).
#show show(executable(walk)).
#show show(executable(take_taxi)).
#show show(executable(flight)).
#show show(executable(buy_ticket)).
#show show(executable(rent_car)).
#show show(executable(call_taxi)).
#show show(executable(buy_coffee)).
#show show(executable(stop)).
#show show(executable(noop)).
#show show(executable(wait)).
#show show(executable(do_f)).

#external eventually(occurs(drive)).
#external eventually(occurs(bus)).
#external eventually(occurs(walk)).
#external eventually(occurs(take_taxi)).
#external eventually(occurs(flight)).


#external executable(drive).
#external executable(bus).
#external executable(walk).
#external executable(take_taxi).
#external executable(flight).
#external executable(buy_ticket).
#external executable(rent_car).
#external executable(call_taxi).
#external executable(buy_coffee).
#external executable(stop).
#external executable(noop).

% shortest n = 5
#external holds(goal_achieved).
#external next(holds(goal_achieved)).
#external next(next(holds(goal_achieved))).
#external next(next(next(holds(goal_achieved)))).
#external next(next(next(next(holds(goal_achieved))))).
#external next(next(next(next(next(holds(goal_achieved)))))).

#external initially.
#external sigma(0).
#external sigma(1).
#external sigma(2).
#external sigma(3).
#external sigma(4).
#external sigma(5).

%#show show(sigma(0)).
%#show show(sigma(1)).
%#show show(sigma(2)).
%#show show(sigma(3)).
%#show show(sigma(4)).
%#show show(sigma(5)).


% bound n
#external and(initially, sigma(W)) : sigma(W).

% shortest unbound n
#external occurs(stop_noop).

% cheapest
#external finally.
#external holds(sCost(C)) : holds(sCost(C)).

% time
#external time_aux.
#external always(and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))).

#external and(initially, always(time_aux)).

% cost
#external cost_aux.
#external always(and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi)))))).

#external and(initially, always(cost_aux)).

% comfort
#external comfort_aux.
#external always(and(if(and(executable(flight), or(executable(drive), executable(bus))),
            and(occurs(flight), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))).

#external and(initially, always(comfort_aux)).

% safety
#external safety_aux.
#external always(and(if(and(executable(walk), executable(flight)),
            and(occurs(walk), negation(flight))), if(and(executable(flight), or(executable(drive), executable(bus))),
            and(occurs(flight), negation(or(occurs(drive), occurs(bus))))))).

#external and(initially, always(safety_aux)).


% time_coffee_aux
#external always(or(occurs(buy_coffee), and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk))))))).

#external and(initially, always(time_coffee_aux)).


% cost_coffee_aux
#external always(or(occurs(buy_coffee), and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi))))))).

#external and(initially, always(cost_coffee_aux)).

#show show(time_coffee_aux).
#show show(cost_coffee_aux).

% time n cost
#external always(and(or(occurs(buy_coffee), and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi)))))),
            or(occurs(buy_coffee), and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))))).
#external and(initially, always(time_n_cost_aux)).
#external and(time_coffee_aux,cost_coffee_aux).
#show show(and(time_coffee_aux,cost_coffee_aux)).
#show show(time_n_cost_aux).


% time v cost
#external always(or(or(occurs(buy_coffee), and(if(and(executable(walk), or(executable(drive), executable(bus))),
            and(occurs(walk), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(take_taxi)), and(or(occurs(drive), occurs(bus)), negation(occurs(take_taxi)))))),
            or(occurs(buy_coffee), and(if(and(executable(take_taxi), or(executable(drive), executable(bus))),
            and(occurs(take_taxi), negation(or(occurs(drive), occurs(bus))))), if(and(or(executable(drive), executable(bus)),
            executable(walk)), and(or(occurs(drive), occurs(bus)), negation(occurs(walk)))))))).

#external and(initially, always(time_v_cost_aux)).
#external or(time_coffee_aux,cost_coffee_aux).
#show show(time_v_cost_aux).
#show show(or(time_coffee_aux,cost_coffee_aux)).

% short
#external always(if(and(or(executable(stop), executable(noop)), or(executable(drive), or(executable(bus), or(executable(walk),
            or(executable(take_taxi), or(executable(flight), or(executable(buy_ticket), or(executable(rent_car),
            or(executable(call_taxi), executable(buy_coffee)))))))))), and(or(occurs(stop), occurs(noop)),
             negation(or(occurs(drive), or(occurs(bus), or(occurs(walk), or(occurs(take_taxi),
             or(occurs(flight), or(occurs(buy_ticket), or(occurs(rent_car), or(occurs(call_taxi), occurs(buy_coffee))))))))))))).

#show show(short_aux).

% short test
#external always(if(and(or(executable(stop), executable(noop)), or(executable(wait), executable(do_f))),
                    and(or(occurs(stop), occurs(noop)), negation(or(occurs(wait), occurs(do_f)))))).

#show show(short_aux_test).
