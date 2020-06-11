uses
  GraphABC;
  
  
  function f(x: real):real; // Функция для построения графика
  begin
    Result := power(x, 3);
  end;
  
  function f_inv(x: real):real; // Функция для построения графика
  begin
    Result := -power(x, 3);
  end;
  
  procedure coor_sys; // Отрисовка осей системы координат
  begin
    Line(0, Window.Center.Y, Window.Width, Window.Center.Y);
    Line(Window.Center.X, 0, Window.Center.X, Window.Height);
  end;

begin
  Window.Init(0,0, 400, 400, clWhite); // Задаем настройки окна
  Window.CenterOnScreen; // Размещаем окно по центру
  Window.IsFixedSize := true;
  Brush.Style := bsClear; // Устанавливаем прозрачный фон у графиков

  coor_sys; // Рисуем систему координат
  
  Draw(f, -20, 20);
  Draw(f_inv, -20, 20);
  
end.