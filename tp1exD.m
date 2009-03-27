
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1 - alinea d)
%
% Rep - RepetitionNumber
% N   - CallsNumber

function [PbInt1, OmInt1, PbMean1, OmMean1, PbInt2, OmInt2, PbMean2, OmMean2] = tp1exD( Rep, N )

%Rep = 10;

x = 1 : Rep ;
y = 1 : Rep;

for i = 1:Rep,
  [ w(i), x(i), y(i), z(i) ] = tp1D( 1, 3, 4, N );
end

PbMean1 = mean(w);
PbVar1  = var(w);

OmMean1 = mean(x);
OmVar1  = var(x);


PbMean2 = mean(y);
PbVar2  = var(y);

OmMean2 = mean(z);
OmVar2  = var(z);

z =  norminv(0.95) * sqrt(PbVar1 / Rep);
PbInt1 = [ PbMean1 - z , PbMean1 + z ];
z*2

z =  norminv(0.95) * sqrt(OmVar1 / Rep);
OmInt1 = [ OmMean1 - z, OmMean1 + z ];
z*2


z =  norminv(0.95) * sqrt(PbVar2 / Rep);
PbInt2 = [ PbMean2 - z , PbMean2 + z ];
z*2

z =  norminv(0.95) * sqrt(OmVar2 / Rep);
OmInt2 = [ OmMean2 - z, OmMean2 + z ];
z*2


