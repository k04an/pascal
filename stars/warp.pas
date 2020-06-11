uses
  GraphABC, cabbtoolkit;

const
  NUM_OF_STARS = 500;

type
  TStar = class
    
    x, y, z, r, prev_x, prev_y: real;
    
    // Констурктор
    constructor create;
    begin
      // Генерируем случайные координаты в пределах окна
      x := random(window.Width) - window.Width div 2;
      y := random(window.Height) - window.Height div 2;
      
      // Приравниваем предыдущее положение к текущему (для того чтобы избежать появления полос на весь экран при запуске)
      prev_x := x;
      prev_y := y;
      
      z := window.Width div 2; // Задаем показатель z
      r := 0.5; // Задаем начальный показатль ширины точек и линий
    end;
    
    // Процедура отрисовки звезды
    procedure render;
    begin
      FillCircle(round(x), round(y), round(r)); // Отрисовываем звезду
     
      Pen.Width := round(r / 1.6); // Устанавливаем толщину пера на значение r
      Line(round(prev_x), round(prev_y), round(x), round(y)); // Рисуем линию от предыдущего положения точки, до текущего
    end;
    
    // Процедура передвижения звезды
    procedure move; 
    begin
      // После передвижения запоминаем прошлое положения звезды
      prev_x := x; 
      prev_y := y;
      
      // Передвигаем звезду
      x := map(x / z, 0, 1, 0, window.Width div 2);
      y := map(y / z, 0, 1, 0, window.Width div 2);
      
      z := z - 1; // Уменьшаем показатель z, для увеличения скорости движения
      r := r + 0.07; // Увеличиваем показатель толщены пера
      
      if (x < -(window.Width div 2)) or (x > window.Width div 2) or (y < -(window.Height div 2)) or (y > window.Height div 2) then // Если звезда выходит за границы окна, то...
      begin
        // Перемещаем ее во внутрь окна, сбрасывая все показатели на изначальные
        x := random(window.Width) - window.Width div 2;
        y := random(window.Height) - window.Height div 2;  
        prev_x := x;
        prev_y := y;
        z := window.Width div 2;
        r := 0.5;
      end;
    end;
    
  end;

var
  stars: array of TStar;
  log: text;
  
begin
  
  window.Maximize; // Разворачиваем программу на весь экран
  window.Title := 'Supa warp simulation'; // Изменяем заголовок окна
  
  SetLength(stars, NUM_OF_STARS); // Устанавливаем длину массива
  
  // Заполняем массив
  for var i := 0 to length(stars) - 1 do
  begin
    stars[i] := new TStar;
  end;
  
  LockDrawing; // Включаем виртуальный буфер отрисовки
  
  Brush.Color := clWhite; // Меняем цвет кисти на белый
  Pen.Color := clWhite; // Меняем цвет пера на белый
  
  SetCoordinateOrigin(window.Width div 2, window.Height div 2); // Изменяем начало координат, устанавливая его в центр окна
  
  // Начало бесконечного цикла
  while true do
  begin
    
    clearwindow(clBlack); // Заливаем окно черным
    
    // Для каждой звезды в массие
    for var i := 0 to length(stars) - 1 do
    begin
      stars[i].render; // Отрисовываем звезду
      stars[i].move; // Двигаем звезду
    end;
    
    Redraw; // Выводим изображение на экран
    
    sleep(20); // Задержка
   
  end;
  
end.