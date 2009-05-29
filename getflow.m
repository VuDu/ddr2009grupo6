
%   pt.ua.deti.ddr.tp3
% 
%   DDR - Trabalho pratico #3
%
%   Simulador de Rede com Comutação de Pacotes
%
%

function [Packet, Route] = getflow( Tempo, flowNum )

  FlowPacektTCP(1) = 400;
  FlowPacektTCP(2) = 400;
  FlowPacektTCP(3) = 400;
  FlowPacektTCP(4) = 400;
  FlowPacektTCP(5) = 400;
  FlowPacektTCP(6) = 400;
  FlowPacektTCP(7) = 600;
  FlowPacektTCP(8) = 600;

  FlowRoute( 1, : ) = [ 1, 2, 0 ];
  FlowRoute( 2, : ) = [ 2, 1, 0 ];
  FlowRoute( 3, : ) = [ 1, 4, 0 ];
  FlowRoute( 4, : ) = [ 4, 1, 0 ];
  FlowRoute( 5, : ) = [ 1, 4, 5 ];
  FlowRoute( 6, : ) = [ 5, 4, 1 ];
  FlowRoute( 7, : ) = [ 2, 3, 0 ];
  FlowRoute( 8, : ) = [ 3, 2, 0 ];
  
  
  Chegada = Tempo + exprnd( 1 / FlowPacektTCP(flowNum) );
  % Será que do funciona em Matlab ?? TODO: Verificar isso
  do,
      TamanhoPacote = round( exprnd( 600 ) );  % Tamanho do pacote em bytes
  until ( TamanhoPacote > 48 && TamanhoPacote < 1500 );
  
  Packet = [ Chegada, TamanhoPacote, flowNum ];
  Route  = FlowRoute(flowNum, : );