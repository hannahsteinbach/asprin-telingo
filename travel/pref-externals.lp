% p1
#external eventually(occurs(bus(home, school))).
#external eventually(occurs(take_taxi(home, school))).
#external eventually(p1_aux).
#external negation(eventually(p1_aux)).

% p2
#external eventually(occurs(call_taxi(home))).
#external eventually(p2_aux).
#external negation(eventually(p2_aux)).

% p3
#external eventually(holds(available_taxi(home))).
#external eventually(p3_aux).
#external negation(eventually(p3_aux)).

% p4
#external eventually(holds(has_coffee)).
#external eventually(p4_aux).
#external negation(eventually(p4_aux)).

% cost and time
#show show(occurs(take_car)).
#show show(occurs(bus)).
#show show(occurs(walk)).
#show show(occurs(take_taxi)).
#show show(occurs(flight)).

#show show(transportation(take_car)).
#show show(transportation(bus)).
#show show(transportation(walk)).
#show show(transportation(take_taxi)).
#show show(transportation(flight)).

#external eventually(occurs(take_car)).
#external eventually(occurs(bus)).
#external eventually(occurs(walk)).
#external eventually(occurs(take_taxi)).
#external eventually(occurs(flight)).

% cost overall
#external finally.
#external holds(sCost(C)) : holds(sCost(C)).