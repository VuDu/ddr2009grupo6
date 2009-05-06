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
%     CL   : Capacidade da Ligação ( Mbits/s)
%
% @saida
%
%     AtrasoClasseVoip : Atraso na fila de espera dos pacotes da Classe VoIP
%     AtrasoClasseDados: Atraso na fila de espera dos pacotes da Classe Dados
%%

function mg1_g( TCPD, TCPV, TMPD, TMPV , CL)

% Sistema MG1 com prioridade non-preemptive

CapacidadeDaLigacao = ( CL * 1000 * 1000 ) / 8

% p Para cada class de prioridade 
% p1 - Classe com maior prioridade (Classe 1 - VoIP)
mu1 = CapacidadeDaLigacao /TMPV
p1 = TCPV / mu1
% p2 - Classe com menor prioridade (Classe 2 - Dados)
mu2 = CapacidadeDaLigacao /TMPD
p2 = TCPD / mu2

% Segundo momento da Classe 1
ES2_1 = 1/ (mu1*mu1)
% Segundo momento da Classe 2
ES2_2 = 2 / (mu2*mu2)

% Sumatório de : momento * taxa de chegada
sumMomento = TCPV*ES2_1 + TCPD*ES2_2;

% Atraso médio na fila de espera
AtrasoClasseVoip = sumMomento / ( 2*( 1 )*( 1 - p1 ) )
AtrasoClasseDados = sumMomento / ( 2*(1 - p1)*(1 - p1 - p2) ) 
