
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1
%
% AR - ArrivalRate
% SR - ServiceRate
% CN - ChannelNumber

function PBL = pbl( CN, AR, SR )

p = AR/SR;

dividendo  =  ( p.**CN ) ./ factorial(CN) ;

i = [ 0 : CN ];
divisor    =  sum( ( p.**i ) ./ factorial(i) );

PBL = dividendo / divisor;
