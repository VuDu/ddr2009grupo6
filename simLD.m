
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
%     TCP : Taxa de Chegada de Pacotes ( lambda )
%     TCPV: Taxa de Cegada de Pacotes VoIP
%     TMP : Tamanho Medio do Pacote ( em bytes )
%     TMPV: Tamanho Medio do Pacote VoIP ( em bytes )
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
function [TPD, AMP, AMaxP, OMF] = simLD( TCP, TCPV, TMP, TMPV, CL, TFE, NP )

% Constantes do sistema

SISTEMA_LIVRE   = 0;
SISTEMA_OCUPADO = 1;

TYPE_DATA = 0;
TYPE_VOIP = 1;

% Variaveis do sistema
CapacidadeDaLigacao = ( CL * 1000 * 1000 ) / 8;   % Capacidade da ligação em bytes por segundo 
TamanhoDaFilaDeEspera = TFE;                      % Tamanho da fila de espera em bytes
TempoMedioChegadaPacotes = 1 / TCP;
TempoMedioChegadaPacotesVoIP = 1 / TCPV;

Estado = SISTEMA_LIVRE;

TotalPacotes    = 0; % FUTURE USE ??
PacotesAceites  = 0;
PacotesPerdidos = 0;

Atrasos      = 0;
AtrasoMaximo = 0;

OcupacaoFila = 0;   % Ocupação da fila em *bytes*
IOcupacao    = 0;   % Integral da ocupação da fila de espera em *bytes*

Instante = 0;   % Instante de tempo em que o pacote 
                % entra no sistema para ser transmitido

FilaDeEspera = [ ];

% -- variaveis temporais -- %
Tempo = 0;

% Gerar chegadas aleatorias das chamadas de ambas as classes
VoIPtime = rnd * (1.5*TempoMedioChegadaPacotesVoIP - 0.5*TempoMedioChegadaPacotesVoIP) +
           ( 0.5* TempoMedioChegadaPacotesVoIP );

Chegada = [ [exprnd( TempoMedioChegadaPacotes ), TYPE_DATA ];
            [VoIPtime, TYPE_VOIP] ];
% Ordenar as chegadas das chamadas por ordem crescente
[s, i] = sort( Chegada(:,1) );
Chegada = Chegada(i,:);

Partida = [Inf , TYPE_DATA] ;


% -- Ciclo da Simulacao -- %
while ( 1 ),

  if ( Chegada(1,1) < Partida(1,1) )
    % -- Temos uma chegada -- %
    TempoUltimoInstante = Tempo;
    Tempo = Chegada;
    %TotalFila =
    IOcupacao = IOcupacao + OcupacaoFila * (Tempo - TempoUltimoInstante);
    
    if ( Chegada(1,2) == TYPE_DATA )
      % -- Pacote do tipo de dados -- %
      do,
      TamanhoPacote = round( exprnd( TMP ) );  % Tamanho do pacote em bytes
      until ( TamanhoPacote > 48 && TamanhoPacote < 1500 );

      TotalPacotes = TotalPacotes + 1
      ;
      % Calcula a proxima chegada de chamada
      ProximaChegada = Tempo + exprnd( TMP );
      % Remover a chamada actual e adicionar a proxima chamada ordenadamente
      Chegada = [ Chegada(2:end,:) ; [ ProximaChegada, TYPE_DATA] ];
      [s, i] = sort( Chegada(:,1) );
      Chegada = Chegada(i,:);

      if ( Estado == SISTEMA_LIVRE )
        Estado = SISTEMA_OCUPADO;
        Instante = Tempo;
        ProximaPartida  = Tempo + ( TamanhoPacote / CapacidadeDaLigacao );
        % Adiciona ordenadamente o fim da chamada
        Partida = [ Partida ; [ ProximaPartida, CLASS_A ] ];
        [s, i] = sort( Partida(:,1) );
        Partida = Partida(i,:);
      else
        if ( (TamanhoPacote + OcupacaoFila) > TamanhoDaFilaDeEspera  )
          PacotesPerdidos = PacotesPerdidos + 1;
        else
          FilaDeEspera = [ FilaDeEspera ; [ Tempo, TamanhoPacote ]  ];
          OcupacaoFila = OcupacaoFila + TamanhoPacote;
        end;
      end;
      
    else % if ( chegada == TYPE_DATA )
      % -- Pacote do tipo VoIP -- %
    end; %end if ( chegada == TYPE_DATA )
    
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
    end;
      
    PacotesAceites = PacotesAceites + 1;
    if ( PacotesAceites >= NP )
      break;  % Sair da Simulação
    end;
    Partida = Inf;  % Retirar partida da Lista de Eventos
    if ( OcupacaoFila > 0 )
      Instante = FilaDeEspera(1,1);
      TamanhoPacote = FilaDeEspera(1,2);
      Partida  = Tempo + ( TamanhoPacote / CapacidadeDaLigacao );
      FilaDeEspera = FilaDeEspera(2:end,:);
      
      OcupacaoFila = OcupacaoFila - TamanhoPacote;
    else
      Estado = SISTEMA_LIVRE;
    end;

  end; % end ( Chegada < Partida )

end;

TPD = PacotesPerdidos / ( PacotesAceites + PacotesPerdidos);
AMP = Atrasos / PacotesAceites;
AMaxP = AtrasoMaximo;
OMF = IOcupacao / Tempo;
