
%
%   pt.ua.deti.ddr.tp3
% 
%   DDR - Trabalho pratico #3
%
%   Simulador de uma Rede de Comutação de Pacotes.
%

%%
% 
% @parametros
%
%     REP : Número de repetições da simulação
%     NP  : Numero de pacotes em que se baseia o criterio de paragem
%
%
% @saida
%
%     WsMean  : Atraso médio no fluxos (mseg)
%     WsVar   : Variancia do atraso nos fluxos
%     WsInt   : Intervalos de confiança dos atrasos nos fluxos
%
%%


function [ WsMean, WsVar, WsInt ] = tp3_a( Rep, NP )

%Ws = 1 : Rep;

for i = 1 : Rep,
	Ws(i,:) = simRCP( NP );
end;

%  Ws : Atraso médio no fluxo s (mseg)
WsMean = mean( Ws );
WsVar = var( Ws );
z =  norminv(0.95) * sqrt(WsVar ./ Rep);
WsInt = [ WsMean - z ; WsMean + z ];

