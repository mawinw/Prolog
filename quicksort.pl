%quicksort
%append/3 list1 + list 2 return list 3
%random_member list , returnedelement
quicksort([],[]).
quicksort(L,A) :- random_member(P,L),rmfirst(L,P,LN), partition(LN,L1,L2,P),quicksort(L1,A1),quicksort(L2,A2), append(A1,[P|A2],A).


partition([],[],[],_).
partition([H|LN],[H|L1],L2,P) :- H=<P, partition(LN,L1,L2,P).
partition([H|LN],L1,[H|L2],P) :- H>P, partition(LN,L1,L2,P).

rmfirst([X|L],X,L).
rmfirst([X|L],A,[X|L1]) :- rmfirst(L,A,L1).