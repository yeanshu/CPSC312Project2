/*
CPSC 312 Project 2 - 
Yean Shu, Jason Ueng, Daniel Hou
*/
:- use_module(library(random)).
:- dynamic player_stats/6.
:- discontiguous describe/1.
:- retractall(player_stats(_,_,_,_,_,_)).

% F = fight, M = money, C = cha, I = int, S = stam, D = current day
player_stats(F,M,C,I,S,D).
        
sword :- 
        write('You study the blade *SCHWING'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(0, SIGN, MAG), random_event.
work :- 
        write('You work parttime at the local WcBonalds'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(1, SIGN, MAG), random_event.
talk :- 
        write('You practice your stand-up routine'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(2, SIGN, MAG), random_event.
book :- 
        write('You read the Art of Wario'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(3, SIGN, MAG), random_event.
rest :-
        write('You decide to take a nap'), nl,
        change_stats(4,_,_), new_day.

stat :-
        getPlayerStats(F,M,C,I,S,_),
        number_string(F,Fstr),
        number_string(M,Mstr),
        number_string(C,Cstr),
        number_string(I,Istr),
        number_string(S,Sstr),
        write('Your Strength is: '), write(Fstr), nl,
        write('Your Wealth is: '),  write(Mstr),nl,
        write('Your Charisma is: '), write(Cstr), nl,
        write('Your Intelligence is: '), write(Istr), nl,
        write('Your Stamina is: '), write(Sstr), nl.

getPlayerStats(F,M,C,I,S,D) :- 
        player_stats(F,M,C,I,S,D).

% sword = 0, book = 1, work = 2, talk = 3, rest = 4
% sign 0 = neg, sign 1 = pos
change_stats(ACTION, SIGN, MAG) :-
        getPlayerStats(F,M,C,I,S,D),
        retract(player_stats(F,M,C,I,S,D)),
        (       ACTION =:= 4 -> S1 is S+2
        ;       ACTION =:= 5 -> F1 is F+MAG, M1 is M+MAG, C1 is C+MAG, I1 is I+MAG, S1 is S+MAG % from event inc/dec stats
        ;       ACTION =:= 0, SIGN =:= 0 -> F1 is F-MAG,S1 is S-1
        ;       ACTION =:= 0, SIGN =:= 1 -> F1 is F+MAG,S1 is S-1
        ;       ACTION =:= 1, SIGN =:= 0 -> M1 is M-MAG,S1 is S-1
        ;       ACTION =:= 1, SIGN =:= 1 -> M1 is M+MAG,S1 is S-1
        ;       ACTION =:= 2, SIGN =:= 0 -> C1 is C-MAG,S1 is S-1
        ;       ACTION =:= 2, SIGN =:= 1 -> C1 is C+MAG,S1 is S-1
        ;       ACTION =:= 3, SIGN =:= 0 -> I1 is I-MAG,S1 is S-1
        ;       ACTION =:= 3, SIGN =:= 1 -> I1 is I+MAG,S1 is S-1
        ),
        (       ACTION =:= 0 -> assert(player_stats(F1,M,C,I,S1,D))
        ;       ACTION =:= 1 -> assert(player_stats(F,M1,C,I,S1,D))
        ;       ACTION =:= 2 -> assert(player_stats(F,M,C1,I,S1,D))
        ;       ACTION =:= 3 -> assert(player_stats(F,M,C,I1,S1,D))
        ;       ACTION =:= 4 -> assert(player_stats(F,M,C,I,S1,D))
        ;       ACTION =:= 5 -> assert(player_stats(F1,M1,C1,I1,S1,D))
        ).
        

mag_generator(RES) :-
        random(MAG),
        (       MAG >= 0, MAG < 0.65 -> RES is 1
        ;       MAG >= 0.65, MAG < 0.9 -> RES is 2
        ;       MAG >= 0.9, MAG < 1 -> RES is 4       
        ).

 
random_event :-
        random(TRIGGER),
        (       TRIGGER >= 0.99, TRIGGER < 1 -> describe(heart_attack) % event: death
        ;       TRIGGER >= 0.97, TRIGGER < 0.99 -> describe(inc_all), change_stats(5,1,4), new_day % event: inc all stats
        ;       TRIGGER >= 0.95, TRIGGER < 0.97 -> describe(dec_all), change_stats(5,0,-2), new_day % event: dec all stats
        ;       TRIGGER >= 0.9, TRIGGER < 0.95 -> describe(drop_your_wallet), change_stats(1,0,1), new_day % event: drop my wallet
        ;       TRIGGER >= 0, TRIGGER < 0.9 -> new_day % nothing happens
        ).
        
new_day :-
        getPlayerStats(F,M,C,I,S,D),
        retract(player_stats(F,M,C,I,S,D)),
        D1 is D+1,
        assert(player_stats(F,M,C,I,S,D1)),
        number_string(D1,Dstr),
        (       D1 >= 30 -> end_branch
        ;       write('It is now day '), write(Dstr), nl
        ).
        

end_branch :-
        getPlayerStats(F,M,C,I,S,_),
        (       F >= 30 -> describe(str_end) 
        ;       M >= 30 -> describe(mon_end) 
        ;       C >= 30 -> describe(cha_end)
        ;       I >= 30 -> describe(int_end)
        ;       describe(fail_end) 
        ).

start :-
        retract(player_stats(F,M,C,I,S,D)),
        assert(player_stats(10,10,10,10,10,1)),
        instructions.

instructions :-
    nl,
    write('You are Jonathan, the newest member of the village guild. A dragon comes to the village once a month and demands gold. Every time, the village is forced to surrender. This time, you are determined to stop it.'), nl,
    write('You hear a mysterious voice from the heavens call out to you...'), nl,
    write('sword.         -- to train your strength.'), nl,
    write('work.          -- to earn some money.'), nl,
    write('talk.          -- to train your charisma.'), nl,
    write('book.          -- to train your intelligence'), nl,
    write('rest.          -- to take a nap'), nl,
    write('stat.          -- to see your current status.'), nl,
    write('halt.          -- to end the game and quit.'), nl,
    write('What was that voice! And what does it mean to quit the game! You ask yourself these questions.'), nl,
    write('However, your quest is determined now!'), nl,
    write('Die Dragon! You dont belong in this world!'), nl,
    nl.

% Meta

describe(default) :-
        write('Day'), nl,
        write('Choose your task for today'), nl.

describe(game_over) :-
        write('Game Over'), nl,
        write('type start. to try again?'), nl.

% List of Random Events
describe(inc_all) :- 
        nl,
        write('The here is finally day. The wind is blowing as god descends from the heavens and gives you the gigachad buff. You feel the power coursing through your veins as you take a big ol dump on the floor. You gain a + _ to all your stats'),
        nl.

describe(dec_all) :-
        nl,
        write('The here is finally day. The wind is blowing as god descends from the heavens and gives you the wee lad debuff. You feel like you want to go back to bed, unmotivated to start the day. You take a -2 to all your stats'),
        nl.

describe(drop_your_wallet) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear your coin pouch flying away. You manage to recover some of your coins, but it does feel lighter. -1 Money'),
        nl.


% List of Endings
describe(str_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. You use an omega-slash and sunder the dragon in twain. The crowd cheers as you dab over the dragon’s corpse'), nl,
        nl,
        describe(game_over).

describe(int_end) :-
        nl,
        write(' The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. 
                You put on your wizard hat and cast an ice beam spell. It hits the dragon straight in the face and it roars in pain. 
                It breathes fire at you, but you cast a shield spell. The dragon makes fun of you for being a nerd, but you remembered to use ear plugs. 
                Deterred, the dragon grumbles and flies away.'), nl,
        nl,
        describe(game_over).

describe(cha_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. You yell at the dragon, “LIGMA”. What’s ligma, the dragon asks, “ligma balls”, The dragon is so distraught and psychologically damaged that it flies away. THE END'), nl,
        nl,
        describe(game_over).

describe(mon_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. You determine that the dragon is only here for the gold. You bring up all the gold you earned from part time jobs and offer it to the dragon. It seems satisfied and leaves.'), nl,
        nl,
        describe(game_over).

describe(fail_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. Everyone gets absolutely destroyed you dumb baby'), nl,
        nl,
        describe(game_over).

describe(heart_attack) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the beat of your own heart. Until suddenly you don’t You FUCKING DIE DUMBASS WHY DIDNT YOU REST'),
        nl,
        describe(game_over).