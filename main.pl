/*
CPSC 312 Project 2 - 
Yean Shu, Jason Ueng, Daniel Hou
*/
:- use_module(library(random)).
:- dynamic player_stats/5.
:- discontiguous describe/1.
:- retractall(player_stats(_,_,_,_,_)).

% F = fight, M = money, C = cha, I = int, S = stam
player_stats(F,M,C,I,S).
        
sword :- 
        write('You study the blade *SCHWING'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(0, SIGN, MAG).
work :- 
        write('You work parttime at the local WcBonalds'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(1, SIGN, MAG).
talk :- 
        write('You practice your stand-up routine'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(2, SIGN, MAG).
book :- 
        write('You read the Art of Wario'), nl,
        random_between(0,1,SIGN), mag_generator(MAG), change_stats(3, SIGN, MAG).
rest :-
        write('You decide to take a nap'), nl, % yean go make some better comments
        change_stats(4,_,_).

stat :-
        getPlayerStats(F,M,C,I,S),
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

getPlayerStats(F,M,C,I,S) :- 
        player_stats(F,M,C,I,S).

% sword = 0, book = 1, work = 2, talk = 3, rest = 4
% sign 0 = neg, sign 1 = pos
change_stats(ACTION, SIGN, MAG) :-
        getPlayerStats(F,M,C,I,S),
        retract(player_stats(F,M,C,I,S)),
        (       ACTION =:= 4 -> S1 is S+2
        ;       ACTION =:= 0, SIGN =:= 0 -> F1 is F-MAG, S1 is S-1
        ;       ACTION =:= 0, SIGN =:= 1 -> F1 is F+MAG, S1 is S-1
        ;       ACTION =:= 1, SIGN =:= 0 -> M1 is M-MAG, S1 is S-1
        ;       ACTION =:= 1, SIGN =:= 1 -> M1 is M+MAG, S1 is S-1
        ;       ACTION =:= 2, SIGN =:= 0 -> C1 is C-MAG, S1 is S-1
        ;       ACTION =:= 2, SIGN =:= 1 -> C1 is C+MAG, S1 is S-1
        ;       ACTION =:= 3, SIGN =:= 0 -> I1 is I-MAG, S1 is S-1
        ;       ACTION =:= 3, SIGN =:= 1 -> I1 is I+MAG, S1 is S-1
        ),
        (       ACTION =:= 0 -> assert(player_stats(F1,M,C,I,S1))
        ;       ACTION =:= 1 -> assert(player_stats(F,M1,C,I,S1))
        ;       ACTION =:= 2 -> assert(player_stats(F,M,C1,I,S1))
        ;       ACTION =:= 3 -> assert(player_stats(F,M,C,I1,S1))
        ;       ACTION =:= 4 -> assert(player_stats(F,M,C,I,S1))
        ).
        

mag_generator(RES) :-
        random(MAG),
        (       MAG >= 0, MAG < 0.65 -> RES is 1
        ;       MAG >= 0.65, MAG < 0.9 -> RES is 2
        ;       MAG >= 0.9, MAG < 1 -> RES is 4       
        ).

 


start :-
    retract(player_stats(F,M,C,I,S)),
    assert(player_stats(10,10,10,10,10)),
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

describe(default) :-
        write('Day'), nl,
        write('Choose your task for today'), nl.


% List of Endings
gameover(str_end).
gameover(int_end).
gameover(mon_end).
gameover(cha_end).
gameover(secret_end). 
gameover(fail_end).

describe(str_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. You use an omega-slash and sunder the dragon in twain. The crowd cheers as you dab over the dragon\'s corpse'), nl,
        nl.

describe(int_end) :-
        nl,
        write(' The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. 
                You put on your wizard hat and cast an ice beam spell. It hits the dragon straight in the face and it roars in pain. 
                It breathes fire at you, but you cast a shield spell. The dragon makes fun of you for being a nerd, but you remembered to use ear plugs. 
                Deterred, the dragon grumbles and flies away.'), nl,
        nl.

describe(cha_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. You yell at the dragon, “LIGMA”. What’s ligma, the dragon asks, “ligma balls”, The dragon is so distraught and psychologically damaged that it flies away. THE END'), nl,
        nl.

describe(mon_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. You determine that the dragon is only here for the gold. You bring up all the gold you earned from part time jobs and offer it to the dragon. It seems satisfied and leaves.'), nl,
        nl.

describe(fail_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon’s leathery wings. Everyone gets absolutely destroyed you dumb baby'), nl,
        nl.
