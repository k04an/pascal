uses
  GraphABC;

type
  TPrism = class // Класс призма
    public
      a, b, c, d, central_point: point;
      length: integer;
      angle: real;
      color: color;
    
    constructor Create(aa, bb, cc, dd: point; len: integer; ang: real; col: system.Drawing.Color); // Конструктор
    begin
      a := aa;
      b := bb;
      c := cc;
      d := dd;
      length := len;
      angle := ang * (pi / 180);
      central_point := (c.X - round(sqrt(sqr(c.X - a.X)) / 2), c.Y - round(sqrt(sqr(c.Y - a.Y)) / 2)); // Расчет центра верхнего основания
      color := col;
    end;
    
    procedure render;
    begin
    Pen.Color := color;
    // Рисуем верхнее основание
    Line(a.X , a.Y, b.X, b.Y);
    Line(b.X, b.Y, c.X, c.Y);
    Line(c.X, c.Y, d.X, d.Y);
    Line(d.X, d.Y, a.X, a.Y);
    
    // Увеличиваем координату Y всех точек на высоту и рисуем ребра
    MoveTo(a.X, a.Y);
    a.Y := a.Y + length;
    LineTo(a.X, a.Y);
    
    MoveTo(b.X, b.Y);
    b.Y := b.Y + length;
    LineTo(b.X, b.Y);
    
    MoveTo(c.X, c.Y);
    c.Y := c.Y + length;
    LineTo(c.X, c.Y);
    
    MoveTo(d.X, d.Y);
    d.Y := d.Y + length;
    LineTo(d.X, d.Y);
    
    // Рисуем нижнее основание
    Line(a.X , a.Y, b.X, b.Y);
    Line(b.X, b.Y, c.X, c.Y);
    Line(c.X, c.Y, d.X, d.Y);
    Line(d.X, d.Y, a.X, a.Y);
    
    // Возвращаем координаты точек на изначальные
    a.Y := a.Y - length;
    b.Y := b.Y - length;
    c.Y := c.Y - length;
    d.Y := d.Y - length;
    end;
    
    function rotate(cp, p: point): point; // Функция считающая координаты вращаемой точки
    begin
      p.X := p.X - cp.X;
      p.Y := p.Y - cp.Y;
      Result := (round(p.X * cos(angle) - p.Y * sin(angle)) + cp.X, round(p.X * sin(angle) + p.Y * cos(angle)) + cp.Y);
    end;
    
    procedure rotate_base; // Процедура вращающая верхнее основание
    begin
      a := rotate(central_point, a);
      b := rotate(central_point, b);
      c := rotate(central_point, c);
      d := rotate(central_point, d);
    end;
    
  end;

var
  arr_prism: array of TPrism;
  
  
begin
  SetLength(arr_prism, 2);
  LockDrawing; // Включаем иртуальный буфер
  arr_prism[0] := new TPrism((200, 100), (400, 100), (350, 200), (150, 200), 200, 1, clRandom); // Создаем призму
  arr_prism[1] := new TPrism((200, 100), (400, 100), (350, 200), (150, 200), 200, -1, clRandom); // Создаем призму

  
  // Задаем параметры окна
  window.Width := 600;
  window.Height := 500;
  while true do
  begin
  clearwindow(clBlack); // Очищаем окно
    for var i := 0 to length(arr_prism) - 1 do
    begin
      Brush.Color := clWhite; //Меняем цвет кисти на белый
      Pen.Color := clWhite; // Меняем цвет ручки на белый

      // Рисуем ось вращения
      Line(arr_prism[i].central_point.X, arr_prism[i].central_point.Y, arr_prism[i].central_point.X, 0);
      Line(arr_prism[i].central_point.X, arr_prism[i].central_point.Y, arr_prism[i].central_point.X, window.Height); 
      
      // Рисуем небольшие окружность в точках вращения
      FillCircle(arr_prism[i].central_point.X, arr_prism[i].central_point.Y, 3);
      FillCircle(arr_prism[i].central_point.X, arr_prism[i].central_point.Y + arr_prism[i].length, 3);
      
      arr_prism[i].render; // Отрисовывам призму
      arr_prism[i].rotate_base; // Вращаем ее верхнее основание на указанный угол
    end;
  Sleep(5);
  Redraw; // Выводим изображение на экран
  end;

end.