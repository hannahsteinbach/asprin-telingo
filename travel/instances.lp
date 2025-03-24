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