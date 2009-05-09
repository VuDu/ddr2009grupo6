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
%     L   : Número médio de clientes no sistema
%     LQ  : Número médio de ocupação da fila de espera
%     
%     W_Dados : Atraso médio no sistema dos pacotes de Dados
%     W_VoIP  : Atraso médio no sistema dos pacotes de VoIP
%     WQ_Dados: Atraso médio na fila de espera dos pacotes de Dados
%     WQ_VoIP : Atraso médio na fila de espera dos pacotes de VoIP
%%

function [L, LQ, W_Dados, W_VoIP, WQ_Dados, WQ_VoIP ] = mg1_g( TCPD, TCPV, TMPD, TMPV , CL)

% Sistema MG1 com prioridade non-preemptive

CapacidadeDaLigacao = ( CL * 1000 * 1000 ) / 8;

NUMERO_DE_AMOSTRAS = 100000;

TemposDeServicoDados = 1 : NUMERO_DE_AMOSTRAS;
TemposDeServicoVoIP  = 1 : NUMERO_DE_AMOSTRAS;

for i = 1: NUMERO_DE_AMOSTRAS
  
  do,
      TamanhoPacote = round( exprnd( TMPD ) );  % Tamanho do pacote em bytes
  until ( TamanhoPacote > 48 && TamanhoPacote < 1500 );
  TemposDeServicoDados(i) = TamanhoPacote / CapacidadeDaLigacao;
  
  TamanhoPacote = round(rand * (220 - 180) + 180);
  TemposDeServicoVoIP(i) = TamanhoPacote / CapacidadeDaLigacao;
end

ES_Dados = mean( TemposDeServicoDados ); 
ES_VoIP  = mean( TemposDeServicoVoIP );
VarDados = var( TemposDeServicoDados );
VarVoIP  = var( TemposDeServicoVoIP );

ESsquareDados = ES_Dados*ES_Dados;
ESsquareVoIP  = ES_VoIP*ES_VoIP;

ES2_Dados = VarDados + ESsquareDados;   % E[S^2] = var[S] + E[S]^2
ES2_VoIP = VarVoIP + ESsquareVoIP;      % E[S^2] = var[S] + E[S]^2

muDados = 1 / ES_Dados;
muVoIP  = 1 / ES_VoIP;

pDados = TCPD/muDados;
pVoIP  = TCPV/muVoIP;

WQ_Dados = ( TCPD*ES2_Dados + TCPV*ES2_VoIP ) / ( 2*(1-pVoIP)*(1-pVoIP-pDados));
WQ_VoIP  = ( TCPD*ES2_Dados + TCPV*ES2_VoIP ) / ( 2*1*(1-pVoIP));

W_Dados = WQ_Dados + ES_Dados;
W_VoIP  = WQ_VoIP  + ES_VoIP;

LQ = TCPD*WQ_Dados + TCPV*WQ_VoIP;
L  = TCPD*W_Dados + TCPV*W_VoIP;


