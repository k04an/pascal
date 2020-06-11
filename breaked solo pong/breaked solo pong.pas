uses
  crt;
const
  map_height = 20;
  map_width = 45;
  
  border_char = '?';
  goal_char = '#';
  platform_char = '$';
  ball_char = '@';
  
  border_color = 3;
  goal_color = 4;
  platform_color = 15;
  ball_color = 13;
  
  game_speed = 40;

type
  platform_rec = record
    x, y1, y2: integer;
  end;
  
  ball_rec = record
    x, y, ha, va: integer;
  end;
    
var
  map_array: array[1..map_height, 1..map_width] of integer;
  platform_size, goals, points, best_result: integer;
  platform: platform_rec;
  ball: ball_rec;

    procedure fill_map; // Процедура заполняющая массив-карту, границей, воротами
    var
      i, j: integer;
    begin
      for i := 1 to map_height do
      begin
        for j := 1 to map_width do
        begin
          if (i = 1) or (i = map_height) or (j = map_width) then map_array[i, j] := 9 // Если элемент массива находится не границе, то обозначаем его как границу
          else if (j = 1) then map_array[i, j] := 8 // Если элемент массива находится на левой грани, то обозначаем его, как ворота
          else map_array[i, j] := 0; // Во всех остальных случаях помечаем элементы, как пустое место
        end;
      end;
    end;
    
    procedure render_map; // Процедура отрисовывающая содержимое массив-карты на экран
    var
      i, j: integer;
    begin
      for i := 1 to map_height do
      begin
        for j := 1 to map_width do
        begin
          gotoxy(j, i);
          case map_array[i, j] of
            9: begin textcolor(border_color); write(border_char); end; // Если элемент помечен как граница, отрисовываем на проекции массива символ границы (9 - граница)
            8: begin textcolor(goal_color); write(goal_char); end; // Если элемент помечен как ворота, отрисовываем на проекции массива символ ворот (8 - ворота)
            1: begin textcolor(platform_color); write(platform_char); end; // Если элемент помечен как платформа, отрисовываем на проекции массива символ платформы (1 - платформа)
            2: begin textcolor(ball_color); write(ball_char); end; // Если элемент помечен как мяч, отрисовываем на проекции массива символ мяча (2 - мяч)      
            else write(' '); // Во всех остальных случаях затираем ячейку на проекции матрицы  
          end;
        end;
      end;
    end;
  
   
    procedure render_platform; // Процедура записывающая платформу в массив-карту
    var
       i: integer;
    begin
     platform.y2 := platform.y1 + platform_size; // Определеям координату Y, нижнего конца платформы, используя координату верхнего конца  и длину платформы
     for i := platform.y1 to platform.y2 do // Цикл прогоняющий ячейки между двумя концами платформы
     begin
       map_array[i, platform.x] := 1; // Помечаем ячейки, как платформу
      end;
   end; 

  procedure move_platform(key: char); // Процедура двигающая платворму, в записимости от нажатой кнопки
  begin
    case key of // В зависимости от нажатой кнопки...
      'w': begin if platform.y1 > 2 then begin map_array[platform.y2, platform.x] := 0; Dec(platform.y1); end; end; // Если платформа находится не у граниы, то двигаем ее вверх
      's': begin if platform.y2 < (map_height - 1) then begin map_array[platform.y1, platform.x] := 0; Inc(platform.y1); end; end; // Если платформа находится не у граниы, то двигаем ее вниз
    end;
  end;

  procedure render_ball; // Процедура записывающая положения мяча в массив-карту
  begin
    map_array[ball.y, ball.x] := 2; // Помечаем ячейку с координатами мяча, как мяч
  end;

  procedure move_ball; // Процедруа передвигающая мяч и меняющая ускоряния
  begin
    map_array[ball.y, ball.x] := 0; // Помечаем ячейку на которой чейчас находится мяч, как пустую
    
    if (map_array[ball.y + ball.va, ball.x + ball.ha] = 1) and (map_array[ball.y - ball.va, ball.x + ball.ha] = 9) then // Возможно поможет в ситуации если, мяч застрянет между стеной и платформой (но не точно)
    begin
    ball.ha := ball.ha * (-1);
    end;
    
    if (map_array[ball.y + ball.va, ball.x + ball.ha] = 9) and (map_array[ball.y - ball.va, ball.x + ball.ha] = 1) then // Возможно поможет в ситуации если, мяч застрянет между стеной и платформой, только снизу (но не точно)
    begin
    ball.va := ball.va * (-1);
    end;
    
    ball.x := ball.x + ball.ha; // Сдвигаем мяч по горизонатали, используя горизональное ускорение
    ball.y := ball.y + ball.va; // Сдвигаем мяч по вертикали, используя вертикальное ускорение
    
    if map_array[ball.y, ball.x + ball.ha] = 1 then // Если мяч соприкоснулся с платформой по горизонтальной оси, то...
    begin
      ball.ha := ball.ha * -1; // Инфвертируем горизонтальное ускорение
    end;
    if map_array[ball.y + ball.va, ball.x + ball.ha] = 1 then // Если мяч ударяется о верхний угол платформы, то...
    begin
      ball.va := ball.va * (-1); // Инвертируем вертикальное ускорение
    end
    else if map_array[ball.y - ball.va, ball.x + ball.ha] = 1 then // Если мяч ударяется о нижний угол платформы, то...
    begin
      ball.va := ball.va * -1; // Инвертируем вертикальное ускорение
    end;
    
    if ball.y >= map_height - 1 then ball.va := ball.va * (-1); // Если мяч находится в плотную к верхней или нижней границе, то инвертируем вертикальное ускорение
    if ball.y <= 2 then ball.va := ball.va * (-1); 
    if ball.x >= map_width - 1 then ball.ha := ball.ha * (-1); // Если мяч находится вплотную к правой границе, то инвертируем горизонтальное ускорение 
  end;

  function is_goal(x, y, a: integer): boolean; // Функция, проверяющая будет ли забит гол, при последующем передвежении объекта
  begin
    if map_array[y, x + a] = 8 then Result := true; // Если объект коснется ворот, то возвращаем true
  end;
 
  procedure showinfo; // Информация под игровым полем
  begin
    gotoxy(2, map_height + 1);
    write('                   '); // Очистка
    gotoxy(2, map_height + 2);
    write('                   ');
    gotoxy(2, map_height + 3);
    write('                   ');
    
    gotoxy(2, map_height + 1); // Вывод
    write('Missed goals: ', goals);
    gotoxy(2, map_height + 2);
    write('Score: ', points);
    gotoxy(2, map_height + 3);
    write('Best score: ', best_result);
  end;
 
  procedure start_point; // Начальная точка игры. Нужно для рестарта
  begin
  platform.x := 5; // Начальные координаты платформы и ее размер
  platform.y1 := 9;
  platform_size := 3;
  
  ball.x := (map_width div 2) + (random((map_width div 2))); // Начальные координаты мяча
  ball.y := random(map_height - 3) + 2;
  ball.ha := -1; // Начальное ускорение мяча
  ball.va := 1;
  
  fill_map; // Заполняем карту
  render_platform; // Создаем платформу
  render_ball; // Создаем мяч
  render_map; // Отрисовывем содержимое массива-карты
  end;

        // !Вход в программу! //
begin
  start_point;

    // !Начало бесконечного игрового цикла! //
  while true do 
  begin
  Inc(points);
  showinfo; // Показываем информацию
  render_ball; // Отрисовывем мяч на матрице
  move_ball; // Передвигаем мяч, используя горизонтальное и вертикальное ускорение
  render_ball; // Отрисовывем мяч на матрице
  
  if is_goal(ball.x, ball.y, ball.ha) then // Если гол, то...
  begin
    gotoxy(map_width div 2, map_height div 2); // Ставим курсор на центр игрового поля
    textcolor(15); // Меняем цвет текста
    write('Goal!'); // Выводим сообщение о том, что произошел гол
    Inc(goals); // Увеличиваем кол-во пропущенных голов
    if points > best_result then best_result := points; // Если игрок побил предыдущий рекорд, то обновляем рекорд
    Points := 0; // Обнуляем счетчик очков
    delay(4500); // Задержка
    start_point; // Начинаем игру заново
  end;
  
  if KeyPressed then // Если была нажата кнопка, то...
  begin
    move_platform(readkey); // Двигаем платформу
    render_platform; // Обновляем положение платформы на матрице
  end;
  
  render_map;
  delay(game_speed);
  end;
 
end.