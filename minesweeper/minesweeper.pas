uses
  crt, menu_unit;
  
const
  map_height = 20;
  map_width = 25;
  number_of_mines = 40;
  
type
  cursor_rec = record
    x, y: integer;
  end;
  
var
  cur: cursor_rec;
  map: array[1..map_height, 1..map_width] of integer;
  mine_field: array[1..map_height, 1..map_width] of integer;
  key: char;
  is_game_on: boolean;
  marks: integer;
  
      // Процедуры и функции //
  procedure render_map; // Процедура отрисовывающая карту, согласно массиву
  var
    i, j: integer;
  begin
    for i := 1 to map_height do
    begin
      for j := 1 to map_width do
      begin
        gotoxy(j, i); // Переходим на координату элемента
        if not ((i = cur.y) and (j = cur.x)) then // Условие чтобы не стирался символ указателя
        begin
          if map[i, j] = 11 then begin textcolor(15); write('█'); end // Если в массиве этот элемент помечен, как граница, то рисуем границу (11 - граница игрового поля)
          else if map[i ,j] = 10 then begin textcolor(15); write('░'); end // 10 - закрытая клетка
          else if (map[i, j] >= 1) and (map[i, j] <= 8) then begin textcolor(15); write(map[i ,j]); end // 1-8 открытая клетка, с кол-вом мин вокруг нее
          else if map[i, j] = 0 then begin textcolor(15); write(' '); end // 0 - открытая клетка без мин вокруг
          else if map[i, j] = 12 then begin textcolor(3); write('P'); end; // 12 - клетка, помеченная игроком, как мина
        end;
      end;
    end;
  end;
  
  procedure fill_map; // Процедура заполняющая карту в начале игры
  var
    i, j: integer;
  begin
    for i := 1 to map_height do
    begin
      for j := 1 to map_width do
      begin
        if (i = 1) or (i = map_height) or (j = 1) or (j = map_width) then map[i, j] := 11 // Если элемент масиива находится на границе, то помечаем его, как границу
        else map[i, j] := 10; // Во всех иных случаях, помечаем как пустую клетку
        mine_field[i, j] := 0;
      end;
    end;
  end;

  procedure render_cursor(k: char); // Процедура отрисовки и передвижения указателя
  begin
    case k of // Двигаем курсор только если он не находится вплотную к границе игрового поля
      'w': begin if cur.y > 2 then Dec(cur.y); end;
      's': begin if cur.y < map_height-1 then Inc(cur.y); end;
      'a': begin if cur.x > 2 then Dec(cur.x); end;
      'd': begin if cur.x < map_width-1 then Inc(cur.x); end;
    end;
    
    textcolor(10);
    gotoxy(cur.x, cur.y); // Переходим по новым координатам
    writeln('▲'); // Рисуем курсор
  end;
  
  function mines_around(x, y: integer): integer; // Функция считающая, сколько мин находится вокруг указанной клетки
  var
    i, j, num: integer;
  begin 
    for i := -1 to 1 do
    begin
      for j := -1 to 1 do
      begin
        if mine_field[y + i, x + j] = 1 then Inc(num); // Если клетка вокруг указанной клетки помечена, как мина, то увеличиваем счетчик на 1
      end;
    end;
    Result := num; // Возвращаем кол-во мин
  end;

  procedure game_over(res: string); // Процедура завершающая игру, аргумент - исход: победа или поражение
  var
    i, j: integer;
  begin
    if res = 'lose' then // Если итог игры - поражение
    begin
      textcolor(12);
      gotoxy(map_width div 4, 1); // Переходим по координатам
      write('Game over!'); // Выводим сообщение о поражении
      for i := 1 to map_height do // Показываем все мины
      begin
        for j := 1 to map_width do
        begin
          gotoxy(j, i); // Переходим на координату, соотвутсвующую элементу массива мин
          if mine_field[i, j] = 1 then write('*'); // Если элемент помечен, как мина, то рисуем его
        end;
      end;
      delay(4500); // Задержка
      is_game_on := false; // Объявляем, что игра окончена (следовательно начинается новая)
    end
    else if res = 'win' then // Если итог - победа
    begin
      textcolor(14);
      gotoxy(map_width div 4, 1); // Переходим по координатам
      write('Win!'); // Выводим сообщение о победе
      for i := 1 to map_height do // Показываем все мины
      begin
        for j := 1 to map_width do
        begin
          gotoxy(j, i); // Переходим на координату, соотвутсвующую элементу массива мин
          if mine_field[i, j] = 1 then write('P'); // Если элемент помечен, как мина, то рисуем его
        end;
      end;
      delay(4500); // Задержка
      is_game_on := false; // Объявляем, что игра окончена (следовательно начинается новая) 
    end;
  end;

  procedure show_open_spaces(x, y: integer); // Рекурсивная процедура, для открытия больших пространств
  var
    i, j: integer;
  begin
    map[y, x] := 0; // Проверяемую клетку, как пустую
    for i := -1 to 1 do // Циклы применяющие след. условие ко всех клеткам вокруг проверяемой
    begin
      for j := -1 to 1 do
      begin
        if (((i = -1) or (i = 1)) and (j = 0)) or ((i = 0) and ((j = -1) or (j = 1))) then
        begin
          if (map[y+i, x+j] <> 11) and (mines_around(x+j, y+i) = 0) and (map[y+i, x+j] <> 0) and (mine_field[y+i, x+j] <> 1) and (mines_around(x, y) = 0) then // Если клетка не явл. границей, вокруг нее нет мин, и она не явл миной, а также не была открыта ранее, то...
          begin
            show_open_spaces(x+j, y+i); // Пременяем к клетки эту процедуру рекурсивно
          end
          else if (map[y+i, x+j] <> 11) and (mines_around(x+j, y+i) >= 1) and (mines_around(x+j, y+i) <= 8) and not ((map[y+i, x+j] >= 1) and (map[y+i, x+j] <= 8)) and (mine_field[y+i, x+j] <> 1) then // Все те же условия, только вокруг клетки находится мина
          begin
            map[y+i, x+j] := mines_around(x+j, y+i); // Отмечаем в массиве эту клетку кол-вом мин вокруг нее
          end;  
        end;
      end;
    end;
  end;

  procedure open_cell(x, y: integer); // Процедура, для открытия клеток
  begin
    if (mine_field[y, x] = 0) and (mines_around(x, y) = 0) then
    begin
      show_open_spaces(x, y); 
    end
    else if (mine_field[y, x] = 0) then
    begin
      map[y, x] := mines_around(x, y);
    end
    else if mine_field[y, x] = 1 then
    begin
      game_over('lose');
    end;
  end;

  procedure mark_a_mine(x, y: integer); // Процедура пометки мин
  var
    i, j, correct_marks: integer;
  begin
    if (map[y, x] <> 12) and not((map[y, x] >= 0) and (map[y, x] <= 8)) then begin map[y, x] := 12; Inc(marks); end // Если клетка еещ не помечена игроком, как мина и эта клетка не была открыта ранее, то помечаем ее, как мину
    else if map[y, x] = 12 then begin map[y, x] := 10; Dec(marks); end; // Если клетка помечена игроком, как мина, то при повторном использовании этой кнопки убираем пометку
    
    for i := 1 to map_height do
    begin
      for j := 1 to map_width do
      begin
        if (map[i, j] = 12) and (mine_field[i, j] = 1) then Inc(correct_marks); // Считаем сколько мин игрок отметил праивльно
      end;
    end;
    if (correct_marks = number_of_mines) and (correct_marks = marks) then // Если кол-во отмеченных правильно мин совпадает с кол-ом мин, задействованных в игре, и кол-ом всех отметок игрока, то...
    begin
      game_over('win'); // Объявляем, что игра закончена. Результат - победа
    end;
  end;

  procedure deploy_mines; // Процедура размещающая мины случайным образом по полю
  var
    i, x, y: integer;
    correct_gen: boolean;
  begin
   if ((map_height - 2) * (map_width - 2)) <= number_of_mines then // Если указанное кол-во мин больше чем кол-во клеток игрового поля, то..
   begin
     clrscr; // Очищаем экран
     gotoxy(1,1); // Перезодим по координатам
     write('ОШИБКА: Кол-во мин больше клеток игрового поля'); // Выводим сообщение об ошибке
     writeln(' ');
     halt; // Завершаем программу
   end;
   for i := 1 to number_of_mines do // Цикл, выполняющийся столько раз, сколько мин нужно разместить
   begin
    correct_gen := true; 
    while correct_gen do // Пока переменная равна true, выполнять (Будет равна true до тех пор пока мина не будет размещенная. Нужно для того чтобы избежать ситуации когда две мины, встанут друг на друга)
    begin
      x := random(map_width - 2) + 2; // Генерируем координату Х мины
      y := random(map_height - 2) + 2; // Генерируем координату Y мины
      if mine_field[y, x] <> 1 then // Если мины с такими координатами нет, то...
      begin
        mine_field[y, x] := 1; // Размещаем ее
        correct_gen := false; // Меняем переменную на false, то есть сообщаем, что мина успешно сгенерирована.
      end;
    end;
   end;
  end;

      // !Вход в программу! //  
begin
  menu_unit.show_menu;
  while true do // Начало бесконечного цикла (нужно чтобы после конца игры, она началась заново)
  begin
    textcolor(15);
    clrscr; // Очищаем экран
    fill_map; // Заполняем карту
    deploy_mines; // Размещаем мины
    cur.x := 8; cur.y := 8; // Начальные координаты указателя
   
    

    render_map; // Отрисовываем карту
    render_cursor('n'); // Отризовываем курсор, с неопределенным направлением
    is_game_on := true; // Запускаем игровой цикл
    
    while is_game_on = true do // Начало игрового цикла
    begin
    
     if KeyPressed then
     begin
      key := readkey; // Считываем нажатие
      render_cursor(key); // Перемещаем курсор
      render_map; // Отрисовываем карту
      
      if key = 'v' then // При нажатии на кнопку "V",  открываем клетку
      begin
       open_cell(cur.x, cur.y);   
      end;
      
      if key = 'c' then // При нажатии на кнопку "С", игрок помечает клетку как мину
      begin
       mark_a_mine(cur.x, cur.y);   
      end;
     end;
    end;
  end;  
end.