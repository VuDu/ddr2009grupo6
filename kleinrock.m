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

lambda(1,2) = 400 + 400;
lambda(2,1) = 400 + 400;

lambda(2,3) = 1000 + 400;
lambda(3,2) = 1000 + 400;

lambda(3,5) = 400;
lambda(5,3) = 400;

lambda(1,4) = 400;
lambda(4,1) = 400;
 
%  mu
mu = [ 0, 0, 0, 0, 0, 0, 0, 0 ];
for i = 1 : 8,
	mu(i) = ((10000000 / 8) / TamMedPacote);  % pacotes/segundo
end;

% Fluxo 1
Ws(1) = ( 1/( mu(1) - lambda(1,2) ) )*1000;
Ws(2) = ( 1/( mu(2) - lambda(2,1) ) )*1000; 
Ws(3) = ( 1/( mu(3) - lambda(1,4) ) )*1000; 
Ws(4) = ( 1/( mu(4) - lambda(4,1) ) )*1000;
Ws(5) = ( 1/( mu(1) - lambda(1,2) ) + 1/( mu(1) - lambda(2,3) ) + 1/( mu(1) - lambda(3,5) ) )*1000; 
Ws(6) = ( 1/( mu(1) - lambda(2,1) ) + 1/( mu(1) - lambda(3,2) ) + 1/( mu(1) - lambda(3,5) ) )*1000; 
Ws(7) = ( 1/( mu(7) - lambda(2,3) ) )* 1000;
Ws(8) = ( 1/( mu(8) - lambda(3,2) ) )* 1000;



