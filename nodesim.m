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
%     QROUTE: Fila de espera para caminhos do nó simulado.
%     STATE : Estado interno do nó.
%     PACKET: Pacote de entrada.
%     ROUTE:  Caminho do pacote
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
  
  GENERATE = 0;

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
                                  
        % -- Gerar um novo pacote caso o pacote que entrou tenha origem neste nó -- % 
        GENERATE = 0;
        if ( PACKET(3) < 0 )
          PACKET(3) = - PACKET(3);
          [NP, NR] = getflow( Tempo, PACKET(3) );
          GENERATE = 1;
        end

        if ( bitand(Estado, bitshift(1, abs(ROUTE(2)) ) ) == SISTEMA_LIVRE )
          Estado = bitor(Estado, bitshift(1, abs(ROUTE(2)) ) );
          Instante = Tempo;
          Partida  = Tempo + ( PACKET(2) / CapacidadeDaLigacao );
          OUTPACKET = [ Partida, PACKET(2), PACKET(3), PACKET(4) ];
          OUTROUTE  = ROUTE*-1; % passar para uma partida ... 
        else
          if ( (PACKET(2) + OcupacaoFila) > TamanhoDaFilaDeEspera  )
            PacotesPerdidos = PacotesPerdidos + 1;
          else
            if ( GENERATE == 1 )
              FilaDeEspera = [ FilaDeEspera ; [ Tempo, PACKET(2), PACKET(3), Tempo ]  ];
              FilaDeEsperaCaminho = [FilaDeEsperaCaminho; ROUTE*-1 ];
              OcupacaoFila = OcupacaoFila + PACKET(2);
            else
              FilaDeEspera = [ [ Tempo, PACKET(2), PACKET(3), Tempo ]; FilaDeEspera ];
              FilaDeEsperaCaminho = [ROUTE*-1; FilaDeEsperaCaminho ];
              OcupacaoFila = OcupacaoFila + PACKET(2);
            end
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
      DElAY = ( Tempo - PACKET(4) );
      Atrasos = Atrasos + AtrasoActual;

      if ( AtrasoMaximo < AtrasoActual )
        AtrasoMaximo = AtrasoActual;
      end;
      PacotesAceites = PacotesAceites + 1;
      OUTPACKET = [ Tempo, PACKET(2), PACKET(3), Tempo ];
      OUTROUTE  = [ ROUTE(2:end)*-1, 0 ];

      Partida = Inf;  % Retirar partida da Lista de Eventos
      if ( OcupacaoFila > 0 )
        
        f = FilaDeEsperaCaminho(:,2) == ROUTE(2);
        p = find( f );
        if ( p  )
          % Existem pacotes com direcção a ROUTE(2)
          tmpQ = FilaDeEspera(p, :);
          tmpQr= FilaDeEsperaCaminho(p, :);
          
          Instante = tmpQ(1,1);
          TamanhoPacote = tmpQ(1,2);
          FlowID = tmpQ(1,3);

          Partida  = Tempo + ( TamanhoPacote / CapacidadeDaLigacao );
          tmpQ = tmpQ(2:end,:);

          OcupacaoFila = OcupacaoFila - TamanhoPacote;

          NP = [Partida, TamanhoPacote, FlowID, Instante ];
          NR  = tmpQr(1, :);
          tmpQr = tmpQr(2:end, :);
          
          o = find( f == 0);
          tmpQ = [ FilaDeEspera(o, :); tmpQ ];
          tmpQr= [ FilaDeEsperaCaminho(o, :); tmpQr ];
          
          % Voltar a ordenar 
          [s, i] = sort( tmpQ(:,1) );
          FilaDeEspera = tmpQ(i,:);
          FilaDeEsperaCaminho= tmpQr(i,:);
        else
          Estado = bitxor(Estado, bitshift(1, abs(ROUTE(2)) ) );
        end
        
        % Instante = FilaDeEspera(1,1);
        % TamanhoPacote = FilaDeEspera(1,2);
        % FlowID = FilaDeEspera(1,3);
        % 
        % Partida  = Tempo + ( TamanhoPacote / CapacidadeDaLigacao );
        % FilaDeEspera = FilaDeEspera(2:end,:);
        % 
        % OcupacaoFila = OcupacaoFila - TamanhoPacote;
        % 
        % NP = [Partida, TamanhoPacote, FlowID, Instante ];
        % NR  = FilaDeEsperaCaminho(1, :);
        % FilaDeEsperaCaminho = FilaDeEsperaCaminho(2:end, :);
      else
        Estado = bitxor(Estado, bitshift(1, abs(ROUTE(2)) ) );
      end;

    end; % end ( Chegada < Partida )
    
    nSTATE = [Tempo, Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante];
    nQUEUE = FilaDeEspera;
    nQroute= FilaDeEsperaCaminho;
    