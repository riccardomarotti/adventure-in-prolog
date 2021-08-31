room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

:- dynamic(location/2).
location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location('washing machine', cellar).
location(nani, 'washing machine').
location(broccoli, kitchen).
location(crackers, kitchen).
location(computer, office).

door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

turned_off(flashlight).
:- dynamic(here/1).
here(kitchen).

connect(X, Y) :- door(X, Y).
connect(X, Y) :- door(Y, X).

list_things(Place) :-
  location(X, Place),
  tab(2),
  write(X),
  nl,
  fail.
list_things(_).

list_connection(Place) :-
  connect(Place, X),
  tab(2),
  write(X),
  nl,
  fail.
list_connection(_).

look :-
  here(Place),
  write('Tou are in the '), write(Place), nl,
  write('You can see '), nl,
  list_things(Place),
  write('You can go to: '), nl,
  list_connection(Place).

look_in(Place) :-
  write(Place), write(' contains: '), nl,
  location(X, Place),
  write(X),nl,
  fail.
look_in(_).

move(Place) :-
  retract(here(X)),
  asserta(here(Place)).

can_go(Place) :-
  here(X),
  connect(X, Place).
can_go(Place) :-
  here(X),
  write('You can''t get to '), write(Place), write(' from '), write(X), nl,
  fail.

goto(Place) :-
  can_go(Place),
  move(Place),
  look.

take(X) :-
  can_take(X),
  take_object(X).

can_take(Thing) :-
  here(Place),
  location(Thing, Place).
can_take(Thing) :-
  write('There is no '), write(Thing), write(' here.'), nl,
  fail.

take_object(X) :-
  retract(location(X, _)),
  asserta(have(X)),
  write('Taken '), write(X), nl.

put_down(Thing) :-
  have(Thing),
  here(Place),
  retract(have(Thing)),
  assertz(location(Thing, Place)),
  write(Thing), write('left in '), write(Place), nl.
put_down(Thing) :-
  write('Can''t put '), write(Thing), nl,
  fail.

inventory :-
  have(X),
  tab(2),
  write(X),
  nl.
  fail.
inventory.
