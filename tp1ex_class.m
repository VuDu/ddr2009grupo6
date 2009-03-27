
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1 - alineas e) e f)
%
% Rep - RepetitionsNumber: Numero de repeticoes da simulacao
% N   - CallsNumber:  Numero total de chamadas
% R   - ReservedResources: Numero de canais reservados da classe B

function [PbAInt, PbBInt, OmInt, PbAMean, PbBMean, OmMean] = tp1ex_class( Rep, N, R )

%Rep = 10;

x = 1 : Rep;
y = 1 : Rep;
z = 1 : Rep;

for i = 1:Rep,
  [x(i), y(i), z(i) ] = tp1_class( 60/140 , 1, 3 , 16, N, R );
end

PbAMean = mean(x);
PbAVar  = var(x);

PbBMean = mean(y);
PbBVar  = var(y);

OmMean = mean(z);
OmVar  = var(z);

z =  norminv(0.95) * sqrt(PbAVar / Rep);
PbAInt = [ PbAMean - z , PbAMean + z ];  
z*2

z =  norminv(0.95) * sqrt(PbBVar / Rep);
PbBInt = [ PbBMean - z , PbBMean + z ]; 
z*2 

z =  norminv(0.95) * sqrt(OmVar / Rep);
OmInt = [ OmMean - z, OmMean + z ];
z*2

