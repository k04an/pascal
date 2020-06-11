  // Стандартные цвета
  // (231, 212, 255) - фон
  // (151, 69, 255) - капля

  // Использумемые модули
uses
  GraphABC;
  
  // Полезные константы
const
  rain_drops = 650; //Общее кол-во капель
  wind_degree = -5; // Уровень наклона капли
  wind_speed = -1; // Скорость с которой каплю "сдувает ветер"

type

  TDrop = class // Описание класса "капля"
    public
      x1, x2, y1, len, wid, hv, vv: integer;
      
        // Конструктор
      constructor create(xx1, yy1, length, z: integer);
      begin
        x1 := xx1;
        y1 := yy1;
        len := length;
        wid := z;
        vv := z;;
        x2 := x1 + wind_degree;
      end;
      
        // Процедура отрисовки капли
      procedure render;
      begin
        Pen.Color := RGB(151, 69, 255); // Меняем цвет ручки
        Pen.Width := wid; // Меняем ширину ручки
        Line(x1, y1, x2, y1 + len); // Рисуим линию
      end;
      
        // Процедура передвижения капли
      procedure move;
      begin
        y1 := y1 + vv; // Изменяем координату Y используя показатель вертикальной скорости
        x1 := x1 + wind_speed; // 
        x2 := x1 + wind_degree;
        if y1 >= window.Height then y1 := -random(500);
        if (x1 <= 0) and (wind_speed < 0) then // Если капля оказывается за левой границей окна, то перемещаем ее за правую границу в случайное место
        begin
          x1 := random(200) + window.Width;
          x2 := x1 + wind_degree;
        end;
        if (x1 >= window.Width) and (wind_speed > 0) then // Если капля оказывается за правой границей окна, то перемещаем ее за левую границу в случайное место
        begin
          x1 := -random(200);
          x2 := x1 + wind_degree;
        end;
      end;
      
  end;

  procedure esc(key: integer); // Процедура-обработчик нажатий
  begin
    if key = VK_Escape then halt; // Если нажата клавиша ESC, то закрываем программу
  end;

var
  arr_rain: array of TDrop;
 
  // !Вход в программу! //
begin
  window.Maximize; // Разволрачиваем окно на весь экрна
  MainForm.FormBorderStyle := system.Windows.Forms.FormBorderStyle.None; // Убираем рамку окна
  LockDrawing; // Задействуем виртуальный буфер для отрисовки
  SetLength(arr_rain, rain_drops); // Задаем размер массиву с каплями
  for var i := 0 to arr_rain.Length - 1 do // Задаем параметры каплям в массиве
  begin
    arr_rain[i] := new TDrop(random(window.Width), -random(650), random(15) + 10, random(3) + 1);
  end;
  
     // "Игровой цикл" 
  while true do
  begin
    clearwindow(RGB(231, 212, 255)); // Заливаем окно цветом фона
    for var i := 0 to arr_rain.Length - 1 do // Отрисовываем каждую каплю из массива, а затем двигаем ее
    begin
      arr_rain[i].render;
      arr_rain[i].move;
    end;
    Redraw; // Выводим содержимое буфера на экран
    OnKeyUp := esc; // При нажатии на клавишу, вызываем обработчик
  end;
  
end.