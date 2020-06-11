uses 
  GraphABC;

var
  f: string;
  pic: picture;

  function filter(c: color): color;
  var
    r, g, b: integer;
  begin
    r := GetRed(c);
    g := GetGreen(c);
    b := GetBlue(c);
    
    if max(r, g, b) = r then Result := RGB(255, 0, 0);
    if max(r, g, b) = g then Result := RGB(0, 255, 0);
    if max(r, g, b) = b then Result := RGB(0, 0, 255);
    
  end;
 
begin
  window.Height := 0; // Настройки окна
  window.Width := 200;
  window.IsFixedSize := true;
  
  readln(f); //Читаем имя файла
  
  pic := picture.Create(f); // Создаем картинку из файла
  
  for var ix := 0 to pic.Width - 1 do
  begin
    for var iy := 0 to pic.Height - 1 do
    begin
      pic.PutPixel(ix, iy, filter(pic.GetPixel(ix, iy)));  
    end;
  end;

  pic.Save('result_' + f);
  halt;
  
end.