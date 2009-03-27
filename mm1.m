
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
%     mu     : Taxa de atendimento dos clientes no sistema
%     lambda : Taxa de chegada de clientes ao sistema
%
% @saida
%
%     L      : Número médio de clientes no sistema
%     W      : Atraso médio no sistema
%     WQ     : Atraso médio na fila de espera
%     LQ     : Número médio de clientes na fila de espera
%%

function [ L, W, LQ, WQ ] = mm1( mu, lambda )

L = lambda / ( mu - lambda );

W = L / lambda;

WQ = W - ( 1 / mu );

LQ = lambda * WQ;

