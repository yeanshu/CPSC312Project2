/*
CPSC 312 Project 2 - 
Yean Shu, Jason Ueng, Daniel Hou
*/
:- use_module(library(random)).
:- dynamic player_stats/6.
:- discontiguous describe/1, new_day/0, mag_generator/1.
:- retractall(player_stats(_,_,_,_,_,_)).

% F = fight, M = money, C = cha, I = int, S = stam, D = current day
player_stats(F,M,C,I,S,D).

% List of possible tasks you can do every day
% Generates a random increase for their respective stats, then checks for a random event at the end of the day
% If rest is called, then increase stamina and move directly to next day without calling random event      
sword :- 
        write('You spend the day practicing your swordplay in the field.'), nl,
        mag_generator(MAG), change_stats(0, MAG), random_event.
work :- 
        write('You work parttime at the local tavern and earn some gold.'), nl,
        mag_generator(MAG), change_stats(1, MAG), random_event.
talk :- 
        write('You practice your stand-up routine'), nl,
        mag_generator(MAG), change_stats(2, MAG), random_event.
book :- 
        write('You spend the day in the library, reading'), nl,
        mag_generator(MAG), change_stats(3, MAG), random_event.
rest :-
        write('You decide to take a nap'), nl,
        change_stats(4,_), new_day.

% Displays all of your current stats
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

% Helper function used to retrieve stats
getPlayerStats(F,M,C,I,S,D) :- 
        player_stats(F,M,C,I,S,D).

% sword = 0, book = 1, work = 2, talk = 3, rest = 4
% Depending on the action selected, increase respective stats by MAG and decrease stamina by 1
% If rest is selected, increase stamina by 2
change_stats(ACTION, MAG) :-
        getPlayerStats(F,M,C,I,S,D),
        retract(player_stats(F,M,C,I,S,D)),
        (       ACTION =:= 4 -> S1 is S+2
        ;       ACTION =:= 5 -> F1 is F+MAG, M1 is M+MAG, C1 is C+MAG, I1 is I+MAG, S1 is S+MAG % from event inc/dec stats
        ;       ACTION =:= 0 -> F1 is F+MAG,S1 is S-1
        ;       ACTION =:= 1 -> M1 is M+MAG,S1 is S-1
        ;       ACTION =:= 2 -> C1 is C+MAG,S1 is S-1
        ;       ACTION =:= 3 -> I1 is I+MAG,S1 is S-1
        ),
        (       ACTION =:= 0 -> assert(player_stats(F1,M,C,I,S1,D))
        ;       ACTION =:= 1 -> assert(player_stats(F,M1,C,I,S1,D))
        ;       ACTION =:= 2 -> assert(player_stats(F,M,C1,I,S1,D))
        ;       ACTION =:= 3 -> assert(player_stats(F,M,C,I1,S1,D))
        ;       ACTION =:= 4 -> assert(player_stats(F,M,C,I,S1,D))
        ;       ACTION =:= 5 -> assert(player_stats(F1,M1,C1,I1,S1,D))
        ).

% Randomly determines the increase in stats obtained during daily tasks
mag_generator(RES) :-
        random(MAG),
        (       MAG >= 0, MAG < 0.2 -> RES is 0
        ;       MAG >= 0.2, MAG < 0.75 -> RES is 1
        ;       MAG >= 0.75, MAG < 0.9 -> RES is 2   
        ;       MAG >= 0.9, MAG < 1 -> RES is 3    
        ).

% Randomly determines if we have a random event
% If we have a random event, change their repective stats and move to a new day
% Otherwise move directly to a new day
random_event :-
        random(TRIGGER),
        (       TRIGGER >= 0.99, TRIGGER < 1 -> describe(heart_attack) % event: death
        ;       TRIGGER >= 0.97, TRIGGER < 0.99 -> describe(inc_all), change_stats(5,4), new_day % event: inc all stats
        ;       TRIGGER >= 0.95, TRIGGER < 0.97 -> describe(dec_all), change_stats(5,-3), new_day % event: dec all stats
        ;       TRIGGER >= 0.9, TRIGGER < 0.95 -> describe(drop_your_wallet), change_stats(1,-1), new_day % event: drop my wallet
        ;       TRIGGER >= 0, TRIGGER < 0.9 -> new_day % nothing happens
        ).

