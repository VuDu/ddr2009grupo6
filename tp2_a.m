
%   pt.ua.deti.ddr.tp2
% 
%   DDR - Trabalho pratico #2
%
%   Simulador de Ligacao de Dados.
%
%

%%
% 
% @parametros
%
%     REP : Número de repetições da simulação
%     TCP : Taxa de Chegada de Pacotes ( mu )
%
%     TMP : Tamanho Medio do Pacote ( bytes )
%     CL  : Capacidade da Ligacao ( em Mbps )
%     TFE : Tamanho da Fila de Espera ( em bytes )
%     NP  : Numero de pacotes em que se baseia o criterio de paragem
%
% @saida
%
%     TPD   : Taxa de perda de pacotes
%     AMP   : Atraso medio de pacotes ( ms )
%     AMaxP : Atraso maximo de pacotes ( ms )
%     OMF   : Ocupacao media da fila de espera ( bytes )
%%

function tp2_a( TCP, Rep )

TMP = 600;
CL  = 2;
TFE = 1000000;
NP  = 1000;

TPD   = 1 : Rep;
AMP   = 1 : Rep;
AMaxP = 1 : Rep;
OMF   = 1 : Rep;

for i = 1:Rep,
  [TPD(i), AMP(i), AMaxP(i), OMF(i)] = simLD( TCP, TMP, CL, TFE, NP );
end

AMP   = AMP * 1000;      % seg -> ms
AMaxP = AMaxP * 1000;    % seg -> ms

%     TPD   : Taxa de perda de pacotes
TPDMean   = mean( TPD )
TPDVar    = var( TPD )
z =  norminv(0.95) * sqrt(TPDVar / Rep);
IntTPD = [ TPDMean - z , TPDMean + z ]

%     AMP   : Atraso medio de pacotes
AMPMean   = mean( AMP )
AMPVar    = var( AMP )
z =  norminv(0.95) * sqrt(AMPVar / Rep);
IntAMP = [ AMPMean - z , AMPMean + z ]

%     AMaxP : Atraso maximo de pacotes
AMaxPMean = mean( AMaxP )
AMaxPVar  = var( AMaxP )
z =  norminv(0.95) * sqrt(AMaxPVar / Rep);
IntAMax = [ AMaxPMean - z , AMaxPMean + z ]

%     OMF   : Ocupacao media da fila de espera
OMFMean   = mean( OMF )
OMFVar    = var( OMF )
z =  norminv(0.95) * sqrt(OMFVar / Rep);
IntOMF = [ OMFMean - z , OMFMean + z ]

