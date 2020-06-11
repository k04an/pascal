uses
  GraphABC;

var
  pic_r, pic_g, pic_b: picture;
  f: string;

  function filter_r(c: color): color; // Фильтр красного
  var
    r, g, b, gc: integer;
  begin
    r := GetRed(c);
    g := GetGreen(c);
    b := GetBlue(c);
    if (r > g) and (r > b) then Result := c
    else
    begin
      gc := round((r + g + b) / 3);
      Result := RGB(gc, gc, gc);
    end;
  end;
  
  function filter_g(c: color): color; // Фильтр зеленого
    var
      r, g, b, gc: integer;
    begin
      r := GetRed(c);
      g := GetGreen(c);
      b := GetBlue(c);
      if (g > r) and (g > b) then Result := c
      else
      begin
        gc := round((r + g + b) / 3);
        Result := RGB(gc, gc, gc);
      end;
    end;
    
  function filter_b(c: color): color; // Фильтр синего
    var
      r, g, b, gc: integer;
    begin
      r := GetRed(c);
      g := GetGreen(c);
      b := GetBlue(c);
      if (b > g) and (b > r) then Result := c
      else
      begin
        gc := round((r + g + b) / 3);
        Result := RGB(gc, gc, gc);
      end;
    end;

begin
  window.IsFixedSize := true; // Настравиваем окно
  window.Height := 15;
  window.Width := 250;
  TextOut(0,0, 'Enter file name: ');
  
  readln(f); // Читаем имя файла
  pic_r := picture.Create(f); // Открываем файл и записываем картинку в 3 разные переменные
  pic_g := picture.Create(f);
  pic_b := picture.Create(f);
  
  clearwindow;
  window.Height := 120;
  window.Width := 180;
  TextOut(0, 0, 'Start working with RED...');
  
  for var ix := 0 to pic_r.Width-1 do // Фильтруем красный
  begin
    for var iy := 0 to pic_r.Height-1 do
    begin
      pic_r.PutPixel(ix, iy, filter_r(pic_r.GetPixel(ix, iy)));   
    end;
  end;
  
  TextOut(0, 15, 'Done!');
  TextOut(0, 30, 'Start working with GREEN...');
  
  for var ix := 0 to pic_g.Width-1 do // Фильтруем зеленый
  begin
    for var iy := 0 to pic_g.Height-1 do
    begin
      pic_g.PutPixel(ix, iy, filter_g(pic_g.GetPixel(ix, iy)));   
    end;
  end;
  
  TextOut(0, 45, 'Done!');
  TextOut(0, 60, 'Start working with BLUE...');
  
  for var ix := 0 to pic_b.Width-1 do //Фильтруем синий
  begin
    for var iy := 0 to pic_b.Height-1 do
    begin
      pic_b.PutPixel(ix, iy, filter_b(pic_b.GetPixel(ix, iy)));   
    end;
  end;
  
  TextOut(0, 75, 'Done!');
  TextOut(0, 90, 'Saving results...');

  pic_r.Save('result_r_' + f); // Сохраняем результаты
  pic_g.Save('result_g_' + f);
  pic_b.Save('result_b_' + f);
  
  TextOut(0, 105, 'Give me a YEAH!');
  Sleep(3500);
  
  Halt;

end.