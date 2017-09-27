%% @author Alena
%% @doc @todo Add description to ackerman.


-module(ackerman).

%% ====================================================================
%% API functions
%% ====================================================================
-export([ackerman/2, valueList/2]).

ackerman(0, N)-> N+1;
ackerman(M, 0)->ackerman(M-1,1);
ackerman(M, N) when M>0 andalso N>0 -> ackerman(M-1, ackerman(M, N-1)).

valueList(0,N)->innerList(0,N);
valueList(M,N)->valueList(M-1,N)++innerList(M,N).


%% ====================================================================
%% Internal functions
%% ====================================================================
innerList(M,0)->[[M,0,ackerman(M, 0)]];
innerList(M,N)->innerList(M,N-1)++[[M,N,ackerman(M, N)]].
