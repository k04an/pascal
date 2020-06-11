uses
  crt;
const
  walls_num = 10;
  height = 20;
  width = 50;
  player_char = '@';
var
  i, j, n, m, px, py, ox, oy, points, speed, level, tail: integer;
  key, direction: char;
  walls: array[1..width, 1..Height] of integer;
  snake_tail: array[1..height, 1.. width] of integer;
  is_object_spawned: boolean;
  
  function collision(x, y: integer): boolean; // функция для проверки, столкнулся ли объект с границей
  begin
    
    if (y >= height) or (x >= width) or (x <= 1) or (y <= 1) then Result := true; // Если игрок находится за границами карты, то возвращаем true
    
    if walls[x,y] = 1 then Result := true; // Если в элемент матрицы с координатами игрока равен 1, то возвращаем тру. Матрица - карта стен  
    
    if (snake_tail[y, x] <> 0) and (direction <> 'n') then Result := true;
    
  end;
  
  procedure ShowStat; // Процедура, для вывода надписей на экран
  begin
        // Стираем предыдущие адписи (не бейте) 
    gotoxy(1, height + 1);
    writeln('            ');
    gotoxy(1, height + 2);
    writeln('            ');
    gotoxy(1, height + 3);
    writeln('               ');
    
        // Выводим надписи на экран
    gotoxy(1, height + 1);
    writeln('x = ', px);
    gotoxy(1, height + 2);
    writeln('y = ', py);
    gotoxy(1, height + 3);
    writeln('Points: ', points);
    gotoxy(1, height + 4);
    writeln('Each 10 point - speed up! WASD for control');
    textcolor(DarkGray);
    gotoxy(72, 24);
    writeln('(C)k04an');
    textcolor(White);
  end;
  
  procedure change_direction(k: char); // Процедура, для смены направления движения игрока
  begin
   case k of
     'w': direction := 'u';
     's': direction := 'd';
     'a': direction := 'l';
     'd': direction := 'r';
   end;
  end;
  
  procedure create_wall(mx1, my1, mx2, my2: integer);
  var
    a, b, P, x1, x2, x3, x4, y1, y2, y3, y4: integer;
  begin
    x1 := mx1; y1 := my1;
    x2 := mx1; y2 := my2;
    x3 := mx2; y3 := my2;
    x4 := mx2; y4 := my1;
    
    for a := x1 to x4 do // Отрезок между т1 и т4 (т - точка прямоугольника)
    begin
      walls[a, y1] := 1;
    end;
    for a := y1 to y2 do // Отрезок между т1 и т2
    begin
      walls[x1, a] := 1;
    end;
    for a := x2 to x3 do // Отрезок между т2 и т3
    begin
      walls[a, y2] := 1;
    end;
    for a := y4 to y3 do // Отрезок между т3 и т4
    begin
      walls[x4, a] := 1;
    end;
  end;
  
  procedure render_walls; // Процедура отрисовывающая стены
  begin
    create_wall(36,2, 36,15);
    create_wall(15,9, 15,19);
    create_wall(16,12, 22,12);
    create_wall(29,12, 35,12);
  end;

  procedure spawn_object; // Процедура спавна объекта
  var
    x, y: integer;
  begin
    while true do
    begin
      x := random(Width - 1) + 1; // Генерируем координату Х, в пределах границ карты
      y := random(Height - 1) + 1; // Генерируем координату Y, в пределах границ карты
      if collision(x, y) = false then // Если сгенерированные координаты, не конфликтуют со стенами, то...
      begin
        ox := x; // Присваеваем координату X, объекту
        oy := y; // Присваеваем координату Y, объекту
        break;
      end;
    end;
    textcolor(Red); // Меняем цвет текста
    gotoxy(ox, oy); // Переходим по координатам, туда где должен быть отрисован объект
    write('o'); // Отричовавыем объект
    textcolor(White); // Меняем цвет текста обратно на стандартный
  end;

  procedure tl; // Процедура "подбирания" хвоста
  var
    i, j: integer;
  begin
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        if snake_tail[i, j] > tail then // Если ячейка хвоста находится от головы дальше, чем это разрешенно хвостом, то...
        begin
          snake_tail[i, j] := 0; // Обнуляем ячейку в матрице, мониторющую положене хвоста
          gotoxy(j, i); // Переходим по координатам хвоста
          write(' '); // Стираем хвост
        end;
      end;
    end;
  end;

  procedure player_movement; // Процедура передвигающая игрока
  var
    i, j: integer;
  begin
    snake_tail[py, px] := 1; // Записываем положение головы в матрицу, чтобы хвост "проследовал" пол этим координатам
    
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        if snake_tail[i, j] <> 0 then Inc(snake_tail[i ,j]); // Если ячейка в матрице отлична от 0, то увеличиваем ее на 1. Это нужно для отслеживания расстояния от "головы", то каждой ячейки хвоста   
      end;
    end;
    
    tl;
    
    case direction of // Перемещаем игрока, в зависимовти от направления
      'u': Dec(py);
      'd': Inc(py);
      'l': Dec(px);
      'r': Inc(px);
    end;
  end;

