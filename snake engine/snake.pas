uses
  crt;
const
  height = 20;
  width = 40;
var
  key, dir: char;
  x, y, tail, i, j: integer;
  arr: array[1..height, 1..width] of integer;
  
  procedure change_dir(k: char); // Проедура для смены направляния движения
  begin
    case k of // В зависимости от нажатой кнопки, емняем направление
      'w': dir := 'u';
      's': dir := 'd';
      'a': dir := 'l';
      'd': dir := 'r';
    end;  
  end;

  procedure tl; // Процедура "Хвост". Используя матрицу, на которой сохранены координыты всех ячеек хвоста, подтирает лишние ячейки, в зависимости от значения переменной tail
  var
    i, j: integer;
  begin
  
  for i := 1 to height do
  begin
    for j := 1 to width do
    begin
      if arr[i,j] > tail then // Если ячейка хвоста, находится дальше от "головы", чем разрешено переменой tail, то...
      begin
        arr[i,j] := 0; // Обнуляем ячейку
        gotoxy(j, i); // Переходим по соответсвующим координатам ячейки
        writeln(' ' ); // Стираем ячейку на экране
      end;
    end;
  end;
  
  end;
  
  procedure render_char; // Процедура отрисовки змейки 
  var
    i, j: integer;
  begin
    textcolor(Red); // Цвет змейки
    
    arr[y, x] := 1; // Записываем в матрицу координаты, на которых расположен хвост
    
    case dir of // Двигем "голову", в зависимости от напрпвления
      'u': Dec(y);
      'd': Inc(y);
      'l': Dec(x);
      'r': Inc(x);
    end;
    
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        if arr[i, j] <> 0 then Inc(arr[i, j]); // Увеличиваем значения в матрице, отличные от 0. Делается для того, чтобы знать на сколько ячейка хвоста отдалена от "головы".
      end;
    end;
    
    tl;
    
    gotoxy(x, y); // Переходим по передвинутыим координатам.
    write('@'); // Рисуем "голову"
    textcolor(White); // Возвращаем цвет на стандартный)
  end;

  function collision(x, y: integer): boolean; // Функция коллизии
  begin
    if (x = 1) or (x = width) or (y = 1) or (y = height) then Result := true; // Если координаты "головы" совпадают с границей, то true
    
    if (arr[y, x] <> 0) and (dir <> 'n') then Result := true; // Если координаты головы совпадают с координатой ячейки матрицы, отличной от 0, то есть "голова" пересекай хвост и при этом направления не равно N (чтобы игра не заканчивалась с самого начала, когда голова стоит на месте.), то true.
  end;

  procedure showart;
  begin
    gotoxy(width + 2, 3);
    write('            ____');
    gotoxy(width + 2, 4);
    write('           / . .\');
    gotoxy(width + 2, 5);
    write('           \  ---<');
    gotoxy(width + 2, 6);
    write('             \  /');
    gotoxy(width + 2, 7);
    write('   __________/ /');
    gotoxy(width + 2, 8);
    write('-=:___________/');
  end;
  
begin // Вход в программу
  dir := 'n'; // Начальное направление движения N, то есть неопределено.
  textcolor(White); // Цвет всего, кроме змеи
  
    // Отрисовка стен
  for i := 1 to height do
  begin
    for j := 1 to width do
    begin
      gotoxy(j, i);
      if (i = 1) or (i = height) or (j = 1) or (j = width) then write('*') // Если координаты совпадают с координатами границы, то рисуем
      else write(' '); // Иначе пробел
    end;
  end;

  tail := 10; // Размер хвоста
  x := 5; y := 5; // Начальные координаты головы
  
  showart;
  
  while true do // !Бесконечный цикл! //
  begin
  
    if keypressed then // Если нажата какая-либо клавиша, то...
    begin
      key := readkey; // Читаем нажатую клавишу в переменную key
      change_dir(key); // Передаем клавишу в процедуру смены направления
    end;
    
    render_char; // Отрисовка "головы"
  
  if collision(x, y) then // Проверка на столкновение. Если столкновение произошло, то
  begin
    clrscr; // Очищаем экран
    gotoxy(10, 10); // Отступ
    write('Game over'); // Сообщаем об окончании игры
    gotoxy(20,20); // Отступ
    write(' '); 
    exit; // Завершаем программу
  end;
  
  delay(125);
  end;
  
end.