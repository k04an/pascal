  // Используменые модули
uses
  GraphABC;

  // !Конфигурационные константы!
const
  number_of_balls = 120; // Кол-во кочанов
  name_of_img = 'cabb.png'; // Название файла с изображением
  
  // Описание типов  
type
  TBall = class // Класс "мяч"
    public
      x, y, hv, vv: integer;
      pic: picture;
      
      constructor create(xx, yy, hvv, vvv: integer; pict: picture); // Процедура-конструктор
      begin
        x := xx;
        y := yy;
        hv := hvv;
        vv := vvv;
        pic := pict;
      end;
      
      procedure move; // Процедура на передвижение мяча
      begin
        x := x + hv; // Изменяем координаты используя показатель ускорения
        y := y + vv;
        
        if (x + pic.Width >= window.Width) or (x <= 0) then hv := hv * -1;
        if (y + pic.Height >= window.Height) or (y <= 0) then vv := vv * -1;
      end;
      
      procedure render; // Процедура отрисовки мяча
      begin
        pic.Draw(x, y);
      end;  
  end;

  // Описание переменных
var
  arr_balls: array of TBall;
  p: picture;

  // Начало программы 
begin
  p := picture.Create(name_of_img); // Загружаем картинку из файла
  window.Title := 'Flying cabbage';
  window.Maximize; // Открываем окно на весь экран

  LockDrawing; // Включаем использование виртуального буфера для отрисовки
  SetLength(arr_balls, number_of_balls); // Устанавливаем длину массива мячей
  
  for var i := 0 to arr_balls.Length - 1 do // Цикл заполняющий массив "мячами" со случайными характеристиками
  begin
    arr_balls[i] := new TBall(random(window.Width-p.Width), random(window.Height-p.Height), random(8) + 1, random(8) + 1, p); 
  end;
  
  while true do // Игровой цикл
  begin
    clearwindow; // Очищаем окно
    for var i := 0 to arr_balls.Length - 1 do // Для каждого "мяча" в массиве
    begin
      arr_balls[i].render; // Отрисовываем мяч
      arr_balls[i].move; //Двигаем мяч
    end;
    Redraw; // Выводим содержимое буфера на экран
  end;
end.