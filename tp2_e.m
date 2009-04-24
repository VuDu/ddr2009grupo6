
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
%     TCPD : Taxa de Chegada de Pacotes de Dados ( lambda )
%     TCPV : Taxa de Chegada de Pacotes VoIP ( lambda )
%     TMPD : Tamanho Medio do Pacote de Dados ( bytes )
%     TMPV : Tamanho Medio do Pacote VoIP ( bytes )
%     TFE : Tamanho da Fila de Espera ( bytes )
%     REP : Número de repetições da simulação
%
%     CL  : Capacidade da Ligacao ( Mbps )
%     NP  : Numero de pacotes em que se baseia o criterio de paragem
%
% @saida
%
%     TPD   : Taxa de perda de pacotes
%     AMP   : Atraso medio de pacotes ( ms )
%     AMaxP : Atraso maximo de pacotes ( ms )
%     OMF   : Ocupacao media da fila de espera ( bytes )
%%

function tp2_e( TCPD, TCPV, TMPD, TMPV, TFE, Rep )

CL  = 2;
%TFE = 1000000;
NP  = 1000;

TPDDados   = 1 : Rep;
TPDVoIP    = 1 : Rep;
AMPDados   = 1 : Rep;
AMPVoIP    = 1 : Rep;
AMaxPDados = 1 : Rep;
AMaxPVoIP  = 1 : Rep;
OMF   = 1 : Rep;

for i = 1:Rep,
  [ TPDDados(i), TPDVoIP(i), AMPDados(i), AMPVoIP(i), AMaxPDados(i), AMaxPVoIP(i), OMF(i) ] = simLD( TCPD, TCPV, TMPD, TMPV, CL, TFE, NP );
end

AMPDados   = AMPDados * 1000;      % seg -> ms
AMaxPDados = AMaxPDados * 1000;    % seg -> ms

AMPVoIP   = AMPVoIP * 1000;      % seg -> ms
AMaxPVoIP = AMaxPVoIP * 1000;    % seg -> ms


%     TPD   : Taxa de perda de pacotes
TPDMeanDados   = mean( TPDDados )
TPDVarDados    = var( TPDDados )
z =  norminv(0.95) * sqrt(TPDVarDados / Rep);
IntTPDDados = [ TPDMeanDados - z , TPDMeanDados + z ]

TPDMeanVoIP   = mean( TPDVoIP )
TPDVarVoIP    = var( TPDVoIP )
z =  norminv(0.95) * sqrt(TPDVarVoIP / Rep);
IntTPDVoIP = [ TPDMeanVoIP - z , TPDMeanVoIP + z ]


%     AMP   : Atraso medio de pacotes
AMPMeanDados   = mean( AMPDados )
AMPVarDados    = var( AMPDados )
z =  norminv(0.95) * sqrt(AMPVarDados / Rep);
IntAMPDados = [ AMPMeanDados - z , AMPMeanDados + z ]

AMPMeanVoIP   = mean( AMPVoIP )
AMPVarVoIP    = var( AMPVoIP )
z =  norminv(0.95) * sqrt(AMPVarVoIP / Rep);
IntAMPVoIP = [ AMPMeanVoIP - z , AMPMeanVoIP + z ]


%     AMaxP : Atraso maximo de pacotes
AMaxPMeanDados = mean( AMaxPDados )
AMaxPVarDados  = var( AMaxPDados )
z =  norminv(0.95) * sqrt(AMaxPVarDados / Rep);
IntAMaxDados = [ AMaxPMeanDados - z , AMaxPMeanDados + z ]

AMaxPMeanVoIP = mean( AMaxPVoIP )
AMaxPVarVoIP  = var( AMaxPVoIP )
z =  norminv(0.95) * sqrt(AMaxPVarVoIP / Rep);
IntAMaxVoIP = [ AMaxPMeanVoIP - z , AMaxPMeanVoIP + z ]

%     OMF   : Ocupacao media da fila de espera
OMFMean   = mean( OMF )
OMFVar    = var( OMF )
z =  norminv(0.95) * sqrt(OMFVar / Rep);
IntOMF = [ OMFMean - z , OMFMean + z ]

OMFMeanDados   = mean( OMFDados )
OMFVarDados    = var( OMFDados )
z =  norminv(0.95) * sqrt(OMFVarDados / Rep);
IntOMFDados = [ OMFMeanDados - z , OMFMeanDados + z ]

OMFMeanVoIP   = mean( OMFVoIP )
OMFVarVoIP    = var( OMFVoIP )
z =  norminv(0.95) * sqrt(OMFVarVoIP / RepVoIP);
IntOMFVoIP = [ OMFMeanVoIP - z , OMFMeanVoIP + z ]

