
%
% Função de ajuda...
%


function [Tempo, Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante] = splitstate(STATE)
  
Tempo = STATE(1);
Estado= STATE(2);
PacotesAceites= STATE(3);
PacotesPerdidos=STATE(4);
Atrasos = STATE(5);
AtrasoMaximo = STATE(6);
OcupacaoFila = STATE(7);
IOcupacao = STATE(8);
Instante = STATE(9);