uses
  crt;
const
  height = 12;
  width = 40;
  default_color = 15;
  background_color = 8;
var
  ha, va, x, y, object_color, coner_hits: integer;
  
  procedure RenderBorder;
  var
    i, j: integer;
  begin
    for i := 1 to Height do
    begin
      for j := 1 to Width do
      begin
        gotoxy(j, i);
        if (i = 1) or (i = Height) or (j = 1) or (j = Width) then Write('*')
        else 
        begin
          textbackground(background_color);
          Write(' ');
          textbackground(0);
        end;
      end;
    end;
  end;
  
  procedure RenderObject;
  begin
    textbackground(background_color);
    gotoxy(x, y);
    write(' ');
    
    x := x + ha;
    y := y + va;
    
    gotoxy(x, y);
    textcolor(object_color);
    writeln('@');
    textcolor(default_color);
    textbackground(0);
  end;
 
  procedure ChangeDirection;
  begin
    if (y = Height - 1) or (y = 2) then
      begin
        va := va * (-1);
        object_color := Random(15) + 1;
        while (object_color = 8) or (object_color = 7) do
        begin
          object_color := Random(15) + 1;          
        end;
      end;
    if (x = Width - 1) or (x = 2) then
      begin
        ha := ha * (-1);
        object_color := Random(15) + 1;
        while (object_color = 8) or (object_color = 7) do
        begin
          object_color := Random(15) + 1;          
        end;      
      end;
  end;
  
  procedure RenderStats;
  begin
    gotoxy(Width + 1, 2);
    write('           ');
    gotoxy(Width + 1, 2);
    write('Coner hits: ', coner_hits);
  end;
  
begin
  object_color := 15;
  RenderBorder;
  x := 5; y := 5;
  ha := 1; va := 1;
  
  while true do
  begin
    RenderObject;
    ChangeDirection;
    if ((x = 2) and (y = 2)) or ((x = 2) and (y = height - 1)) or ((x = Width - 1) and (y = 2)) or ((x = Width - 1) and (y = Height - 1)) then Inc(coner_hits);
    RenderStats;
    
    delay(50);
  end;
  
end.