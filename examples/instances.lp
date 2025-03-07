
% MEALS

% meal(x) ≡ x = pizza ∨ x = tacos ∨ x = fajitas ∨ x = spaghetti
% ∨ x = sweetsourpork ∨ x = crêpes ∨ x = duck ∨ x = salad

%meal(pizza). meal(tacos). meal(fajitas).meal(spaghetti).
%meal(sweetsourpork). meal(crepes). meal(duck). meal(salad).

meal(pizza). meal(spaghetti). meal(crepes).

% TYPES OF MEALS

% vegetarian(x) ≡ x = salad
% italian(x) ≡ x = spaghetti ∨ x = pizza
% mexican(x) ≡ x = tacos ∨ x = fajitas
% french(x) ≡ x = crêpes ∨ x = duck
% chinese(x) ≡ x = sweetsourpork


vegetarian(salad). italian(spaghetti). italian(pizza). mexican(tacos).
mexican(fajitas). french(crepes). french(duck). chinese(sweetsourpork).


% LOCATIONS

% location(x) ≡ x = home ∨ x = store ∨ x = italianRest
% ∨ x = frenchRest ∨ x = chineseRest ∨ x = pizzaPlace
% (†) close(x, y) ≡ x = home ∧ y = italianRest

location(home). location(store). location(italianRest). location(frenchRest).
location(chineseRest). location(pizzaPlace). close(home, italianRest).


% TYPES OF RESTAURANTS

% takeOutRest(x) ≡ x = chineseRest ∨ x = pizzaPlace
% dineInRest(x) ≡ x = italianRest ∨ x = frenchRest

takeOutRest(chineseRest). takeOutRest(pizzaPlace).
dineInRest(italianRest). dineInRest(frenchRest).


% RESTAURANT OFFERINGS

% onMenu(x, y) ≡ y = italianRest ∧ (x = spaghetti ∨ x = pizza)
% ∨ y = frenchRest ∧ (x = crêpes ∨ x = duck)
% ∨ y = pizzaPlace ∧ x = pizza
% ∨ y = chineseRest ∧ x = sweetsourpork

onMenu(spaghetti, italianRest). onMenu(pizza, italianRest).
onMenu(crepes, frenchRest). onMenu(duck, frenchRest).
onMenu(pizza, pizzaPlace). onMenu(sweetsourpork, chineseRest).


% KNOWLEDGE OF RECIPES

% knowsHowToMake(x) ≡ x = crêpes ∨ x = spaghetti ∨ x = tacos
% ∨ x = fajitas ∨ x = salad

knowsHowToMake(crepes). knowsHowToMake(spaghetti). knowsHowToMake(tacos).
knowsHowToMake(fajitas). knowsHowToMake(salad).