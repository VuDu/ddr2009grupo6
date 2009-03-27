
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

function [Pb1, Om1, Pb2, Om2] = tp1D( MIA, MST, CN, N )

% Variáveis de Estado
Estado = 0;                 % Número de canais ocupados
Tempo  = 0.0;
TempoUltimoEvento = 0.0;
TotalChamadas = 0;

Chegada = Tempo + exprnd( MIA );
Partida = [ 1.0e+29 ];

% Contadores estatísticos
Ocupacao1 = 0.0;            % Integral da ocupação das ligações até ao momento no intervalo 1
ChamadasBloqueadas1 = 0;    % Número de chamadas bloqueadas até ao momento no intervalo 1
Ocupacao2 = 0.0;            % Integral da ocupação das ligações até ao momento no intervalo 2
ChamadasBloqueadas2 = 0;    % Número de chamadas bloqueadas até ao momento no intervalo 2
TC1 = 0;                    % Número de chamadas no primeiro intervalo
T1 = 0;                     % Tempo decorrido no primeiro intervalo
TC2 = 0;                    % Número de chamadas no primeiro intervalo
T2 = 0;                     % Tempo decorrido no primeiro intervalo

while ( TotalChamadas < N-1 ),

  if ( Chegada < Partida(1) )
    TotalChamadas = TotalChamadas + 1;
    TempoUltimoEvento = Tempo;
    Tempo = Chegada;
    % Tratamento das medidas de desempenho apenas no intervalo considerado ]0,50] e ]500,550]
    if ( (TotalChamadas <= 50) || ( (TotalChamadas > 500) && (TotalChamadas <= 550) ) )
      if (TotalChamadas <= 50)
        Ocupacao1 = Ocupacao1 + Estado*(Tempo - TempoUltimoEvento);
        TC1 = TC1 + 1;
        T1 = T1 + (Tempo - TempoUltimoEvento);
      else
        Ocupacao2 = Ocupacao2 + Estado*(Tempo - TempoUltimoEvento);
        TC2 = TC2 + 1;
        T2 = T2 + (Tempo - TempoUltimoEvento);
      end;
      
    end;

    if ( Estado == CN )
      % Tratamento das medidas de desempenho apenas no intervalo considerado ]0,50] e ]500,550]
      if ( (TotalChamadas <= 50) || ( (TotalChamadas > 500) && (TotalChamadas <= 550) ) )
        if (TotalChamadas <= 50)
          ChamadasBloqueadas1 = ChamadasBloqueadas1 + 1;
        else
          ChamadasBloqueadas2 = ChamadasBloqueadas2 + 1;
        end;
      end;
    else
      Estado = Estado + 1;
      ProximaPartida = Tempo + exprnd( MST );
      pos = find( Partida > ProximaPartida, 1 );
      if pos
        Partida = [ Partida(1:pos-1), ProximaPartida, Partida(pos:length(Partida)) ];
      else
        Partida = [ Partida, ProximaPartida ];
      end;
    end;
    Chegada = Tempo + exprnd( MIA );
  else
    TempoUltimoEvento = Tempo;
    Tempo = Partida(1);
    Partida = Partida(2:length(Partida));
    
    if ( (TotalChamadas <= 50) || ( (TotalChamadas > 500) && (TotalChamadas <= 550) ) )
      if (TotalChamadas <= 50)
        Ocupacao1 = Ocupacao1 + Estado*(Tempo - TempoUltimoEvento);
        T1 = T1 + (Tempo - TempoUltimoEvento);
      else
        Ocupacao2 = Ocupacao2 + Estado*(Tempo - TempoUltimoEvento);
        T2 = T2 + (Tempo - TempoUltimoEvento);
      end;
    end;

    Estado = Estado - 1;
  end;

end;

% Calculo das medidas de desempenho
Pb1 = ChamadasBloqueadas1 / TC1; %TotalChamadas ;
Om1 = Ocupacao1 / T1;
Pb2 = ChamadasBloqueadas2 / TC2; %TotalChamadas ;
Om2 = Ocupacao2 / T2;
