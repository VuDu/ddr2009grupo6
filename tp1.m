
% 
% UA - 2009
% DDR
%
% Trabalho Prático #1
%
% MIA - MeanInterArrivel: Tempo médio de chegada entre chamadas
% MST - MeanServiceTime: Tempo médio de duração das chamadas
% CN  - ChannelNumber: Número de canais disponiveis
% N   - TotalCallsNumber: Número de chamadas totais 

function [Pb, Om] = tp1( MIA, MST, CN, N )

% Variáveis de Estado
Estado = 0;                 % Número de canais ocupados
Tempo  = 0.0;
TempoUltimoEvento = 0.0;
TotalChamadas = 1;

Chegada = Tempo + exprnd( MIA );
Partida = [ 1.0e+29 ];      % O ideal seria +infinito

% Contadores estatísticos
Ocupacao = 0.0;             % Integral da ocupação das ligações até ao momento
ChamadasBloqueadas = 0;     % Número de chamadas bloqueadas até ao momento

% Ciclo de simulacao de chegada das chamadas
while ( TotalChamadas < N ),
  % Verificacao se esta a chegar uma chamada ou a terminar uma chamada
  if ( Chegada < Partida(1) )
    % Chegou uma chamada
    TotalChamadas = TotalChamadas + 1;
    TempoUltimoEvento = Tempo;
    Tempo = Chegada;
    Ocupacao = Ocupacao + Estado*(Tempo - TempoUltimoEvento);
    % Chegou à ultima chamada?
    if ( TotalChamadas == N )
      break;
    end;
    % Existem canais livres?
    if ( Estado == CN )
      ChamadasBloqueadas = ChamadasBloqueadas + 1;
    else
      % Existem canais livres. Marcar a ocupacao do canal e calcular a terminacao da chamada
      Estado = Estado + 1;
      ProximaPartida = Tempo + exprnd( MST );
      % Inserir o momento do fim da chamada num vector ordenado por ordem crescente
      pos = find( Partida > ProximaPartida, 1 );
      if pos
        Partida = [ Partida(1:pos-1), ProximaPartida, Partida(pos:length(Partida)) ];
      else
        Partida = [ Partida, ProximaPartida ];
      end;
    end;
    % Calculo da proxima do inicio da proxima chamada
    Chegada = Tempo + exprnd( MIA );
  else
    % Terminou uma chamada.
    TempoUltimoEvento = Tempo;
    Tempo = Partida(1);
    % Remover o momento do fim da chamada do vector
    Partida = Partida(2:length(Partida));
    Ocupacao = Ocupacao + Estado*(Tempo - TempoUltimoEvento);
    % Actualizar ocupação dos canais
    Estado = Estado - 1;
  end;

end;

% Calculo das medidas de desempenho
Pb = ChamadasBloqueadas / (TotalChamadas - 1) ;
Om = Ocupacao / Tempo;
