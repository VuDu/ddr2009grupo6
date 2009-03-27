
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1
%
% AR - ArrivalRate
% SR - ServiceRate
% CN - ChannelNumber

function OML = oml( CN, AR, SR )

i = [ 1 : CN ];

p = AR/SR;
dividendo  =  sum( ( p.**i ) ./ factorial(i - 1) );

i = [ 0 : CN ];
divisor    =  sum( ( p.**i ) ./ factorial(i) );

OML = dividendo / divisor;
