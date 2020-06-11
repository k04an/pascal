uses
    graphABC;

  procedure dual_pie(x, y, r, dist, delay: integer; cl1, cl2: color);
  var
    current_color: color;
    pos: integer;
  begin
    current_color := cl1;
    while pos < 360 do
    begin
      SetBrushColor(current_color);
      if pos + dist > 360 then       FillPie(x, y, r, pos, 360)
      else FillPie(x, y, r, pos, pos + dist);
      pos := pos + dist;
      if current_color = cl1 then current_color := cl2
      else current_color := cl1;
      sleep(delay);
    end;
  end;
  
begin
  SetWindowHeight(500);
  SetWindowWidth(500);
  SetWindowIsFixedSize(true);
  
  ClearWindow(clBlack);
  
  while true do
  begin
    dual_pie(random(500), random(500), random(100)+50, random(10)+1, 5, clRandom, clRandom);
  end;
  
end.