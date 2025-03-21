% Locations
location(home).
location(school).
location(airport1).
location(airport2).
location(bus_stop1).
location(coffeeshop).

% Specific categories
airport(airport1).
airport(airport2).
airport(home).
airport(school).

bus_station(bus_stop1).
bus_station(home).
bus_station(school).
bus_station(coffeeshop).

% Connections
road(home, bus_stop1).
%road(bus_stop1, home).
road(bus_stop1, school).
%road(school, bus_stop1).
road(home, school).
%road(school, home).
road(home, airport1).
%road(airport1, home).
road(school, airport2).
road(home, coffeeshop).
road(school, coffeeshop).
%road(airport2, school).
connected(airport1, airport2).
connected(home, school).
%connected(airport2, airport1).

road(Y,X) :- road(X,Y).
connected(Y,X) :- connected(X,Y).