%   pt.ua.deti.ddr.tp3
% 
%   DDR - Trabalho pratico #3
%
%   Simulador de Rede com Comutação de Pacotes
%
%

function ret = simRCP( CENAS )


% Inicializar estado do nó !!!
  Estado = 0;
  PacotesAceites  = 0;
  PacotesPerdidos = 0;

  Atrasos      = 0;
  AtrasoMaximo = 0;

  OcupacaoFila = 0;   % Ocupação da fila em *bytes*
  IOcupacao    = 0;   % Integral da ocupação da fila de espera em *bytes*

  Instante = 0;   % Instante de tempo em que o pacote 
                  % entra no sistema para ser transmitido
                           
  InitState = [Estado, PacotesAceites, PacotesPerdidos, Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante ];
  
% Array com o estado de todos os nós
  NodeState = [ InitState; ...  # Nó 1
                InitState; ...  # Nó 2
                InitState; ...  # Nó 3
                InitState; ...  # Nó 4
                InitState; ...  # Nó 5
                InitState];     # Nó 6
                
  Tempo = 0;
  
  % Gerar os primeiros pacotes
  Pacotes = []; Caminhos = [];
  for i = 1:8,
    [Pacote, Caminho ] = getflow( Tempo, i );
    Pacotes = [ Pacotes; Pacote ];
    Caminhos= [ Caminhos; Caminho ];
  end;
  
  % Ordenar os pacotes de chegada...
  [s, i] = sort( Pacotes(:,1) );
  Pacotes = Pacotes(i,:);
  Caminhos= Caminhos(i,:);
  
  while(1),
    Tempo = Pacotes(1,1);
    flowNumber = Pacotes(1,3);
    NodeID= Caminhos(1,1);
    
    [Q, STATE, Pacote, Caminho ] = nodesim( NodeID, [],  ...
                                          NodeState(NodeID, :),  ...
                                          Pacotes(1,:),  ...
                                          Caminhos(1,:), ...
                                          Tempo, 100000);
                                          
    % Remover o pacotes que entrou no nó e ao mesmo tempo remover um possivel pacote
    % de entrada
    Pacotes = [ Pacotes(2:end,:); Pacote ];
    Caminhos= [ Caminhos(2:end,:);Caminho];
    
  end;
  
  
  