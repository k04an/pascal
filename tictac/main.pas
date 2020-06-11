uses
  GraphABC;
  
var
  field: array [1..3, 1..3] of integer;
  comp_plan: array[1..3, 1..3] of integer;
  used_plans: array[0..7] of boolean;
  is_players_turn, is_round_runing, turn_change, is_plan_generated, is_draw: boolean;
  curr_side, wins, loses, op_side: integer;

  procedure win_init; // Процедруа настройки окна
  begin
    Window.Width := 400; // Ширина окна
    Window.Height := 500; // Высота окна
    Window.IsFixedSize := true; // Делаем окна фиксированного размера
    Window.CenterOnScreen; // Центруем окно на экране
    Font.Color := clRed;
    Font.Size := 24;
    Font.Style := fsBold;
  end;

  procedure render_borders; // Процедура отрисовки границ игрового поля
  begin
    Pen.Width := 5; // Устанавливаем толщину пера
    DrawRectangle(0, 0, 400, 400); // Рисуем квадрат, который будет границей поля
    Line(0, 133, Window.Width, 133); //Рисуем линии для создания сетки
    Line(0, 266, Window.Width, 266);
    Line(133, 0, 133, 400);
    Line(266, 0, 266, 400);
  end;

  procedure pO(x, y: integer); // Процедура отрисовки нолика
  begin
    DrawCircle(x, y, 50);
  end;
  
  procedure pX(x, y: integer); // Процедура отрисовки крестика
  begin
    Line(x - 32, y - 32, x + 32, y + 32);
    Line(x - 32, y + 32, x + 32, y - 32);
  end;

  procedure render_state; // Процедура отрисовывающая на поле крестики и нолики
  var
    x, y: integer;
  begin
    for var i := 1 to 3 do
    begin
      for var j := 1 to 3 do
      begin
        if field[i, j] <> 0 then // Если в массиве клетка числится как непустая, то...
        begin
         case i of // Определяем координату y, для клетки
          1: y := 65;
          2: y := 200;
          3: y := 331;
         end;
         
         case j of // Определяем координату x, для клетки
          1: x := 65;
          2: x := 200;
          3: x := 331;
         end;
        
          case field[i, j] of // В зависимости от указанного в массиве символа рисуем соответсвующий рисунок
            2: pO(x, y);
            1: pX(x, y);
          end; 
        end;
      end;
    end;
  end;

  procedure wipe_field; // Процедура очистки поля
  begin
    for var i := 1 to 3 do
    begin
      for var j := 1 to 3 do
      begin
        field[i, j] := 0;
      end;
    end;
  end;

  function is_win: integer; // Функция проверяющая не произошла ли победа
  begin
    for var i := 1 to 3 do
    begin
      if (field[i, 1] = field[i, 2]) and (field[i, 1] = field[i, 3]) and (field[i, 1] <> 0) then Result := field[i, 1];
    end;
    for var i := 1 to 3 do
    begin
      if (field[1, i] = field[2, i]) and (field[1, i] = field[3, i]) and (field[1, i] <> 0) then Result := field[1, i];
    end;
    if (field[1, 1] = field[2, 2]) and (field[1, 1] = field[3, 3]) and (field[1, 1] <> 0) then Result := field[1, 1];
    if (field[1, 3] = field[2, 2]) and (field[2, 2] = field[3, 1]) and (field[2, 2] <> 0) then Result := field[2, 2];
  end;

  procedure win; // Процедрура победы
  begin
    if is_players_turn = true then
    begin
      Inc(wins); // Если в момент победы был ход игрока, то защитываем победу
      TextOut(200, 0, 'WIN!');
    end
    else
    begin
      Inc(loses); // Иначе поражение
      TextOut(200, 0, 'LOSE!');
    end;
    is_players_turn := false; // Объявляем, что сейчас не ход игрока
    Sleep(3500); // Задержка
    if turn_change = true then turn_change := false // Меняем местами первого ходящего
    else turn_change := true;
    is_round_runing := false; // Объявляем, что раунд закончен
  end;

  procedure place_sym(x, y, sym: integer); // Процедура отмечающая на клетке фигуру
  begin
    if field[y, x] = 0 then field[y, x] := sym;
    render_state;
    if is_win <> 0 then win;
  end;

  procedure MouseUp(x, y, mb: integer); // Обработчик нажатий мыши
  var
    pos_x, pos_y: integer;
  begin
    if is_players_turn = true then // Если сейчас ход игрока...
    begin
      pos_x := 0; // Обнуляем позиции клетки
      pos_y := 0;
      if (x >= 0) and (x <= 133) then pos_x := 1; // Условия определяющие, где было произведенно нажатие, и по указывающие клетку нажатия
      if (x >= 134) and (x <= 267) then pos_x := 2;
      if (x >= 267) and (x <= 400) then pos_x := 3;
      if (y >= 0) and (y <= 133) then pos_y := 1;
      if (y >= 134) and (y <= 267) then pos_y := 2;
      if (y >= 267) and (y <= 400) then pos_y := 3;
      if (pos_x <> 0) and (pos_y <> 0) then
      begin  
        place_sym(pos_x, pos_y, curr_side); // Размещаем фиугру на клетке, где было нажатие. Если нажатие было внутри границ игрового поля.
        is_players_turn := false;
      end;
    end;
  end;

  procedure clear_plan; // Программа очищающая план компьютера
  begin
    for var i := 1 to 3 do
    begin
      for var j := 1 to 3 do
      begin
        comp_plan[i, j] := 0;
      end;
    end;
  end;

  procedure gen_plan; // Процедура генерируящая для компьютера план игры
  var
    plan: integer;
  begin
    is_draw := true;
    for var i := 0 to 7 do
    begin
      if used_plans[i] = false then is_draw := false;
    end;
    
    while (is_plan_generated = false) and (is_draw = false) do
    begin
      plan := random(8);
      case plan of
        0: begin if used_plans[plan] = false then begin comp_plan[1, 1] := 1; comp_plan[1, 2] := 1; comp_plan[1, 3] := 1; used_plans[plan] := true; is_plan_generated := true; end; end; 
        1: begin if used_plans[plan] = false then begin comp_plan[2, 1] := 1; comp_plan[2, 2] := 1; comp_plan[2, 3] := 1; used_plans[plan] := true; is_plan_generated := true; end; end; 
        2: begin if used_plans[plan] = false then begin comp_plan[3, 1] := 1; comp_plan[3, 2] := 1; comp_plan[3, 3] := 1; used_plans[plan] := true; is_plan_generated := true; end; end;
        3: begin if used_plans[plan] = false then begin comp_plan[1, 1] := 1; comp_plan[2, 1] := 1; comp_plan[3, 1] := 1; used_plans[plan] := true; is_plan_generated := true; end; end;
        4: begin if used_plans[plan] = false then begin comp_plan[1, 2] := 1; comp_plan[2, 2] := 1; comp_plan[3, 2] := 1; used_plans[plan] := true; is_plan_generated := true; end; end;
        5: begin if used_plans[plan] = false then begin comp_plan[1, 3] := 1; comp_plan[2, 3] := 1; comp_plan[3, 3] := 1; used_plans[plan] := true; is_plan_generated := true; end; end;
        6: begin if used_plans[plan] = false then begin comp_plan[1, 1] := 1; comp_plan[2, 2] := 1; comp_plan[3, 3] := 1; used_plans[plan] := true; is_plan_generated := true; end; end;
        7: begin if used_plans[plan] = false then begin comp_plan[1, 3] := 1; comp_plan[2, 2] := 1; comp_plan[3, 1] := 1; used_plans[plan] := true; is_plan_generated := true; end; end;
      end;  
    end; 
  end;

  function is_plan_executable: boolean; // Функция проверяющая может ли компьютер следовать своему плану
  begin
    Result := true;
    for var i := 1 to 3 do
    begin
      for var j := 1 to 3 do
      begin
        if comp_plan[i, j] = 1 then
        begin
          if field[i, j] = curr_side then Result := false;
        end;
      end;
    end;
  end;

  procedure comp; // Компьютерный игрок
  var
    is_turn_done: boolean;
  begin
    
    if is_players_turn = false then // Если сейчас ход компьютера...
    begin
      if is_draw = false then // Если не будет ничьей..
      begin
        if is_plan_executable = false then // Если нынешний план не исполним...
        begin
          clear_plan; // Очищаем план действий
          is_plan_generated := false; // Объявляем что план не был сгенерирован
        end;
        if is_plan_generated = false then gen_plan; // Если план не был сгенерирован, то генерируем
      end;
      
      is_turn_done := false;
      if is_plan_generated then
      begin
        for var i := 1 to 3 do
        begin
          for var j := 1 to 3 do
          begin
            if (comp_plan[i, j] = 1) and (is_turn_done = false) then begin place_sym(j, i, op_side); comp_plan[i, j] := 0; is_turn_done := true; end; 
          end;
        end;
      end;
      is_players_turn := true;
    end;
  end;


      // !Вход в программу! //  
begin
  win_init; // Задаем настройки окну
  curr_side := 2; // Игрок начинает за крестики (1 - крестики, 2 - нолики)
  op_side := 1;  //начальная сторона противника
  turn_change := true;
  
  while true do // !Начало игрового цикла! //
  begin
    Swap(curr_side, op_side); // Меняем стороны метстами
    clearwindow; // Очищаем окно
    render_borders; // Отрисовываем границы
    if turn_change = true then is_players_turn := true else is_players_turn := false; // Объявляем, чей сейчас ход. Ходы черкдуются.
    wipe_field; // Очищаем поле
    is_round_runing := true; // Объявляем, что раунд начат
    
    while is_round_runing do // !Начало раунда! //
    begin
      
      comp; // Предлагаем компьютеру сделать ход
      OnMouseUp := MouseUp; // При нажатии на кнопку мыши, вызываем обработчик
      render_state; // Отрисовываем фигуры  
      
    end;
  end;
end.