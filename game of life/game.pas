uses
  crt;
const
  height = 20;
  width = 60;
  main_symbol = '█';
  border_symbol = '*';
  speed = 135;
  pointer_symbol = '@';
var
        // Переменные//
  map: array[1..height, 1..width] of integer;
  buffer_map: array[1..height, 1..width] of integer;
  key_log: string;
  is_placing_mode_on: boolean;
  px, py: integer;
  key: char;


        // Процедуры и функции //
  procedure showinfo;
  begin
    gotoxy(2, Height + 1);
    write('To place cells you can use procedure "place_cells"');
    gotoxy(2, Height + 2);
    write('or press "G"');
    gotoxy(72, Height + 2);
    textcolor(DarkGray);
    write('(С)k04an');
    textcolor(White);
  end;
 
  procedure render_map; // Процедура для отризовки карты. Переноса массива на экран.
  var
    i, j: integer;
  begin
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        gotoxy(j, i);
        if map[i, j] = 1 then write(main_symbol) // Если элемент массива равен 1, рисуем символ. (Клетка жива)
        else if (i = 1) or (i = height) or (j = 1) or (j = width) then
        begin
          map[i, j] := 9;
          write(border_symbol);
        end
        else write(' '); // Иначе пробел. (Мертва)
      end;
    end;
  end;

  function cells_around(x, y: integer): integer; // Функция считающая кол-во живых клеток, вокруг указанной
  var
    num: integer;
  begin
    if (map[y - 1, x - 1] = 1) and (y > 2) and (x < (Width - 1)) and (x > 2) then Inc(num);
    if (map[y - 1, x] = 1) and (y > 2) and (x <> (Width - 1)) and (x > 2) then Inc(num);
    if (map[y - 1, x + 1] = 1) and (y > 2) and (x <> (Width - 1)) and (x > 2)  then Inc(num);
    if (map[y, x - 1] = 1) and (x <> 1) and (x <> Width - 1) then Inc(num);
    if (map[y, x + 1] = 1) and (x <> 1) and (x <> Width - 1) then Inc(num);
    if (map[y + 1, x - 1] = 1) and (y < Height - 1) and (x < (Width - 1)) and (x > 2) then Inc(num);
    if (map[y + 1, x] = 1) and (y < Height - 1) and (x < (Width - 1)) and (x > 2) then Inc(num);
    if (map[y + 1, x + 1] = 1) and (y < Height - 1) and (x < (Width - 1)) and (x > 2) then Inc(num);
    Result := num;
  end;
  
  procedure life; // Основная процедура двигающая игру
  var
    i, j, num: integer;
  begin  
    for i := 1 to height do 
    begin
      for j := 1 to width do
      begin
        if map[i, j] = 0 then // Если элемент первичной матрицы равен 0, то...
        begin
          num := cells_around(j, i); // Смотрим скорлько "живых" клеток, вокруг данный клетки
          if num = 3 then buffer_map[i, j] := 1; // Если вокгрук ровно 3 живые клетки, то помечаем данную клетку, как живую не вторичной матрице
        end;
      end;
    end;

    
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        if map[i, j] = 1 then // Если элемент перичной матрици равен 1, то...
        begin
          num := cells_around(j, i); // Смотрим сколько живых клеток вокруг данной
          if (num < 2) or (num > 3) then buffer_map[i, j] := 0; // Если клеток меньше 2 или больше 3, то помечаем данную клетку, как мертвую на вторичный матрице
          if (num = 2) or (num = 3) then buffer_map[i, j] := 1; // Есои клеток 2 или 3, то помечаем данную клетку, как живую на вторичной матрице
        end;
      end;
    end;
    
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        map[i, j] := buffer_map[i, j]; // Копируем содержимое вторичной матрици в первичную
      end;
    end;
  end;

  procedure cc(x, y: integer); // Процедура создания клетки. Желатильно прописывать только в процедуре place_cells
  begin
    map[y, x] := 1;
  end;

  procedure place_cells; // Процедура размещающаяя клетки с помощью процедуры cc(create cell)
  begin

  end;

  procedure clear_map; // Процедура для очистки массива-карты
  var
    i, j: integer;
  begin
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        map[i, j] := 0;
        buffer_map[i, j] := 0;
      end;
    end;
  end;

  procedure render_pointer(k: char); // Процедура отрисовки и передвижения указателя
  begin
    if map[py, px] = 0 then // Если клетка на которой расположен указатель - пустая, то... (нужно чтобы при передвижении указателя, созданная клетка появлялась сразу, а не затиралась)
    begin  
      gotoxy(px, py); // Перезодм по координатам указателя
      writeln(' '); // Стираем клетку
    end;
    case k of // Передвигаем указатель, в зависимости от нажатой кнопки
      'w': Dec(py);
      's': Inc(py);
      'a': Dec(px);
      'd': Inc(px);
    end;  
    
    if px = 1 then Inc(px);
    if px = Width then Dec(px);
    if py = 1 then Inc(py);
    if py = Height then Dec(py);
    
    gotoxy(px, py); // Переходим по новым координатам
    write(pointer_symbol); // Отрисовываем указатель 
  end;

  procedure show_placing_info; // Показ информации по режиму размещения
  begin
    gotoxy(2, Height + 1);
    write('You are in a cell placing mode.');
    gotoxy(2, Height + 2);
    write('To place a cell move pointer by pressing WASD');
    gotoxy(2, Height + 3);
    write('and then, press F, pointing where you want to place a cell.');
    gotoxy(2, Height + 4);
    write('Press V to delete the cell');
    gotoxy(2, Height + 5);
    write('To exit this mode, press G.');
  end;

  procedure dc(x, y: integer); // Процедура удалния клеток
  begin
    map[y, x] := 0;  
  end;  

        // !Вход в программу! //
begin
  clear_map;
  showinfo;
  place_cells;
  
  while true do
  begin
    
    if KeyPressed then // При нажатии на клавишу
    begin
      if readkey = 'g' then is_placing_mode_on := true; 
    end;
    
      // !Начало режима добавления клеток! //
    while is_placing_mode_on = true do 
    begin
    
      clrscr; // Очищаем экран
      clear_map; // Очиаем карту
      render_map; // Отрисовываем чистую карту
      px := 5; py :=5 ; // Начальные координаты указателя
      render_pointer('n'); // Первая отрисовка указателя
      show_placing_info; // Показываем информацию по режиму размещения
      
      while true do // Цикл для перемещения курсора
      begin
      if KeyPressed then // При нажатии какой-либо клавиши
      begin
        key := readkey;
        if key = 'f' then cc(px, py); // При нажатии на F, создаем клетку
        if key = 'v' then dc(px, py);
        if key = 'g' then // При нажатии на G...
        begin
          is_placing_mode_on := false; // Отключаем триггер "Режима добавления"
          key_log := ''; // Очищаем лог нажатий
          clrscr; // Очищаем экран
          showinfo; // Снова показываем основную информацию
          break; // Выходим из цикла перемещения курсора
        end;
        render_map; // Перерисовываем карту
        render_pointer(key); // Передвигаем и отрисовываем указатель
      end;
      
      delay(120);
      end;
    end;

    render_map; // Отрисовываем карту
    
    life; // Применяем правила игры
    
    delay(speed); // Задержка между ходами
  end;

end.