fraction(skellige).
fraction("northern realms").
fraction(nilfgard).
fraction(monsters).
fraction("scoia'tael").
fraction(syndicate).
fraction(neutral).

quality(gold).
quality(bronze).

card(geralt).
card(roach).
card(ciri).
card(yennefer).
card(triss).
card(grott).
card(regis).
card("renfri band").
card(demovend).
card(dana).
card(renfri).
card(fucusya).
card(torres).
card(saskia).
card(draug).
card(greatsword).
card(sergeant).
card(fleder).
card(kingslayer).
card(larva).

card_fraction(geralt, neutral).
card_fraction(roach, neutral).
card_fraction(ciri, neutral).
card_fraction(yennefer, neutral).
card_fraction(triss, neutral).
card_fraction(regis, neutral).
card_fraction(grott, monsters).
card_fraction(demovend, "northern realms").
card_fraction("renfri band", neutral).
card_fraction(dana, "scoia'tael").
card_fraction(renfri, neutral).
card_fraction(fucusya, skellige).
card_fraction(torres, nilfgard).
card_fraction(saskia, "scoia'tael").
card_fraction(draug, "northern realms").
card_fraction(greatsword, skellige).
card_fraction(sergeant, nilfgard).
card_fraction(fleder, monsters).
card_fraction(kingslayer, nilfgard).
card_fraction(larva, monsters).

card_quality(geralt, gold).
card_quality(roach, gold).
card_quality(ciri, gold).
card_quality(yennefer, gold).
card_quality(triss, gold).
card_quality(regis, gold).
card_quality(grott, gold).
card_quality(demovend, gold).
card_quality("renfri band", bronze).
card_quality(dana, gold).
card_quality(renfri, gold).
card_quality(fucusya, gold).
card_quality(torres, gold).
card_quality(saskia, gold).
card_quality(draug, gold).
card_quality(greatsword, bronze).
card_quality(sergeant, bronze).
card_quality(fleder, bronze).
card_quality(kingslayer, bronze).
card_quality(larva, bronze).

card_provision(geralt, 9).
card_provision(roach, 8).
card_provision(ciri, 10).
card_provision(yennefer, 9).
card_provision(triss, 9).
card_provision(regis, 11).
card_provision(grott, 12).
card_provision(demovend, 13).
card_provision("renfri band", 6).
card_provision(dana, 11).
card_provision(renfri, 9).
card_provision(fucusya, 14).
card_provision(torres, 12).
card_provision(saskia, 12).
card_provision(draug, 12).
card_provision(greatsword, 11).
card_provision(sergeant, 5).
card_provision(fleder, 4).
card_provision(kingslayer, 4).
card_provision(larva, 4).


card_power(geralt, 3).
card_power(roach, 3).
card_power(ciri, 5).
card_power(yennefer, 5).
card_power(triss, 3).
card_power(regis, 2).
card_power(grott, 13).
card_power(demovend, 4).
card_power("renfri band", 6).
card_power(dana, 7).
card_power(renfri, 8).
card_power(fucusya, 4).
card_power(torres, 4).
card_power(saskia, 5).
card_power(draug, 9).
card_power(greatsword, 11).
card_power(sergeant, 4).
card_power(fleder, 4).
card_power(kingslayer, 5).
card_power(larva, 2).



% Deck_1 = [regis, grott, "renfri band", "renfri band", triss, fleder, larva, larva, yennefer]
% Deck_2 = [geralt, fucusya, greatsword, greatsword, renfri, roach]

% Главная фаза
battle(Deck_1, Deck_2) :- 
	is_deck_correct(Deck_1), 
	is_deck_correct(Deck_2),
	nl, write("Decks correct!"),
	start_battle(Deck_1, Deck_2).



% проверка колоды
is_deck_correct(Deck) :- 
	is_card_numbers_correct(Deck),
	is_fraction_correct(Deck),
	is_quality_correct(Deck),
	is_provision_correct(Deck).


% проверка на количесство карт
is_card_numbers_correct(Deck) :-
	length(Deck, Length),
	Length > 0,
	Length < 31,
	!.
is_card_numbers_correct(Deck) :-
	length(Deck, Length),
	Length < 1,
	!,
	nl, write("No cards in deck"),
	false.
is_card_numbers_correct(Deck) :-
	length(Deck, Length),
	Length > 30,
	!,
	nl, write("Too much cards in deck"),
	false.


% проверка колоды по фракции
is_fraction_correct(Deck) :- is_fraction_correct(Deck, neutral).

is_fraction_correct([], _).
is_fraction_correct([Card|T], neutral) :- 
	card_fraction(Card, R), 
	R = neutral, 
	!, 
	is_fraction_correct(T, R).
is_fraction_correct([Card|T], neutral) :- 
	card_fraction(Card, R), 
	R \= neutral, 
	!, 
	is_fraction_correct(T, R).
