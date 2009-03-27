
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1 - alineas a), b) e c)
%
% Rep - RepetitionNumber
% N   - CallsNumber

function [PbInt, OmInt, PbMean, OmMean] = tp1exA( Rep, N )

x = 1 : Rep ;
y = 1 : Rep;

for i = 1:Rep,
  [x(i), y(i) ] = tp1( 1, 3, 4, N );
end

PbMean = mean(x);
PbVar  = var(x);

OmMean = mean(y);
OmVar  = var(y);

z =  norminv(0.95) * sqrt(PbVar / Rep);
PbInt = [ PbMean - z , PbMean + z ];
z*2

z =  norminv(0.95) * sqrt(OmVar / Rep);
OmInt = [ OmMean - z, OmMean + z ];
z*2

