
%   pt.ua.deti.ddr.tp2
% 
%   DDR - Trabalho pratico #2
%
%   Simulador de Ligacao de Dados.
%
%     Cálculo de M/M/1/3

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
%     Pb     : Probabilidade de Bloqueio
%%

function [ L, W, LQ, WQ, Pb ] = mm13( lambda, TMP, C )

% Taxa de atendimento do serviço
mu = ( (C*1000*1000) / 8 ) / TMP;

% Calculo da probabilidade de estarem exactamente 3 pacotes no sistema.
p0 = 1 / ( 1 + lambda/mu + (lambda*lambda)/(mu*mu) + (lambda^3)/(mu^3) );
p1 = ( lambda / mu ) * p0;
p2 = ( lambda^2 ) / ( mu^2 ) * p0;
p3 = ( lambda^3 ) / ( mu^3 ) * p0; 

Pb = p3; % Pela propriedade PASTA

% Segundo o teorema de Little
L = 0 + 1*p1 + 2*p2 + 3*p3;
W = L / ( lambda*(1-p3) );
WQ= W - 1/mu;
LQ= WQ * ( lambda*(1-p3) );