% Moves the day forward by one
% if stamina =< 0, or the following day is 30, move to one of the endings
new_day :-
        getPlayerStats(F,M,C,I,S,D),
        retract(player_stats(F,M,C,I,S,D)),
        D1 is D+1,
        assert(player_stats(F,M,C,I,S,D1)),
        number_string(D1,Dstr),
        (       S =< 0 -> describe(sta_heart_attack)
        ;       D1 >= 30 -> end_branch
        ;       write('It is now day '), write(Dstr), nl
        ).

% Determines which ending is visited based on player stats
end_branch :-
        getPlayerStats(F,M,C,I,_,_),
        (       F >= 30 -> describe(str_end) 
        ;       M >= 30 -> describe(mon_end) 
        ;       C >= 30 -> describe(cha_end)
        ;       I >= 30 -> describe(int_end)
        ;       describe(fail_end) 
        ).

% Starts the game
% Initializes the player at day 1 with all stats at 10.
start :-
        retract(player_stats(F,M,C,I,S,D)),
        assert(player_stats(10,10,10,10,10,1)),
        instructions.

% Displays all of the information for the game
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

% Game over description
describe(game_over) :-
        write('Game Over'), nl,nl,
        write('type start. to try again?'), nl.

% Descriptions of random events
describe(inc_all) :- 
        nl,
        write('Random event! You suddenly hear a voice from the heavens as God descends from the heavens and gives you a holy blessing. You feel the power coursing through your veins as bask in the glow of the almighty one. He even rains some gold on you as a small bonus. You gain +4 to all your stats'),
        nl.

describe(dec_all) :-
        nl,
        write('Random event! When you woke up today, you felt completely unmotivated to start the day. Instead of visiting the guild to accept another commission, you visit the tavern where you swig 50 beers. You take a -3 to all your stats'),
        nl.

describe(drop_your_wallet) :-
        nl,
        write('Random event! As you return home, you trip and drop your coin pouch. The coins scatter along the road. You manage to recover some of your coins, but your pouch feels noticeably lighter. You take -1 to your money'),
        nl.


% Descriptions of possible endings and the game over text
describe(str_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon\'s leathery wings. You use an omega-slash and sunder the dragon in twain. The crowd cheers as you dab over the dragon\'s corpse. You saved the village and return a hero!'), nl,
        nl,
        describe(game_over).

describe(int_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon\'s leathery wings. 
                You put on your wizard hat and cast an ice beam spell. It hits the dragon straight in the face and it roars in pain. 
                It breathes fire at you, but you cast a shield spell.  
                Deterred, the dragon grumbles and flies away. You managed to scare the dragon away, but for how long?'), nl,
        nl,
        describe(game_over).

describe(cha_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon\'s leathery wings. You yell at the dragon \'GO AWAY DRAGON! YOU DONT BELONG IN THIS VILLAGE\' The dragon, visibly hurt by your proclamation, flies away. You can\'t quite tell if it is going to come back or not, but you have successfully protected the village from the dragon ... I think?'), nl,
        nl,
        describe(game_over).

describe(mon_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon\'s leathery wings. You figured that if the dragon is here for the gold, maybe you could bribe it with your earnings from your part time job. You place all your savings on the ground. The dragon takes a look and flies off with it. You may have kept the village safe for now, but what about next month?...'), nl,
        nl,
        describe(game_over).

describe(fail_end) :-
        nl,
        write('The day is finally here. The wind is blowing as you hear the flap of the dragon\'s leathery wings. You stand to face the dragon but in your heart of hearts, you know that you cannot defeat it. Whether it was sword fighting or spellcasting, you were pathetic at all of it. You close your eyes and await the inevitable. You are killed by the dragon.'), nl,
        nl,
        describe(game_over).

describe(heart_attack) :-
        nl,
        write('By the way, did you know your family has a history of cardiac arrest? Well as you lie dying on the floor, you know now. Unfortunately, you die of a heart attack.'),
        nl,
        describe(game_over).

describe(sta_heart_attack) :-
        nl,
        write('You worked so hard the past few days, you didn\'t even give yourself an opportunity to rest. As you clutch your chest, all you can think is \'You should have rested more!\' You die of a heart attack'),
        nl,
        describe(game_over).