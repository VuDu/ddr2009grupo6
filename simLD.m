
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
%     TCP : Taxa de Chegada de Pacotes ( mu )
%     TMP : Tamanho Medio do Pacote ( b )
%     CL  : Capacidade da Ligacao ( em Mbps )
%     TFE : Tamanho da Fila de Espera ( em bytes )
%     NP  : Numero de pacotes em que se baseia o criterio de paragem
%
% @saida
%
%     TPD   : Taxa de perda de pacotes
%     AMP   : Atraso medio de pacotes
%     AMaxP : Atraso maximo de pacotes
%     OMF   : Ocupacao media da fila de espera
%%
function [TPD, AMP, AMaxP, OMF] = simLD( TCP, TMP, CL, TFE, NP )

% Constantes do sistema

SISTEMA_LIVRE   = 0;
SISTEMA_OCUPADO = 1;

% Variaveis do sistema

Estado = SISTEMA_LIVRE;

TotalPacotes    = 0;
PacotesAceites  = 0;
PacotesPerdidos = 0;

Atrasos      = 0;
AtrasoMaximo = 0;

OcupacaoFila = 0;
IOcupacao    = 0;

Instante = 0;   % Instante de tempo em que o pacote 
                % entra no sistema para ser transmitido

FilaDeEspera = [ ];

% -- variaveis temporais -- %
Tempo = 0;

Chegada = Tempo + eprnd( 1 / TCP );
Partida = Inf;


% -- Ciclo da Simulacao -- %
while ( TotalPacotes < NP )

  if ( Chegada < Partida )
    % -- Temos uma chegada -- %
    TempoUltimoInstante = Tempo;
    %TotalFila =

    IOcupacao = IOcupacao + 

  end;

end;