is_fraction_correct([Card|T], Fraction) :- 
	is_card_fraction_correct(Card, Fraction), 
	!, 
	is_fraction_correct(T, Fraction).
is_fraction_correct([Card|_], Fraction) :- 
	card_fraction(Card, R), 
	R \= Fraction, 
	nl, write(Card), write(" has incorrect fraction"), 
	false.

is_card_fraction_correct(Card, Fraction) :- 
	card_fraction(Card, Card_fraction), 
	Card_fraction = Fraction.
is_card_fraction_correct(Card, _) :-
	 card_fraction(Card, Card_fraction), 
	 Card_fraction = neutral.


% проверка колоды по редкости карт
is_quality_correct(Deck) :- is_quality_correct(Deck, [], []).

is_quality_correct([], _, _).
is_quality_correct([Card|_], Gold_array, _) :- 
	is_gold(Card),
	member(Card, Gold_array),
	!,
	nl,
	write(Card),	
	write(" is gold and already repeat in deck"),
	false.
is_quality_correct([Card|T], Gold_array, Bronze_array) :- 
	is_gold(Card),
	\+ member(Card, Gold_array),
	!,
	append(Gold_array, [Card], New_gold_array),
	is_quality_correct(T, New_gold_array, Bronze_array).
is_quality_correct([Card|T], Gold_array, Bronze_array) :-
	is_bronze(Card),
	can_add_bronze(Bronze_array, Card),
	!,
	append(Bronze_array, [Card], New_bronze_array),
	is_quality_correct(T, Gold_array, New_bronze_array).
is_quality_correct([Card|_], _, Bronze_array) :- 
	is_bronze(Card),
	\+ can_add_bronze(Bronze_array, Card),
	!,
	nl,
	write(Card),
	write(" is bronze and already repeat twice in the deck"),
	false.

can_add_bronze(Deck, Card) :-
	count_in_array(Deck, Card, Count),
	Count < 2.

is_gold(Card) :- card_quality(Card, gold).
is_bronze(Card) :- card_quality(Card, bronze).

count_in_array([], _, Count) :- !, Count is 0.
count_in_array([Value|T], Value, Count) :- 
	!,
	count_in_array(T, Value, Pre_count),
	Count is Pre_count + 1.
count_in_array([_|T], Value, Count) :- 
	count_in_array(T, Value, Pre_count),
	Count is Pre_count.


% проверка колоды по провизии
is_provision_correct(Deck) :- 
	provision_in_deck(Provision),
	is_provision_correct(Deck, Provision).

is_provision_correct([], _).
is_provision_correct([Card|T,] Total_provision) :-
	card_provision(Card, Card_provision),
	Current_provision is Total_provision - Card_provision,
	Current_provision > -1,
	!,
	is_provision_correct(T, Current_provision).
is_provision_correct([Card|_], Total_provision) :-
	card_provision(Card, Card_provision),
	Current_provision is Total_provision - Card_provision,
	Current_provision < 0,
	nl,
	write("Sum of provision in the deck more than permissible"),
	false.

provision_in_deck(165).


% Фаза боя
start_battle(Full_deck_1, Full_deck_2) :- 
	get_hand_and_deck(Full_deck_1, Hand_1, _),
	get_hand_and_deck(Full_deck_2, Hand_2, _),
	get_power(Hand_1, Power_1),
	get_power(Hand_2, Power_2),
	length(Hand_1, Length_1),
	length(Hand_2, Length_2),
	nl, write("First deck has "), write(Power_1), write(" stats by "), write(Length_1), write(" cards"),
	nl, write("Second deck has "), write(Power_2), write(" stats by "), write(Length_2), write(" cards"), 
	fight(Power_1, Power_2).

fight(Power_1, Power_2) :-
	Power_1 > Power_2,
	!,
	nl, write("First deck won!").
fight(Power_1, Power_2) :-
	Power_1 < Power_2,
	!,
	nl, write("Second deck won!").
fight(Power_1, Power_2) :-
	Power_1 = Power_2,
	!,
	nl, write("Draw!").


% получить руку и оставшуюся колоду
get_hand_and_deck(Full_deck, Hand, Deck) :- 
	cards_in_hand(Cards_count),
	split_array_by_n_element(Full_deck, Cards_count, [], Hand, Deck).

split_array_by_n_element([], _, R, R, []) :- !.
split_array_by_n_element(Arr, 0, R, R, Arr) :- !.
split_array_by_n_element([H|T], N, Early_elements, Result_early, Result_other) :-
	New_N is N-1,
	append(Early_elements, [H], New_early_elements),
	!,
	split_array_by_n_element(T, New_N, New_early_elements, Result_early, Result_other).

cards_in_hand(10).

% узнать силу руки
get_power([Card], Power) :-
	!,
	card_power(Card, Card_power),
	Power is Card_power.
get_power([Card|T], Power) :-
	!,
	get_power(T, Power_of_other_cards),
	card_power(Card, Card_power),
	Power is Card_power + Power_of_other_cards.