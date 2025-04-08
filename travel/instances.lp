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
connected(airport1, airport2).
connected(home, school).

road(Y,X) :- road(X,Y).
connected(Y,X) :- connected(X,Y).

% Costs
cost(walk(X,Y), 0) :- action(walk(X,Y)).
cost(bus(X,Y), 1) :- action(bus(X,Y)).
cost(flight(X,Y), 0) :- action(flight(X,Y)).
cost(take_taxi(X,Y), 2) :- action(take_taxi(X,Y)).
cost(call_taxi(X), 4) :- action(call_taxi(X)).
cost(rent_car(X), 2) :- action(rent_car(X)).
cost(take_car(X,Y), 0) :- action(take_car(X,Y)).
cost(buy_ticket(X,Y), 10) :- action(buy_ticket(X,Y)).
cost(buy_coffee, 1) :- action(buy_coffee).
cost(noop, 0).
cost(stop, 0).

#const maxCost=100.
num(0..maxCost).