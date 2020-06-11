uses
  GraphABC;
  
type
  // Описание класса "точка"
  TMainPoint = class
    public
    vec, prev_vec, pA, pB, pC: point;
    irritations: integer;
    
    // Конструктор
    constructor create(ppA, ppB, ppC: point);
    begin
      pA := ppA;
      pB := ppB;
      pC := ppC;
      vec := (random(window.Width), random(window.Height));
      prev_vec := vec;
    end;
    
    // Процедура отрисовки точки
    procedure render;
    begin
      Brush.Color := clWhite;  // Изменяем цвет кисти на белый (прошлые положения точки)
      FillCircle(prev_vec.X, prev_vec.Y, 2); // Рисуем круг
      
      Brush.Color := clRed; // Изменяем цвет кисти на красный (текущее положение точки)
      FillCircle(vec.X, vec.Y, 2); // Рисуем круг
    end;
    
    // Процедура изменения положения точки
    procedure update; 
    var
      p: point;
    begin
      case random(3) of // Случайным образом выбираем одну из 3х точек
        0: p := pA;
        1: p := pB;
        2: p := pC;
      end;
      
      prev_vec := vec; // Запоминаем предыдущее положении точки
      
      // Изменяем координаты точки в соответсвии с правилами
      vec.X := vec.X - ((vec.X - p.X) div 2);
      vec.Y := vec.Y - ((vec.Y - p.Y) div 2);
      
      Inc(irritations); // Считаем ирритации
    end;
  end;
  
var
  MainPoint: TMainPoint := new TMainPoint((350, 10), (50, 400), (400, 400));
  delay: integer := 1000;
  
  procedure window_init; // Процедура настройки окна
  begin
    window.Width := 500; // Задаем ширину
    window.Height := 500; // Задаем высоту
    clearwindow(clBlack); // Заливаем фон черный
    Brush.Color := clWhite; // Изменяем цвет кисти на белый
    window.IsFixedSize := true; // Запрещаем изменение размеров окна
    window.Title := 'Serpinski triangle';
  end;

  procedure change_delay(key: integer); // Процедура-оброботчик, для изменения задержки
  begin
    case key of
      VK_Left: if delay > 0 then delay := delay - 100; // При нажатии на стрелку влево, уменьшаем задержку на 10 мс
      VK_Right: if delay < 2500 then delay := delay + 100; // При нажатии на стрелку вправо, увеличиваем задержку на 10 мс
    end;
  end;
  
  procedure show_info(pp: TMainPoint); // Процедура отображения информации
  begin
    Brush.Color := clBlack; // Изменяем цвет фона на черный
    Font.Color := clWhite; // Изменяем цвет шрифта на белый
    
    FillRectangle(0,0, 135, 31); // Очищаем предыдущие показания
    
    // Выводим информацию
    TextOut(0, 0, 'Delay: ' + delay);
    TextOut(0, 15, 'Irritations: ' + MainPoint.irritations);
  end;
 
begin
  LockDrawing; // Виртуальный буфер отрисовки
  show_info(MainPoint); // Отображаем информацию
  window_init; // Задаем параметры окну
  
  brush.Color := clLime; // Изменяем цвет кисти на зеленый, для отрисовки 3х основных точек
  FillCircle(350, 10, 2);
  FillCircle(50, 400, 2);
  FillCircle(400, 400, 2);
  Brush.Color := clWhite; // Изменяем цвет кисти на белый
  
  Redraw; // Выводим изображение на экран
  // Начало игрового цикла
  while true do
  begin
    MainPoint.render; // Отрисовываем точку
    MainPoint.update; // Изменяем положение точки
    
    sleep(delay); // Задержка
    
    OnKeyDown := change_delay; // считываем нажатие клавиш
    
    show_info(MainPoint); // Отображаем информацию
    Redraw; // Выводим изображение на экран
  end;
end.