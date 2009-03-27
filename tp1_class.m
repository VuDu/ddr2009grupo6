
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1
%
% aMIA - aMeanInterArrivel: Tempo médio de chegada entre chamadas da classe A
% bMIA - bMeanInterArrivel: Tempo médio de chegada entre chamadas da classe B
% MST  - MeanServiceTime: Tempo médio de duração das chamadas
% CN   - ChannelNumber: Número de canais disponiveis
% N    - TotalCallsNumber: Número de chamadas totais 
% R    - ClassBReservedChannels: Numero de canais reservados para chamadas da classe B

function [PbA, PbB, Om] = tp1_class( aMIA, bMIA, MST, CN, N, R )

% Constantes
CLASS_A = 0;
CLASS_B = 1;


% Variáveis de Estado
Estado = 0;                 % Número de canais ocupados
Tempo  = 0.0;
TempoUltimoEvento = 0.0;
TotalChamadas = 0;
TotalChamadasA = 0;
TotalChamadasB = 0;

% Gerar chegadas aleatorias das chamadas de ambas as classes
Chegada = [ [exprnd( aMIA ), CLASS_A ]; [ exprnd( bMIA ), CLASS_B] ];
% Ordenar as chegadas das chamadas por ordem crescente
[s, i] = sort( Chegada(:,1) );
Chegada = Chegada(i,:);

Partida = [ [ 1.0e+29, CLASS_A ] ];      % O ideal seria +infinito

% Contadores estatísticos
Ocupacao = 0.0;              % Integral da ocupação das ligações até ao momento
ChamadasBloqueadasA = 0;     % Número de chamadas bloqueadas até ao momento da class A
ChamadasBloqueadasB = 0;     % Número de chamadas bloqueadas até ao momento da class B

% Ciclo de simulação de chegada das chamadas
while ( TotalChamadas < N - 1 ),
  % Iniciou ou terminou uma chamada?
  if ( Chegada(1,1) < Partida(1,1) )
    % Iniciou uma chamada
    TotalChamadas = TotalChamadas + 1;
    TempoUltimoEvento = Tempo;
    Tempo = Chegada(1,1);
    Ocupacao = Ocupacao + Estado*(Tempo - TempoUltimoEvento);
    % Chegou ao fim da simulação?
    if ( TotalChamadas == N - 1 )
      break;
    end;
    % Iniciou uma chamada da classe A ou classe B?
    if ( Chegada(1,2) == CLASS_A )
      % Iniciou uma chamada da classe A
      TotalChamadasA = TotalChamadasA + 1;
      % Tem canais livres para estabelecar a chamada?
      if ( Estado >= (CN - R) )
        ChamadasBloqueadasA = ChamadasBloqueadasA + 1;
      else
        % Processa o inicio de uma nova chamada da classe A
        Estado = Estado + 1;
        % Calcula o fim da chamada que acabou de se iniciar
        ProximaPartida = Tempo + exprnd( MST );
        % Adiciona ordenadamente o fim da chamada
        Partida = [ Partida ; [ ProximaPartida, CLASS_A ] ];
        [s, i] = sort( Partida(:,1) );
        Partida = Partida(i,:);
      end;
      % Calcula a proxima chegada de chamada
      ProximaChegada = Tempo + exprnd( aMIA );
      % Remover a chamda actual e adicionar a proxima chamada ordenadamente
      Chegada = [ Chegada(2:length(Chegada),:) ; [ ProximaChegada, CLASS_A] ];
      [s, i] = sort( Chegada(:,1) );
      Chegada = Chegada(i,:);
    else
      % Iniciou uma chamada da classe B
      TotalChamadasB = TotalChamadasB + 1;
      % Tem canais livres para estabelecar a chamada?
      if ( (Estado + 1) >= CN  )
        ChamadasBloqueadasB = ChamadasBloqueadasB + 1;
      else
        % Processa o inicio de uma nova chamada da classe B
        Estado = Estado + 2;
        % Calcula o fim da chamada que acabou de se iniciar
        ProximaPartida = Tempo + exprnd( MST );
        % Adiciona ordenadamente o fim da chamada
        Partida = [ Partida ; [ ProximaPartida, CLASS_B ] ];
        [s, i] = sort( Partida(:,1) );
        Partida = Partida(i,:);
      end;
      % Calcula a proxima chegada de chamada
      ProximaChegada = Tempo + exprnd( bMIA );
      % Remover a chamda actual e adicionar a proxima chamada ordenadamente
      Chegada = [ Chegada(2:length(Chegada),:) ; [ ProximaChegada, CLASS_B] ];
      [s, i] = sort( Chegada(:,1) );
      Chegada = Chegada(i,:);

    end; % FIM DAS CLASSES
  else
    % Terminou uma chamada
    TempoUltimoEvento = Tempo;
    Tempo = Partida(1,1);
    Class = Partida(1,2);
    % Remove a chamada do vector
    Partida = Partida(2:length(Partida),:);
    Ocupacao = Ocupacao + Estado*(Tempo - TempoUltimoEvento);
    % Liberta o canal ocupado
    if ( Class == CLASS_A )
      Estado = Estado - 1;
    else
      Estado = Estado - 2;
    end;

  end;

end;

% Calculo das medidas de desempenho
PbA = ChamadasBloqueadasA / TotalChamadasA;
PbB = ChamadasBloqueadasB / TotalChamadasB;
Om = Ocupacao / Tempo;
