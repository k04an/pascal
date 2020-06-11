uses
  GraphABC;

var
  f: text;
  file_name, buffer: string;
  bot_x, bot_y, dly: integer;
  is_pen_active: boolean;
  colored_cells: array[1..100, 1..100] of boolean;

  procedure error(mes: string); // Процедура обработки ошибки
  begin
    window.Height := 15; // Устанавливаем размеры окна
    window.Width := 450;
    clearwindow; // Очищаем окно
    TextOut(0 , 0, mes); // Выводим текст ошибки
    Redraw; // Рисуем
    Sleep(3500); // Задержка
    halt; // Выход из программы
  end;

  procedure file_init; // Получение информации из файла
  begin   
    window.Height := 15; // Устанавливаем размеры окна
    window.Width := 300;
    textout(0, 0, 'Введите имя файла инструкций'); // Выводим сообщение для пользователя
    readln(file_name); // Читаем имя файла
    assign(f, file_name); // Открываем файловый поток
    
    try // Проверка на валидность файла
      reset(f); // Пытаемся прочитать файл 
    except // В случая неудачи...
      error('Ошибка открытия файла'); // Выводим ошибку
    end; 
  end;

  procedure read_file; // Процедура чтения данных из файла
  var
    is_height_definded, is_width_definded, is_x_definded, is_y_definded: boolean;
  begin
    while not eof(f) do // Пока не достигнут конец файла...
    begin
      readln(f, buffer); // Читаем файл построчно
      if pos('HEIGHT = ', buffer) <> 0 then begin delete(buffer, 1, 9); try window.Height := StrToInt(buffer)*34; except error('В файле инструкций введенны некорректные данные'); end; is_height_definded := true; end; // Если обнаружен параметр высоты, то устанавливаем высоту окна на указанное значение
      if pos('WIDTH = ', buffer) <> 0 then begin delete(buffer, 1, 8); try window.Width := StrToInt(buffer)*34; except error('В файле инструкций введенны некорректные данные'); end; is_width_definded := true; end; // Если обнаружен параметр ширины, то устанавливаем ширину окна на указанное значение
      if pos('X = ', buffer) <> 0 then begin delete(buffer, 1, 4); try bot_x := StrToInt(buffer); except error('В файле инструкций введенны некорректные данные'); end; is_x_definded := true; end; // Если обнаружен параметр координаты Х, то устанавливаем Х на указанное значение
      if pos('Y = ', buffer) <> 0 then begin delete(buffer, 1, 4); try bot_y := StrToInt(buffer); except error('В файле инструкций введенны некорректные данные'); end; is_y_definded := true; end; // Если обнаружен параметр координаты Y, то устанавливаем Y на указанное значение
      if pos('D = ', buffer) <> 0 then begin delete(buffer, 1, 4); try dly := StrToInt(buffer); except error('В файле инструкций введенны некорректные данные'); end; end;
    end;
    if (is_height_definded = false) or (is_width_definded = false) or (is_x_definded = false) or (is_y_definded = false) then error('Не обнаружены необходимые начальные параметры'); // Если не была обозначена высота или ширина окна, то выводим ошибку
  end;

  procedure render_field; // Процедура отрисовки поля
  var
    i, j: integer;
  begin
    clearwindow; // Очищаем окно
     while i <= window.Height*34 do // Цикл отрисовки поля
     begin
       j := 0;
       while j <= window.Width*34 do
       begin
        DrawRectangle(j, i, j + 34, i + 34);
        j := j + 34;
       end;
       i := i + 34;
     end;    
  end;
  
  procedure render_player; // Процедура отрисовки робота на поле
  begin
    if (bot_x < 1) or (bot_x > window.Width / 34) or (bot_y < 1) or (bot_y > window.Height / 34) then error('Робот за границами окна!'); // Проверка не находится ли робот за границами поля
    Brush.Color := clLime; // На момент отрисовки робота изменяем цвет кисти на зеленый
    clearwindow; // Очищаем окно. Нужно чтобы стереть предыдущее положжение робота. (Чтобы передвинуть кровать, сношу и перестраиваю весь дом :) )
    render_field; // Рисуем границы
    if is_pen_active then colored_cells[bot_y, bot_x] := true; // Если перо робота активно, то отмечаем в массиве эту клетку, как закрашенную
    for var i := 1 to 100 do
    begin
      for var j := 1 to 100 do
      begin
        if colored_cells[i ,j] = true then FloodFill(j + 1 + 34 * (j - 1), i + 1 + 34 * (i - 1), clBlue); // Если элемент массива, соответсвующий клетки закрашен, то закрашиваем клетку
      end;
    end; 
    FillCircle((17 + 34 * (bot_x - 1)), (17 + 34 * (bot_y - 1)), 5); // Рисуем "робота", в виде круга.
    Redraw; // Рисуем
    Brush.Color := clWhite; // После отрисовки, возвращаем цвет кисти на белый
  end;

  procedure pr_end; // "Конец" программы. Бесконечный цикл непозволяющий программе выполнятся далее, но не закрывающий ее.
  begin
    while true do
    begin
      
    end;
  end;

  procedure robot_crash(side: char); // Процедура отрисовывающая аварии робота
  begin
    Brush.Color := clRed; // Меняем цвет кисти на красный
    case side of // в зависимости от параметра, означаещего сторону столкновения, рисуем соответсвующий сектор (l - лево, r - право, u - верх, d - низ)
      'l': FillPie((17 + 34 * (bot_x - 1)), (17 + 34 * (bot_y - 1)), 5, 90, 270);
      'r': FillPie((17 + 34 * (bot_x - 1)), (17 + 34 * (bot_y - 1)), 5, 270, 450);
      'u': FillPie((17 + 34 * (bot_x - 1)), (17 + 34 * (bot_y - 1)), 5, 0, 180);
      'd': FillPie((17 + 34 * (bot_x - 1)), (17 + 34 * (bot_y - 1)), 5, 180, 360);
    end;
    window.Height := window.Height + 15;
    TextOut(0, window.Height - 15, 'Робот разбился');
    redraw; // Рисуем
    pr_end; // Эмулирум конец выполнения
  end;

  procedure start_exec;
  begin
    reset(f); // Начинаем чтение файла с начала
    
    while not eof(f) do // Цикл пропускающий все до ключевого слова "START"
    begin
      readln(f, buffer);
      if buffer = 'START' then break;
    end;
    
    while not eof(f) do // Цикл читающий файл построчно
    begin
      sleep(dly); // Выполняем задержку перед каждым ходом
      readln(f, buffer); // Записываем текущую строку файла в переменную buffer
      case buffer of // В зависимости от прочтенной команды, двигаем робота в нужную сторону. При столкновении, вызываем обработчик столкновений.
        'Left', 'left': if bot_x - 1 <> 0 then begin Dec(bot_x); end else begin robot_crash('l'); end;
        'Right', 'right': if bot_x + 1 <> (window.Width / 34) + 1 then begin Inc(bot_x); end else begin robot_crash('r'); end;
        'Up', 'up': if bot_y - 1 <> 0 then begin Dec(bot_y); end else begin robot_crash('u'); end;
        'Down', 'down', 'ordinec', 'horde': if bot_y + 1 <> (window.Height / 34) + 1 then begin Inc(bot_y); end else begin robot_crash('d'); end;
        'Pendown', 'PenDown', 'pendown': is_pen_active := true;
        'Penup', 'PenUp', 'penup': is_pen_active := false;
        'cleanup': colored_cells[bot_y, bot_x] := false;
      end;
      render_player; // Отрисовываем робота
    end;
    sleep(dly);
    window.Height := window.Height + 15;
    textout(0, window.Height - 15, 'Конец алгоритма');
    redraw;
  end;


        // Вход в программу //
begin
  window.IsFixedSize := true; // Запрещаем изменение размеров окна
  window.Title := 'Simple robot'; // Меняем заголовок окна
  
  dly := 500; // Устанавливаем начальное значение задержки, на случай, если пользователь решил оставить это значение по-умолчанию
  
  file_init; // Открываем файл инструкций
  read_file; // Читаем файл
  LockDrawing; // Включаем использование виртуального буфера отрисовки. Необходимо для устронения мерцаний при отрисовке.
  render_player; // Отрисовыаем изначальное положение игрока
  Redraw; // Рисуем
  start_exec; // Началь выполнение команд
end.