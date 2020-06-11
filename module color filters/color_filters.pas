//Небольшой модуль содержаший цветовые фильтры 
//(С) k04an
unit color_filters;

interface
uses
  GraphABC;

  function invert_colors(p: picture): picture; // Функция инвертирующая цвета на картинке
  function separate_colors(p: picture; c: char): picture; // Функция отделяющая цветовой канал от других
  function only_main_colors(p: picture): picture; // Функция возводящая все цвета в "абсолют"
  function discolor(p: picture): picture; // Функция обесцвечивания
  

  
implementation

  function invert_colors(p: picture): picture; // Функция инвертирующая цвета на картинке
  
    function invert_filter(c: color): color; //Вспомогательная функция, для определяния инвертированного цвета
    begin
      Result := RGB(255 - GetRed(c), 255 - GetGreen(c), 255 - GetBlue(c));
    end;
    
  begin
    for var iy := 0 to p.Height - 1 do // Для каждого пикселя картинки...
    begin
      for var ix := 0 to p.Width - 1 do
      begin
        p.PutPixel(ix, iy, invert_filter(p.GetPixel(ix, iy))); // Перерисовываем пиксель инвертируя цвет
      end;
    end; 
    Result := p; // Возвращаем результат
  end;
  

  function separate_colors(p: picture; c: char): picture;
  
    function separate_filter(c: color; can: char): color; // Функция-фильтр
    begin
      case can of // В зависимости от канала, который нужно фильтровать. Если в указанном пикселе преобладает цвет указанного канала, то игнорируем, иначе - обесцвечивам.
        'r': begin if max(GetRed(c), GetGreen(c), GetBlue(c)) = GetRed(c) then begin Result := c; end else begin Result := RGB(round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3)); end; end;
        'g': begin if max(GetRed(c), GetGreen(c), GetBlue(c)) = GetGreen(c) then begin Result := c; end else begin Result := RGB(round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3)); end; end;
        'b': begin if max(GetRed(c), GetGreen(c), GetBlue(c)) = GetBlue(c) then begin Result := c; end else begin Result := RGB(round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3)); end; end;
      end;
    end;
    
  begin
    for var iy := 0 to p.Height - 1 do // Для каждого пикселя картинки...
    begin
      for var ix := 0 to p.Width - 1 do
      begin
        p.PutPixel(ix, iy, separate_filter(p.GetPixel(ix, iy), c)); // Перерисовываем пиксель применяя фильтр
      end;
    end; 
    Result := p; // Возвращаем результат     
  end;


  function only_main_colors(p: picture): picture; // Функция возводящая все цвета в "абсолют"
  
    function filter_main_color(c: color): color; // Функция-фильтр
    begin
        if (GetRed(c) > GetBlue(c)) and (GetRed(c) > GetGreen(c)) then Result := RGB(255, 0, 0);
        if (GetGreen(c) > GetRed(c)) and (GetGreen(c) > GetBlue(c)) then Result := RGB(0, 255, 0);
        if (GetBlue(c) > GetRed(c)) and (GetBlue(c) > GetGreen(c)) then Result := RGB(0, 0, 255);
    end;
  
  begin
      for var iy := 0 to p.Height - 1 do // Для каждого пикселя картинки...
    begin
      for var ix := 0 to p.Width - 1 do
      begin
        p.PutPixel(ix, iy, filter_main_color(p.GetPixel(ix, iy))); // Перерисовываем пиксель применяя фильтр
      end;
    end; 
    Result := p; // Возвращаем результат   
  end;


  function discolor(p: picture): picture; // Функция обесцвечивания
  
    function filter_discolor(c: color): color; // Функция-фильтр
    begin
      Result := RGB(round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3), round((GetRed(c) + GetGreen(c) + GetBlue(c)) / 3));
    end;
  
  begin
      for var iy := 0 to p.Height - 1 do // Для каждого пикселя картинки...
    begin
      for var ix := 0 to p.Width - 1 do
      begin
        p.PutPixel(ix, iy, filter_discolor(p.GetPixel(ix, iy))); // Перерисовываем пиксель применяя фильтр
      end;
    end; 
    Result := p; // Возвращаем результат   
  end;  
 
end.