begin // Вхождение в программу
  tail := 2;
  speed := 125; // Задаем начальную скорость игры
  level := 1; // Задаем начальный уровень игры. Используется, для того, чтобы понимать, нужноли пывысить скорость
  direction := 'n'; // Начальное движение игрока - неопределено. Игрок не двигается
  px := 5; // Начальные координаты игрока
  py := 5;
  textcolor(White); // Задаем цвет текста
  
        // Отрисовка карты //
  render_walls; // Задать координаты стен
  for n := 1 to width do // Отрисовка стен
  begin
    for m := 1 to Height do
    begin
      if walls[n, m] = 1 then
      begin
        gotoxy(n, m);
        writeln('=');
      end;
    end;
  end;
  
  for i := 1 to height do // Отрисовка границ
  begin
    for j := 1 to width do
    begin
      gotoxy(j, i); // Переход по координатам
      if (i = 1) or (i = height) or (j = 1) or (j = width) then writeln('='); // Если точка с данными координатыми является границей, то рисуем символ
    end;
  end; 
    
  while true do // !Бесконечный цикл! //
  begin
    
      // Подбор объекта //
    if (px = ox) and (py = oy) then // Если координаты игрока и объекта совпадают, то...
    begin
      is_object_spawned := false; // Объявляем, что объект не заспавнен
      Inc(points); // Увеличиваем число очков на 1
      Inc(tail); // Удлиняем хвост
    end;
    
      // Создание объекта //
    if is_object_spawned = false then // Если объект не заспавлен, то..
    begin
      spawn_object; // Заспавнить обект
      is_object_spawned := true; // Объявить, что объект заспавнен
    end;
    
      // Отрисовка игрока //
    gotoxy(px, py); // Перезод по координатам игрока
    textcolor(Cyan);
    writeln(player_char); // Отрисовка игрока
    textcolor(White);
 
    ShowStat; // Показать координаты игрока
 
    if KeyPressed then 
    begin
      key := readkey; // Ждем нажатия кнопки
      change_direction(key); // Изменить движение игрока
    end;
    
    player_movement; // Двигаем игрока, в заданном положении
    
    if collision(px, py) = true then // Если игрок столкнулся с препятсивем, то выводим экран оконсания игры и завершаем прокамму
    begin
      clrscr; // Очищаем экран
      gotoxy(15, 5); // Делаем отступ
      textcolor(Red); // Меняем цвет текста
      writeln('Game over!'); // Выводим сообщение об окончании игры
      gotoxy(15, 6); // Делаем отсту
      writeln('Total points: ', points); // Выводим кол-во очков
      gotoxy(5, 10); // Отступ
      writeln(' ');
      exit; // Завершение программы
    end;
    
    if (points div 10 >= level) and (speed <> 25) then
    begin
      speed := speed - 25;
      Inc(level);
    end;
    
    delay(speed);
  end;  
end.