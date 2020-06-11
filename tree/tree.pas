  // Используемые модули
uses
  GraphABC;

  // Константы (стоит заглянуть)
const
    // Начальные значения некоторых параметров
  conts_DEPTH = 8; // Глубина отрисовки ветвей
  const_LENGTH = 80; // Начальная длина ветвей
  const_ANG = 45; // Угол отклонения ветви от угла "родительской" ветви
  const_ANG_DIFF = 15; // Значение на которое изменяется угол, после разделения
  const_LENGTH_DIFF = 0.8; // Множитель изменения длины ветвей после разделения
  const_TREE_COLOR = RGB(140, 255, 144); // Цвет дерева в виде rgb
  const_BACKGROUND_COLOR = RGB(0, 0, 0); // Цвет фона в виде rgb
  const_IS_INFO_MODE_ON = true; // Включить отображение параметров дерева на экране
  

  // Раздел переменных
var
  depth, length, ang, angle_difference: integer;
  length_difference: real;
  is_arrow_pressed: boolean;
 
  function rotate(cx, cy, x, y: integer; angle: real):point; // Функция поворачивающая точку, относительно другой точки на угол в градусах
  begin
    angle := angle * (pi / 180); // Переводим угол из градусов в радианы
    
    // Учитываем точку вращения
    x := x - cx;
    y := y - cy;
    
    // Выщитываем координаты повернутой точки, с учетом точки вращения
    Result.X := round(x * cos(angle) - y * sin(angle) + cx);
    Result.Y := round(x * sin(angle) + y * cos(angle) + cy);
  end;
  
  procedure tree(x, y, len, n: integer; angle:real); // Процедура отрисовки дерева
  var
    mp, rp, lp: point;
  begin
    Pen.Width := n; // Устанавиливаем толщину линии, зависящую от нынешнего уровня отрисовки ветвей 
    mp := rotate(x, y, x, y - len, angle); // Высчитываем "опорную" точку, которая нуходится между 2х ветвей
    rp := rotate(x, y, mp.X, mp.Y, ang); // Считаем конечную точку для правой ветви
    lp := rotate(x, y, mp.X, mp.Y, -ang); // Считаем конечную точку для левой ветви
    Line(x, y, rp.X, rp.Y); // Рисуем правую ветвь
    Line(x, y, lp.X, lp.Y); // Рисуем левую ветвь
    if n > 0 then tree(rp.X, rp.Y, round(len * length_difference), n - 1, angle + angle_difference); // Если счетчик больше нуля, то вызываем рекурсивно это процедуру для правой ветви
    if n > 0 then tree(lp.X, lp.Y, round(len * length_difference), n - 1, angle - angle_difference); // Если счетчик больше нуля, то вызываем рекурсивно это процедуру для левой ветви
  end;

  procedure KeyUp(key: integer); // Обработчик нажатий
  begin
    case key of // В зависимости от нажатой клавиши (так же объявляем, что была нажата стрелка)
      VK_Left: begin Dec(depth); is_arrow_pressed := true; end; // Стрелка влево - уменьшить глубину
      VK_Right: begin Inc(depth); is_arrow_pressed := true; end; //Стрелка вправо  - увеличить глубину
      VK_Up: begin Inc(length); is_arrow_pressed := true; end; // Стрелка вверх - увелечить длину ветей
      VK_Down: begin Dec(length); is_arrow_pressed := true; end; // Стрелка вниз - уменьшить длину ветвей
      VK_Numpad8: begin Inc(ang); is_arrow_pressed := true; end; // Num8 - увеличить угол наклона ветвей
      VK_Numpad2: begin Dec(ang); is_arrow_pressed := true; end; // Num2 - уменьшить угол наклона ветвей
      VK_Numpad6: begin Inc(angle_difference); is_arrow_pressed := true; end; // Num6 - увеличить величину, на которую изменяется угол наклона, после каждого разделения
      VK_Numpad4: begin Dec(angle_difference); is_arrow_pressed := true; end; // Num4 - уменьшить величину, на которую изменяется угол наклона, после каждого разделени
      VK_Subtract: begin length_difference := length_difference - 0.01; is_arrow_pressed := true; end; // Num- - Уменшение множителя изменения длины ветвей
      VK_Add: begin length_difference := length_difference + 0.01; is_arrow_pressed := true; end; // Num+ - Увеличение множителя изменения длины ветвей
      VK_S: window.Save('output_' + depth + '_' + length + '_' + length_difference + '_' + ang + '_' + angle_difference + '.png'); // Правый ctrl - скриншот
    end;
  end;

  procedure show_info;
  begin
    Brush.Color := const_BACKGROUND_COLOR; // Изменяем цвет фона текста на общий цвет фона
    Font.Color := const_TREE_COLOR; // Изменяем цвет шрифта на цвет дерева
      // Выводим информацию (Тут костыль - вывод слова и значения переменной отдельными процедурами, так как компилятор ругается на константы цветов, если написать одной процедурой. Очень странно)
    TextOut(0, 0, 'Depth: '); TextOut(45, 0, depth);
    TextOut(0, 20, 'Length: '); TextOut(45, 20, length);
    TextOut(0, 40, 'Length difference: '); TextOut(110, 40, length_difference);
    TextOut(0, 60, 'Angle: '); TextOut(45, 60, ang);
    TextOut(0, 80, 'Angle difference: '); TextOut(110, 80, angle_difference);
  end;

  // Вход в программу  
begin
  depth := conts_DEPTH; // Устанавливаем начальное значение глубины прорисовки дерева
  length := const_LENGTH; // Устанавливаем начальную длину ветки
  ang := const_ANG; // Устанавливаем угол отклонения от "контрольной точки"
  angle_difference := const_ANG_DIFF; // Устанавливаем число на которое изменяется угол после каждой ветви
  length_difference := const_LENGTH_DIFF; // Устанавливаем множитель изменения длины ветвей после разделения
  
  window.Maximize; // Разворачиваем окно на весь экран
  Pen.Color := const_TREE_COLOR; // Устанавиливаем цвет ручки на заданный 
  LockDrawing; // Задействуем виртуальный буфер, для отрисовки объектов
  
  while true do // Бесконечный цикл для регулировки параметров дерева
  begin
    clearwindow(const_BACKGROUND_COLOR); // Заливаем фон цветов фона  
    if const_IS_INFO_MODE_ON = true then show_info; // Отображаем информацию
    Pen.Width := depth; // устанавливаем ширину ствола
    Line(window.Width div 2, window.Height, window.Width div 2, window.Height - length*2); 
    tree(window.Width div 2, window.Height - length*2, length, depth, 0); // Вызываем функцию "дерева", с середины экрана
    Redraw; // Выводим рисунок из вируального буфера
    is_arrow_pressed := false; // Объявляем что стрелка не была нажата
    while is_arrow_pressed = false do OnKeyDown := KeyUp; // Посли отрисовки обрабатываем нажатия кнопок, ожидая нужных кнопок
  end;
end.