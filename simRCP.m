%   pt.ua.deti.ddr.tp3
% 
%   DDR - Trabalho pratico #3
%
%   Simulador de Rede com Comutação de Pacotes
%
%

function ret = simRCP( CriterioParagem )


% Inicializar estado do nó !!!    
  Tempo  = 0;
  Estado = 0;
  PacotesAceites  = 0;
  PacotesPerdidos = 0;

  Atrasos      = 0;
  AtrasoMaximo = 0;

  OcupacaoFila = 0;   % Ocupação da fila em *bytes*
  IOcupacao    = 0;   % Integral da ocupação da fila de espera em *bytes*

  Instante = 0;   % Instante de tempo em que o pacote 
                  % entra no sistema para ser transmitido
                           
  InitState = [Tempo, Estado, PacotesAceites, PacotesPerdidos,  ...
               Atrasos, AtrasoMaximo, OcupacaoFila, IOcupacao, Instante ];

% Array com o estado de todos os nós
  NodeState = [ InitState; ...  # Nó 1
                InitState; ...  # Nó 2
                InitState; ...  # Nó 3
                InitState; ...  # Nó 4
                InitState];     # Nó 5
                
  DelaySum(1:8) = 0;
  PacoteAceite(1:8) = 0; 
  Delay(1:8) = 0;
% Array com o atraso de cada Pacote
% Filas de espera e Fila das rotas
  Q1 = []; Qr1 = [];
  Q2 = []; Qr2 = [];
  Q3 = []; Qr3 = [];
  Q4 = []; Qr4 = [];
  Q5 = []; Qr5 = [];
%----------------

  Tempo = 0;
  
  % Gerar os primeiros pacotes
  Pacotes = []; Caminhos = [];
  for i = 1:8,
    [Pacote, Caminho ] = getflow( Tempo, i );
    Pacotes = [ Pacotes; Pacote ];
    Caminhos= [ Caminhos; Caminho ];
  end;
  
 while(  sum( PacoteAceite ) < CriterioParagem ),
    
    % Ordenar os pacotes tempo de chegada ...
    [s, i] = sort( Pacotes(:,1) );
    Pacotes = Pacotes(i,:);
    Caminhos= Caminhos(i,:);
    
    Tempo = Pacotes(1,1);
    flowNumber = abs( Pacotes(1,3) );
    NodeID= abs( Caminhos(1,1) );
    
    % Hardcoded Queue selection :\
    % Não vejo outra maneira de o fazer, o Matlab
    % não suporta passagem de variáveis por referencia
    switch NodeID
      case 1
        enterQ = Q1;
        enterQr = Qr1;
      case 2
        enterQ = Q2;
        enterQr = Qr2;
      case 3
        enterQ = Q3;
        enterQr = Qr3;
      case 4
        enterQ = Q4;
        enterQr = Qr4;
      case 5
        enterQ = Q5;
        enterQr = Qr5;
    end
    
    [Q, Qr, STATE, Pacote, Caminho, NP, NR, Atraso ] = nodesim( NodeID, enterQ, enterQr, NodeState(NodeID, :),Pacotes(1,:), Caminhos(1,:), Tempo, 10000);
    DelaySum( flowNumber ) = DelaySum( flowNumber ) + Atraso;
    if ( Caminhos(1,2) == 0 )
      % O pacote chegou ao destino
      Delay( flowNumber ) = Delay(flowNumber) + DelaySum( flowNumber );
      DelaySum(flowNumber) = 0;
      PacoteAceite(flowNumber) = PacoteAceite(flowNumber) + 1;
    end; 
    
    % Guardar Fila de espera                                      
    switch NodeID
      case 1
        Q1 = Q; Qr1 = Qr;
      case 2
        Q2 = Q; Qr2 = Qr;
      case 3
        Q3 = Q; Qr3 = Qr;
      case 4
        Q4 = Q; Qr4 = Qr;
      case 5
        Q5 = Q; Qr5 = Qr;
    end 
    
    % Guardar estado
    NodeState(NodeID, : ) = STATE; 
                                
    % Remover o pacotes que entrou no nó e ao mesmo tempo remover um possivel pacote
    % de entrada
    Pacotes = [ Pacotes(2:end,:);  Pacote;  NP];
    Caminhos= [ Caminhos(2:end,:); Caminho; NR];
  end;  
  (Delay ./ PacoteAceite) * 1000
 % (NodeState(:,5) ./ NodeState(:,3)) * 1000
  
  
  