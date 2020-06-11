var
  f: text;
  buff: string;
  
begin
  
  assign(f, 'ip.txt');
  
  reset(f);
  
  while not eof(f) do
  begin
    readln(f, buff);
    writeln(buff);
  end;
  
end.