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
function [ nQUEUE, nQroute ,nSTATE, OUTPACKET, OUTROUTE, NP, NR , DElAY ] = nodesim( NID, QUEUE, QROUTE, STATE, PACKET, ROUTE, TIME, TFE )


  % Constantes do sistema

  SISTEMA_LIVRE   = 0;
  SISTEMA_OCUPADO = 1;

  % Variaveis do sistema
  CapacidadeDaLigacao = ( 10 * 1000 * 1000 ) / 8;   % Capacidade da ligação em bytes por segundo 
  TamanhoDaFilaDeEspera = TFE;                      % Tamanho da fila de espera em bytes

  [Tempo, Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante ] = splitstate(STATE);

  FilaDeEspera = QUEUE;
  FilaDeEsperaCaminho = QROUTE;
  
  DElAY = 0;

    
  if ( ROUTE(1) <= 0 )
    % Temos uma chegada...
    Chegada = PACKET(1);
    Partida = Inf;
  else   
    % Temos uma partida...
    Chegada = Inf;
    Partida = PACKET(1);
  end

  NP = [];
  NR = [];
  
    if ( Chegada < Partida )
      % -- Temos uma chegada -- % 
      if ( ROUTE(2) != 0)
        TempoUltimoInstante = Tempo;
        Tempo = Chegada;

        IOcupacao = IOcupacao + OcupacaoFila * (Tempo - TempoUltimoInstante);
                                  
        % -- Gerar um novo pacote caso este tenha acabado de ser gerado -- % 
        if ( PACKET(3) < 0 )
          PACKET(3) = - PACKET(3);
          [NP, NR] = getflow( Tempo, PACKET(3) );
        end

        if ( Estado == SISTEMA_LIVRE )
          Estado = SISTEMA_OCUPADO;
          Instante = Tempo;
          Partida  = Tempo + ( PACKET(2) / CapacidadeDaLigacao );
          OUTPACKET = [ Partida, PACKET(2), PACKET(3)];
          OUTROUTE  = ROUTE*-1; % passar para uma partida ... 
        else
          if ( (PACKET(2) + OcupacaoFila) > TamanhoDaFilaDeEspera  )
            PacotesPerdidos = PacotesPerdidos + 1;
          else
            FilaDeEspera = [ FilaDeEspera ; [ Tempo, PACKET(2), PACKET(3) ]  ];
            FilaDeEsperaCaminho = [FilaDeEsperaCaminho; ROUTE*-1 ];
            OcupacaoFila = OcupacaoFila + PACKET(2);
          end;
          OUTPACKET = []; OUTROUTE = []; % Pacote fica guardado na fila de espera...
        end; % If ( Estado == SISTEMA_LIVRE)
      else
        % Chegou ao destino...
        OUTPACKET = [];
        OUTROUTE  = [];
      end % IF Route(1) == 0

    else % else ( Chegada < Partida )
      % -- Temos uma Partida -- %
      TempoUltimoInstante = Tempo;
      Tempo = Partida;
      IOcupacao = IOcupacao + OcupacaoFila * (Tempo - TempoUltimoInstante);

      % Actualizar Atrasos e Atraso Máximo
      AtrasoActual = ( Tempo - Instante );
      DElAY = AtrasoActual;
      Atrasos = Atrasos + AtrasoActual;

      if ( AtrasoMaximo < AtrasoActual )
        AtrasoMaximo = AtrasoActual;
      end;
      PacotesAceites = PacotesAceites + 1;
      OUTPACKET = PACKET;
      OUTROUTE  = [ ROUTE(2:end)*-1, 0 ];

      Partida = Inf;  % Retirar partida da Lista de Eventos
      if ( OcupacaoFila > 0 )
        Instante = FilaDeEspera(1,1);
        TamanhoPacote = FilaDeEspera(1,2);
        FlowID = FilaDeEspera(1,3);
        Partida  = Tempo + ( TamanhoPacote / CapacidadeDaLigacao );
        FilaDeEspera = FilaDeEspera(2:end,:);
        OcupacaoFila = OcupacaoFila - TamanhoPacote;
        
        NP = [Partida, TamanhoPacote, FlowID ];
        NR  = FilaDeEsperaCaminho(1, :);
        FilaDeEsperaCaminho = FilaDeEsperaCaminho(2:end, :);
      else
        Estado = SISTEMA_LIVRE;
      end;

    end; % end ( Chegada < Partida )
    
    nSTATE = [Tempo, Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante];
    nQUEUE = FilaDeEspera;
    nQroute= FilaDeEsperaCaminho;
    