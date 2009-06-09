%
%   pt.ua.deti.ddr.tp2
% 
%   DDR - Trabalho pratico #3
%
%   Simulador de uma Rede de Comutação de Pacotes.
%

%%
%
% @saida
%
%     Ws     : Atraso médio no fluxo s (mseg)
%
%%

function [ Ws ] = kleinrock( )


TamMedPacote = 600;  % bytes
CapacidadeLigacao = 10000000;  % bits/seg


%  fluxos
fluxos = [ 400, 400, 400, 400, 400, 400, 1000, 1000 ];  % pacotes/seg

%  lambda
lambda = [ 400, 400, 400, 400, 800, 800, 1000, 1000 ];  % pacotes/seg

%  mu
mu = [ 0, 0, 0, 0, 0, 0, 0, 0 ];
for i = 1 : 8,
	mu(i) = ((10000000 / 8) / TamMedPacote);  % pacotes/segundo
end;

%  L
L = [  0, 0, 0, 0  ];
for i = 1 : 8,
	L(i) = lambda(i) / (mu(i) - lambda(i));  % pacotes/segundo
end;

%  Ws
Ws = [ 0, 0, 0, 0, 0, 0, 0, 0 ];
for i = 1 : 4,
    Ws(i) = ( 1 / ( mu(i) - lambda(i) ) ) * 1000;  % mseg
end;
Ws(5) = ( ( 1 / ( mu(3) - lambda(3) ) ) + ( 1 / ( mu(5) - lambda(5) ) ) ) * 1000;  % mseg
Ws(6) = ( ( 1 / ( mu(6) - lambda(6) ) ) + ( 1 / ( mu(4) - lambda(4) ) ) ) * 1000;  % mseg
for i = 7 : 8,
    Ws(i) = ( 1 / ( mu(i) - lambda(i) ) ) * 1000;  % mseg
end;


