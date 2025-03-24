% p2
#external eventually(occurs(bus(home, school))).
#external eventually(occurs(take_taxi(home, school))).

% p3
#external eventually(occurs(call_taxi(home))).

% p4
#external eventually(holds(available_taxi(home))).

% cost and time
#show show(occurs(take_car)).
#show show(occurs(bus)).
#show show(occurs(walk)).
#show show(occurs(take_taxi)).
#show show(occurs(flight)).

#external eventually(occurs(take_car)).
#external eventually(occurs(bus)).
#external eventually(occurs(walk)).
#external eventually(occurs(take_taxi)).
#external eventually(occurs(flight)).