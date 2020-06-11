uses 
  Crt;
var
  ch: char;
  tm: real;
  key_log: string;
  is_on: boolean;
  pos: integer;
  
    // Пауза и вывод времени //
  procedure time; 
  begin
    tm := tm + 0.1;
    writeln(tm);
    delay(100);
  end;
  
  function last_chars(num: integer; src: string): string; // Возврашает последние num символов строки
  var
    i: integer;
  begin
    
    if length(src) - num > 0 then
    begin
      for i := (length(src) - num + 1) to length(src) do
      begin
        Result := Result + src[i]; 
      end;
    end;    
  end;
  
  procedure BillyGin; // Процедура "Билли джин"
  const
    line = 'Билли джин насрал в кувшин. Ай-Ай';
    amount = 3;
  var
    i, j: integer;
  begin
   for j := 1 to amount do
   begin
    clrscr; // Очищаем экран
    gotoxy(5, 3); // Делаем отступ
    textcolor(random(15) + 1); // Задаем цвет для первого слова
    for i := 1 to length(line) do // Выводин строку line по буквам
    begin
      
      if line[i] = ' ' then textcolor(random(15) + 1); // Если выводим пробел, то есть начинаем писать новое слово, то снова генерируем цвет текста
      write(line[i]); // Выводим первую букву строки line
      delay(100); // Задержка перед написанием букв 
    end;
    delay(2000); // Задержка после вывода всей строки
   end;
   key_log := key_log + 'b'; // Добавляем в лог нажатий букву, чтобы избежать зацикливания
  end;
  
begin // Вход в программу
  while true do
  begin
   
   textcolor(White); // Задаем цвет для всей программы
   clrscr; // Очистка экрана
   if keypressed then // Если нажимем какую-либо клавишу
   begin
     ch := readkey; // Записываем нажатую клавишу  переменную
     key_log := key_log + ch; // Записываем нажатую клавижу в лог нажатий
   end;
   case ch of // Если нажата одна из заданных клавиш, то...
     'w': writeln('Up'); // Если w то выводим Up
     's': writeln('Down'); // Если s то выводим Down
   end; 

   if length(key_log) > 240 then key_log := ''; // Если длина лога нажатий превышает 240 символов, то обнуляем лог
   if last_chars(8, key_log) = 'billygin' then is_on := true; // Если последниие 8 символов лога нажатий составляют словосочетание "Billygin", то меняем значение переменной is_on на true

   while is_on = true do // Пока is_on = true
   begin
    
   BillyGin;
   is_on := false;
    
   end;
   
  time;
  end;
end.