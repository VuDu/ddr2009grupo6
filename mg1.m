
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
%     lambda : Taxa de chegada de pacotes 
%     TMP    : Tamanho médio do pacote
%     C      : Capacidade da ligação em Mb
%
% @saida
%
%     L      : Número médio de clientes no sistema
%     W      : Atraso médio no sistema
%     WQ     : Atraso médio na fila de espera
%     LQ     : Número médio de clientes na fila de espera
%%

function [ L, W, LQ, WQ ] = mg1( lambda, TMP, C )

NUMERO_DE_AMOSTRAS = 1000000;

TemposDeServico = 1 : NUMERO_DE_AMOSTRAS;

for i = 1: NUMERO_DE_AMOSTRAS
  
  do,
      TamanhoPacote = round( exprnd( TMP ) );  % Tamanho do pacote em bytes
  until ( TamanhoPacote > 48 && TamanhoPacote < 1500 );
  
  TemposDeServico(i) = TamanhoPacote / ( (C*1000*1000)/8 );
end


ES        = mean(TemposDeServico);    % E[S]   - Média dos tempos de serviço
ESsquare  = ES*ES;                    % E[S]^2
Var       = var(TemposDeServico);     % var[S]
ES2       = Var + ESsquare;           % E[S^2] = var[S] + E[S]^2

W = (lambda * ES2) / ( 2*(1-lambda*ES) ) + ES;
WQ= W - ES;
LQ= lambda * WQ;
L = lambda * W;





