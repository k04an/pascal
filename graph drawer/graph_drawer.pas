uses
  GraphABC;

const
  screen_height = 600;
  screen_width = 600;

var
  x_start, y_start, x_cent, y_cent: integer; 
  function main(x: real): real;
  begin
    if x <> 0 then Result := abs(x);
    Result := -Result;
  end;
 
begin
  ClearWindow(clBlack);
  SetPenColor(clWhite);
  x_start := -screen_width div 2;
  y_start := -screen_height div 2;
  x_cent := screen_width div 2;
  y_cent := screen_height div 2;

  MoveTo(x_start+x_cent, round(main(x_start) * 10)+y_cent);
  
  for var i := x_start to x_cent do
  begin
  LineTo(i+x_cent, round(main(i) * 10)+y_cent); 
  end;

end.