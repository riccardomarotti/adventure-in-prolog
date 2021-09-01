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
location(envelope, desk).
location(stamp, envelope).
location(key, envelope).

door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

:- dynamic(turned_off/1).
turned_off(flashlight).
turned_off(apple).
:- dynamic(turned_on/1).
turned_on(nothing).
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
  is_contained_in(Thing, Place).
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
  nl,
  fail.
inventory.

turn_on(X) :-
  have(X),
  turned_on(X),
  write(X), write(' is already on.'), nl.
turn_on(X) :-
  have(X),
  turned_off(X),
  retract(turned_off(X)),
  assertz(turned_on(X)),
  write(X), write(' turned on.'), nl.

turn_off(X) :-
  have(X),
  turned_off(X),
  write(X), write(' is already off.').
turn_off(X) :-
  have(X),
  turned_on(X),
  retract(turned_on(X)),
  assertz(turned_off(X)),
  write(X), write(' turned off.'), nl.

is_contained_in(T1, T2) :-
  location(T1, T2).
is_contained_in(T1, T2) :-
  location(X, T2),
  is_contained_in(T1, X).
