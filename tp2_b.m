
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
%     TCP : Taxa de Chegada de Pacotes ( lambda )
%
% @saida
%
%     TPD   : Taxa de perda de pacotes
%     AMP   : Atraso medio de pacotes ( ms )
%     AMaxP : Atraso maximo de pacotes ( ms )
%     OMF   : Ocupacao media da fila de espera ( bytes )
%
%     NMF   : Número médio de pacotes na fila de espera
%%

function tp2_b( TCP, TFE, Rep )

tam_pacote = 600;    % ( bytes )
lambda = TCP;
mu = (( 2 * 1000 * 1000 ) / 8 ) / tam_pacote;   % ( pacotes/seg )


tp2_a( TCP, TFE, Rep );

[ L, W, LQ, WQ ] = mm1( mu, lambda );

L = L * tam_pacote     % ( bytes )
LQ = LQ * tam_pacote   % ( bytes )
W = W * 1000           % ( ms )
WQ = WQ * 1000         % ( ms )


