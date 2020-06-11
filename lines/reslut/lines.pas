uses
  GraphABC;

var
  pic: picture;
  pnts: array of point;
  frame, points: integer;

  procedure KeyUp(key: integer);
  begin
    if key = VK_F then
    begin  
      pic.Save('res.png');
      halt;
    end;
  end;
  
begin
  window.Height := 15;
  window.Width := 300;
  window.IsFixedSize := true;
  window.Title := 'Can nobody tell me nothing';

  pic := picture.Create(1600, 900);
  
  while true do
  begin
    points := random(500)+2;
    SetLength(pnts, points);
    for var i := 0 to points - 1 do
    begin
        pnts[i].X := random(pic.Width-1)+1;
        pnts[i].Y := random(pic.Height-1)+1;
    end;
    Brush.Color := clRandom;
    pic.FillPolygon(pnts);
    Inc(frame);
    clearwindow;
    Brush.Color := clWhite;
    TextOut(0, 0, frame + ' frames drawed');
    OnKeyUp := KeyUp;
  end;
  
end.