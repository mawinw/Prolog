%board(slot,num)
%slot
%[1,2,3]
%[4,5,6]
%[7,8,9]
%startgame()
%swap(pos1,pos2)
%1=2,3
%2=1,3,5
%3=2,6
%4=1,5,7
%5=2,4,6,8
%6=3,5,9
%7=4,8
%8=5,7,9
%9=6,8
%#checkwincondition
s :- start.
start :- gamestart.
gamestart :- generateboard, showboard.
generateboard :- random_permutation([1,2,3,4,5,6,7,8,9],NL), fillinslot(NL).
fillinslot([]).
fillinslot([H|T]) :- length([H|T],N),N10 is 10-N,assertz(board(N10,H)),fillinslot(T).


getboard(N1,N2,N3,N4,N5,N6,N7,N8,N9) :- board(1,N1),board(2,N2),board(3,N3),board(4,N4),board(5,N5),
board(6,N6),board(7,N7),board(8,N8),board(9,N9).
showboard() :- getboard(N1,N2,N3,N4,N5,N6,N7,N8,N9),
	writef("|-------|\n"),
	writef("| %w %w %w |\n",[N1,N2,N3]),
	writef("| %w %w %w |\n",[N4,N5,N6]),
	writef("| %w %w %w |\n",[N7,N8,N9]),
	writef("|-------|\n").

swap(N1,N2) :- 
	board(P1,N1),
	board(P2,N2),
	valid(P1,P2), 
	retract(board(P1,N1)), 
	retract(board(P2,N2)), 
	assertz(board(P1,N2)), 
	assertz(board(P2,N1)), 
	showboard,
	checkwincondition.

swap(N1,N2) :- 
	board(P1,N1),
	board(P2,N2),
	\+valid(P1,P2),
	showboard,
	checkwincondition.

valid(1,2).
valid(1,4).
valid(2,1).
valid(2,3).
valid(2,5).
valid(3,2).
valid(3,6).
valid(4,1).
valid(4,5).
valid(4,7).
valid(5,2).
valid(5,4).
valid(5,6).
valid(5,8).
valid(6,3).
valid(6,5).
valid(6,9).
valid(7,4).
valid(7,8).
valid(8,5).
valid(8,7).
valid(8,9).
valid(9,6).
valid(9,8).
/*
0 1 2 i
3 4 5
6 7 8
j

3*i+j
abs(i1-i2)+abs(j1-j2)=1













*/
valid(P1, P2):-
	X1 is (P1-1) div 3,
	X2 is (P2-1) div 3,
	Y1 is (P1-1) mod 3,
	Y2 is (P2-1) mod 3,
	1 is abs(X1-X2) + abs(Y1-Y2).

valid(P1, P2):- P1 > P2, valid(P2, P1).
valid(P1, P2):- R is P2 mod 3, R /== 0, P2 is P1 + 1.
valid(P1, P2):- P1 <= 6, P2 is P1 + 3.

checkwincondition :- getboard(1,2,3,4,5,6,7,8,9), writef("\n\n\t!! YOU WIN !!\n\n").
checkwincondition.

processgame:- writef("Enter Number 1 -> "),read(X),nl,
			  writef("Enter Number 2 -> "),read(Y),nl,nl,nl, swap(X,Y),nl,
			  processgame.

:- dynamic board/2.
:- writef("\t\t !!WELCOME TO SWAPBOARD!!").
:- writef("\n\n\t YOU HAVE TO SWAP NUMBERS ON THE BOARD\n\tUNTIL THE BOARD IS ARRANGED IN ORDER!").
:- writef("\n\n HERE IS YOUR STARTING BOARD!\n").
:- s.
:- writef("\nYOU WILL INSERT TWO NUMBERS").
:- writef("\n\tIF TWO NUMBERS ON THE BOARD IS HORIZONTALLY OR VERTICALLY TO EACH OTHER,\n\t\t\tTHOSE TWO NUMBERS WILL WE SWAPPED!\n\n").
:- processgame.
