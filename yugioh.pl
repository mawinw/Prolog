:- dynamic lifepoint/2.
:- dynamic hand/2.
:- dynamic field/5.

lifepoint(1,20).
lifepoint(2,20).

%deck(1,[]).
%deck(2,[]).

%gamecondition()
%playerturn(player)
%cansummon(player)

%card(cardnumber,atk,def)

card(X,0,0) :- X=<0.
card(1,1,1).
card(X,X1,1) :- X=<5, X1 is X+3. %atk+3
card(X,X1,2) :- X=<10, X1 is X-3. %atk+2
card(X,X1,3) :- X=<15, X1 is X-10. %neutral
card(X,X1,4) :- X=<20, X1 is X-15. %neutral
card(X,X1,5) :- X=<25, X1 is X-21. %atk-1
 

%hand(player,cardlist)
hand(1,[]).
hand(2,[]).


%showhand(player).
showhand(X):- hand(X,L), showhand(X,L).
showhand(X,[]) :- true.
showhand(X,[H|T]) :- card(H,A,D),writef("Card No. %w\t | ATK %w\t | DEF %w\n",[H,A,D]), showhand(X,T).


%field(playerfield,slot,cardnumber,mode,canattack)
field(1,1,0,0,0).
field(1,2,0,0,0).
field(1,3,0,0,0).
field(2,1,0,0,0).
field(2,2,0,0,0).
field(2,3,0,0,0).

%gamestart(firstplayer)
start(X) :- gamestart(X).
gamestart(X) :- generatedeck(), drawinitial(), draw(X), writef("GAME STARTED\n DECK GENERATED\n PLAYER %w DRAWS\n PLAYER %w's MAIN PHASE.\n",[X,X]),assertz(playerturn(X)),assertz(cansummon(X)),showhand(X),assertz(turn(X)).


%generatedeck
generatedeck() :- generatedeck([],40).
generatedeck(L,0) :- assertz(deck(1,L)),random_permutation(L,NL),assertz(deck(2,NL)).
generatedeck(L,N) :- random(1,25,R1),N1 is N-1,generatedeck([R1|L],N1).
%drawinitial = draw 5
drawinitial() :- drawinitial(5).
drawinitial(0) :- true.
drawinitial(N) :- draw(1),draw(2),N1 is N-1, drawinitial(N1).
%draw(player)
draw(X) :- deck(X,[NC|T]),hand(X,OCL),retract(hand(X,_)),assertz(hand(X,[NC|OCL])),retract(deck(X,_)),assertz(deck(X,T)).
%summon(card,placemode,slot) & once per turn
%field(playerfield,slot,cardnumber,mode,canattack)
summon:-write("summon(cardnumber,placemode(1:attack,2:defense),slot(1,2,3))"),fail.
summon(X) :- summon.
summon(X,Y):-summon.
summon(X,1,S) :- turn(1),playerturn(N),cansummon(N),field(N,S,0,_,_),hand(N,H),member(X,H),retract(field(N,S,0,_,_)),assertz(field(N,S,X,1,0)),retract(cansummon(N)),rmfirst(H,X,H1),retract(hand(N,H)),assertz(hand(N,H1)). %atk mode & first turn
summon(X,1,S) :- playerturn(N),cansummon(N),field(N,S,0,_,_),hand(N,H),member(X,H),retract(field(N,S,0,_,_)),assertz(field(N,S,X,1,1)),retract(cansummon(N)),rmfirst(H,X,H1),retract(hand(N,H)),assertz(hand(N,H1)). %atk mode
summon(X,2,S) :- playerturn(N),cansummon(N),field(N,S,0,_,_),hand(N,H),member(X,H),retract(field(N,S,0,_,_)),assertz(field(N,S,X,2,0)),retract(cansummon(N)),rmfirst(H,X,H1),retract(hand(N,H)),assertz(hand(N,H1)). %def mode

%showfield(playerfield)
showfield :-writelabel,writeline(1),writeline(2),writeline(3).
writelabel:-write("[CARD NO] \t[ATK] \t[DEF] \t[MODE] \t| [CARD NO] \t[ATK] \t[DEF] \t[MODE]\n\t\t\t\t\t|\n").
writeline(X):-writecardfield(1,X),write("\t| "),writecardfield(2,X),write("\n").
writecardfield(N,S):-field(N,S,0,M,CA), writef("\t\t\t\t").
writecardfield(N,S):-field(N,S,CNO,M,CA),card(CNO,A,D),modetext(M,MT),canatktext(CA,CAT), writef("   %w%w\t\t  %w\t  %w\t  %w",[CNO,CAT,A,D,MT]).

% write("[CARD NO] \t[ATK] \t[DEF] \t[MODE]\n\n"), field(1,S,X,M,CA),card(X,A,D),modetext(M,MT),canatktext(CA,CAT),readyatktext(, writef("    %w%w\t\t  %w\t  %w\t  %w | ",[X,CAT,A,D,MT]).

%command_attack(monsterinfield,defendingmonster)
modetext(1,"ATK").
modetext(2,"DEF").
canatktext(1,"(!)").
canatktext(0,"").

%destroymonster
%deducthp(player,damage)

%endturn

%checkinlist

%rmfirst
rmfirst([X|L],X,L).
rmfirst([X|L],A,[X|TL]):- rmfirst(L,A,TL).