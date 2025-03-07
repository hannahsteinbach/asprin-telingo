%p1
%eventually(holds(hasknowsSpaghetti)) :- initially, holds(hasIngredients(spaghetti)), knowsHowToMake(spaghetti).
always(p1_aux) :- initially, holds(hasIngredients(spaghetti)), knowsHowToMake(spaghetti).

%p2
%eventually(holds(hasknowsmeal)) :- initially, holds(hasIngredients(X)), knowsHowToMake(X).
always(p2_aux) :- initially, holds(hasIngredients(X)), knowsHowToMake(X).

%p3 does not work asd intended
%eventually(holds(finalkitchenClean)) :- finally, holds(kitchenClean).
always_before(p3_aux) :- finally, holds(kitchenClean).

%p4
always(p4_aux) :- initially, always(holds(at(home))).


%p5
eventually(occurs(cook)) :- occurs(cook(_)).
p5_aux :- initially, eventually(occurs(cook(X))).

%p6
%eventually(occurs(orderTakeout)) :- occurs(orderTakeout(_,_)).
eventually(p6_aux) :- initially, eventually(occurs(orderTakeout(_,_))).


%p7
%eventually(occurs(orderRestaurant)) :- occurs(orderRestaurant(_,_)).
eventually(p7_aux) :- initially, eventually(occurs(orderRestaurant(_,_))).


%p8
%eventually(occurs(driveinSnow)) :- holds(isSnowing), occurs(drive(X,Y)).
eventually(p8_aux) :- initially, always(negation(and(isSnowing), occurs(drive(X,Y)))).


%p9
%eventually(occurs(eatChinese)) :- occurs(eat(X)), chinese(X).
occurs(eatChinese) :- occurs(eat(X)), chinese(X).
always(p9_aux) :- initially, always(negation(occurs(eatChinese))).

%p10

%p11

%p12

%p13

%p14