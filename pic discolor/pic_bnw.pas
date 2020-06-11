// Абсолютно не эффективный способ перерисовки картинки в серых тонах
// Написанно просто по приколу.

uses
  GraphABC;

var
  pic: picture;
  f: string;

  function grayout(c: color): color; // Функция переводящая цвет в черно-белый диапазон
  var
    gc: integer;
  begin
    gc := round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3); // Высчитвыаем серый цвет
    Result := RGB(gc, gc, gc); // Возвращаем серый цвет
  end;

begin
  Window.Title := 'Tupa gray out'; // Устанавливаем заголовок окна
  Window.IsFixedSize := true; // Фиксируем размер окна
  Window.Height := 30; // Устанавливаем начальный размер окна
  Window.Width := 450;
  TextOut(0, 0, 'Введите имя картинки с разрешением. Файл дожен находится в'); // Выводим информацию
  TextOut(0, 15, 'той же папке, что и программа.');
  readln(f); // Читаем путь к файлу
  clearwindow; // Очищаем окно
  TextOut(0, 0, 'Работаю...'); // Объявляем пользователю, что программа работает
  
  pic := Picture.Create(f); // Создаем объект картинки из файла

  for var iy := 0 to  pic.Height - 1  do
  begin
    for var ix := 0 to pic.Width - 1 do
    begin
      pic.PutPixel(ix, iy, grayout(pic.GetPixel(ix, iy))); // Заменяем пиксель на серый
    end;
  end;

  pic.Save('result_' + f); // Сохраняем результат
  Halt; //Останавливаем программу

end.