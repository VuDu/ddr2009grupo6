
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
CapacidadeDaLigacao = CL * 1000 * 1000;   % Capacidade da ligação em bits por segundo 
TamanhoDaFilaDeEspera = TFE * 8;          % Tamanho da fila de espera em bits
TempoMedioChegadaPacotes = 1 / TCP;

Estado = SISTEMA_LIVRE;

TotalPacotes    = 0;
PacotesAceites  = 0;
PacotesPerdidos = 0;

Atrasos      = 0;
AtrasoMaximo = 0;

OcupacaoFila = 0;   % Ocupação da fila em *bits*
IOcupacao    = 0;   % Integral da ocupação da fila de espera em *bits*

Instante = 0;   % Instante de tempo em que o pacote 
                % entra no sistema para ser transmitido

FilaDeEspera = [ ];

% -- variaveis temporais -- %
Tempo = 0;

Chegada = Tempo + eprnd( 1 / TCP );
Partida = Inf;


% -- Ciclo da Simulacao -- %
while ( TotalPacotes < NP ),

  if ( Chegada < Partida )
    % -- Temos uma chegada -- %
    TempoUltimoInstante = Tempo;
    Tempo = Chegada;
    %TotalFila =
    IOcupacao = IOcupacao + OcupacaoFila * (Tempo - TempoUltimoInstante);
    TamanhoPacote = exprnd( TMP ) * 8;  % Tamanho do pacote em bits
    TotalPacotes = TotalPacotes + 1;
    Chegada = Tempo + exprnd( TempoMedioChegadaPacotes );   % Agendar próxima chegada 
    
    if ( Estado == SISTEMA_LIVRE )
      Estado = SISTEMA_OCUPADO;
      Instante = Tempo;
      Partida  = Tempo + (CapacidadeDaLigacao / TamanhoPacote );
    else
      if ( (TamanhoPacote + OcupacaoFila) > TamanhoDaFilaDeEspera  )
        PacotesPerdidos = PacotesPerdidos + 1;
      else
        FilaDeEspera = [ FilaDeEspera; [ Tempo, TamanhoPacote ]  ];
        OcupacaoFila = OcupacaoFila + TamanhoPacote;
      end;
    end;
    
  else % else ( Chegada < Partida )
    % -- Temos uma Partida -- %
    TempoUltimoInstante = Tempo;
    Tempo = Partida;
    IOcupacao = IOcupacao + OcupacaoFila * (Tempo - TempoUltimoInstante);
    
    % Actualizar Atrasos e Atraso Máximo
    AtrasoActual = ( Tempo - Instante );
    Atrasos = Atrasos + AtrasoActual;
    
    if ( AtrasoMaximo < AtrasoActual )
      AtrasoMaximo = AtrasoActual;
      
    PacotesAceites = PacotesAceites + 1;
    if ( PacotesAceites >= NP )
      break;  % Sair da Simulação
    
    Partida = Inf;  % Retirar partida da Lista de Eventos
    if ( OcupacaoFila > 0 )
      [ Instante, TamanhoPacote ] = FilaDeEspera(1);
      Partida  = Tempo + (CapacidadeDaLigacao / TamanhoPacote );
      FilaDeEspera = FilaDeEspera(2:length(FilaDeEspera));
      
      OcupacaoFila = OcupacaoFila - TamanhoPacote;
    else
      Estado = SISTEMA_LIVRE;
    end;

  end; % end ( Chegada < Partida )

end;
