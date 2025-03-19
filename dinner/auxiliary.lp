%p1
p1_aux :- initially, holds(hasIngredients(spaghetti)), always(knowsHowToMake(spaghetti)).

%p2
p2_aux :- initially, holds(hasIngredients(X)), knowsHowToMake(X).

%p3
p3_aux :- finally, holds(kitchenClean).

%p4
always(p4_aux) :- initially, always(holds(at(home))).


%p5
eventually(occurs(cook)) :- occurs(cook(_)).
p5_aux :- initially, eventually(occurs(cook(X))).

%p6
eventually(p6_aux) :- initially, eventually(occurs(orderTakeout(_,_))).


%p7
eventually(p7_aux) :- initially, eventually(occurs(orderRestaurant(_,_))).


%p8
occurs(driveinSnow) :- holds(isSnowing), occurs(drive(X,Y)).
always(p8_aux) :- initially, always(negation(occurs(driveinSnow))).


%p9
occurs(eatChinese) :- occurs(eat(X)), chinese(X).
always(p9_aux) :- initially, always(negation(occurs(eatChinese))).

%p10

%p11

%p12

%p13

%p14