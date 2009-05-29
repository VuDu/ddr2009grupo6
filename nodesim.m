%   pt.ua.deti.ddr.tp3
% 
%   DDR - Trabalho pratico #3
%
%   Simulador de Rede com Comutação de Pacotes
%
%

%%
% 
% @parametros
%
%     QUEUE : Fila de espera do nó simulado.
%     STATE : Estado interno do nó.
%     PACKET: Pacote de entrada.
%     TIME  : Momento no tempo da simulação
%     TFE : Tamanho da Fila de Espera ( em bytes )
%
% @saida
%
%
%%
function [ nQUEUE, nSTATE, OUTPACKET, OUTROUTE ] = nodesim( NID, QUEUE, STATE, PACKET, ROUTE, TIME, TFE )


  % Constantes do sistema

  SISTEMA_LIVRE   = 0;
  SISTEMA_OCUPADO = 1;

  % Variaveis do sistema
  CapacidadeDaLigacao = ( CL * 1000 * 1000 ) / 8;   % Capacidade da ligação em bytes por segundo 
  TamanhoDaFilaDeEspera = TFE;                      % Tamanho da fila de espera em bytes
  TempoMedioChegadaPacotes = 1 / TCP;

  % Variaveis de Estado do nó .. isto está mal..
  [ Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante ] = STATE;

  FilaDeEspera = QUEUE;

  % -- variaveis temporais -- %
  Tempo = TIME;

  if ( PACKET == [] ) 
    Chegada = Tempo;
    Partida = Inf;
  else
    Chegada = Inf;
    Partida = Tempo;
  end if


  % -- Ciclo da Simulacao -- %

    if ( Chegada < Partida )
      % -- Temos uma chegada -- %
      TempoUltimoInstante = Tempo;
      Tempo = Chegada;

      IOcupacao = IOcupacao + OcupacaoFila * (Tempo - TempoUltimoInstante);

      if ( Estado == SISTEMA_LIVRE )
        Estado = SISTEMA_OCUPADO;
        Instante = Tempo;
        Partida  = Tempo + ( TamanhoPacote / CapacidadeDaLigacao );
      else
        if ( (TamanhoPacote + OcupacaoFila) > TamanhoDaFilaDeEspera  )
          PacotesPerdidos = PacotesPerdidos + 1;
        else
          FilaDeEspera = [ FilaDeEspera ; [ Tempo, TamanhoPacote ]  ];
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
    
    nSTATE = [ Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante ];
    nQUEUE = FilaDeEspera;