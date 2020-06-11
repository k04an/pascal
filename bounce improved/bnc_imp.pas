uses
  GraphABC;
  
const
  screen_width = 170; // Ширина окна
  screen_height = 150; // Высота окна
  background_color = clWhite;
  ball_radius = 10;

type
  ball_rec = record
    x, y, ha, va: integer;
    color: color;
  end;

var
  ball: ball_rec;

  procedure SetScreenSettings; // Процедура устанавливающая параметры окна
  begin
    SetWindowWidth(screen_width);
    SetWindowHeight(screen_height);
    SetWindowIsFixedSize(true);
  end;

  procedure render_ball; // Процедура движения и отрисовки мяча
  begin
    SetBrushColor(background_color); // Затираем предыдущее положении мяча
    FillCircle(ball.x, ball.y, ball_radius+1);
    
    if (ball.x - ball_radius <= 0) or (ball.x + ball_radius >= screen_width) then begin  ball.ha := -ball.ha; ball.color := clRandom; end; //Если мяч ударяется о границу окна, то инвертируем соответсвующее ускорение и меняем цвет на случайный
    if (ball.y - ball_radius <= 0) or (ball.y + ball_radius >= screen_height) then begin ball.va := -ball.va; ball.color := clRandom; end;
    
    
    ball.x := ball.x + ball.ha; // Меняем его координаты в соответствии с ускорением
    ball.y := ball.y + ball.va;
    
    SetBrushColor(ball.color); // Отрисовыываем мяч с новыми координатами
    FillCircle(ball.x, ball.y, ball_radius);
    Redraw; // Отрисоываем
  end;


      // !Начало программы! //
begin
  
  LockDrawing; // Включаем режим отрисовки чере звиртуальный буфер
  SetScreenSettings; // Настравиваем окно программы
  ball.x := 50; // Начальные координаты мяча
  ball.y := 70;
  ball.ha := 2; // Ускорение мяча
  ball.va := 1;
  ball.color := clRandom; // Начальный цвет мяча
  
  while true do // "Игровой" цикл
  begin
    render_ball; // Двигаем и отрисовываем мяч
    sleep(10); // Задержка
  end;

end.