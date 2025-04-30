% Locations
location(home).
location(school).
location(airport1).
location(airport2).
location(coffeeshop).

% Specific categories
airport(airport1).
airport(airport2).
airport(home).
airport(school).

bus_station(home).
bus_station(school).
bus_station(coffeeshop).

% Connections
road(home, school).
road(home, airport1).
road(school, airport2).
road(home, coffeeshop).
road(school, coffeeshop).
road(coffeeshop, school).
connected(airport1, airport2).
connected(home, school).

road(Y,X) :- road(X,Y).
connected(Y,X) :- connected(X,Y).

% Costs
cost(walk(X,Y), 0) :- action(walk(X,Y)).
cost(bus(X,Y), 2) :- action(bus(X,Y)).
cost(flight(X,Y), 0) :- action(flight(X,Y)).
cost(take_taxi(X,Y), 3) :- action(take_taxi(X,Y)).
cost(call_taxi(X), 0) :- action(call_taxi(X)).
cost(rent_car(X), 0) :- action(rent_car(X)).
cost(drive(X,Y), 2) :- action(drive(X,Y)).
cost(buy_ticket(X,Y), 10) :- action(buy_ticket(X,Y)).
cost(buy_coffee, 1) :- action(buy_coffee).
cost(noop, 0).
cost(stop, 0).

#const maxCost=100.
num(0..maxCost).

% Time
time(walk(X,Y), 6) :- action(walk(X,Y)).
time(bus(X,Y), 4) :- action(bus(X,Y)).
time(drive(X,Y), 4) :- action(drive(X,Y)).
time(flight(X,Y), 10) :- action(flight(X,Y)).
time(take_taxi(X,Y), 2) :- action(take_taxi(X,Y)).
time(call_taxi(X), 1) :- action(call_taxi(X)).
time(rent_car(X), 1) :- action(rent_car(X)).
time(buy_ticket(X,Y), 1) :- action(buy_ticket(X,Y)).
time(buy_coffee, 1) :- action(buy_coffee).
time(noop, 0).
time(stop, 0).