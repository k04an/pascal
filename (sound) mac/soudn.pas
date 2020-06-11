uses
  system;

  
  procedure s(row, time: integer);
  var
    frq: integer;
  begin
    case row of
      1: frq := 82;
      2: frq := 110;
      3: frq := 147;
      4: frq := 196;
      5: frq := 247;
      6: frq := 339;
    end;
    system.Console.Beep(frq, time*100);
  end;
  
begin
  while true do
  begin
  s(2, 6);
  s(2, 2);
  s(3, 2);
  s(3, 6);
  s(4, 2);
  s(4, 4);
  s(3, 4);
  s(3, 4);
  s(3, 8);
  s(2, 2);
  s(3, 2);
  s(3, 6);
  s(4, 2);
  s(4, 4);
  s(3, 4);
  s(3, 4);
  s(2, 7);
  
  s(2, 2);
  s(3, 2);
  s(3, 6);
  s(4, 2);
  s(4, 4);
  s(3, 4);
  s(3, 4);
  s(3, 8);
  s(2, 2);
  s(3, 2);
  s(3, 4);
  s(2, 7);
  end;
 
end.