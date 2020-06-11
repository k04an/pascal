unit menu_unit;

interface
uses
  crt;
  
var
  cursor_position: integer;
  menu_page: string;
  is_page_switched, game: boolean;
  
  procedure show_logo;
  procedure show_menu;
  procedure pr(str: string; color, x, y: integer);
  procedure cursor(k: char);
  procedure main_menu;
  procedure rules_menu;
  procedure about_menu;
  
implementation

  procedure show_logo; // Процедура выводящая логотип в виде ASCII
  var
    logo: array[1..6, 1..1] of string;
    i, j, h_margin, v_margin: integer;
  begin
    h_margin := 7; // Отступ от левого края 
    v_margin := 1; // Отступ от верха
    
    logo[1,1] := '        _              __                                   '; // Массив с лого
    logo[2,1] := '  /\/\ (_)_ __   ___  / _\_      _____  ___ _ __   ___ _ __ ';
    logo[3,1] := ' /    \| | "_ \ / _ \ \ \\ \ /\ / / _ \/ _ \ "_ \ / _ \ "__|';
    logo[4,1] := '/ /\/\ \ | | | |  __/ _\ \\ V  V /  __/  __/ |_) |  __/ |   ';
    logo[5,1] := '\/    \/_|_| |_|\___| \__/ \_/\_/ \___|\___| .__/ \___|_|   ';
    logo[6,1] := '                                           |_|            ';
    
    textcolor(15);
    for i := 1 to 6 do // Циклы прогоняющие массив и выводящие каждый символ
    begin
      for j := 1 to length(logo[i, 1]) do
      begin
        gotoxy(j + h_margin, i+v_margin);
        write(logo[i,1][j]);
      end;
    end;
  end;

  procedure pr(str: string; color, x, y: integer); // Процедура для упрощенного вывода текста поо координатам с указанием цвета
  begin
    textcolor(color);
    gotoxy(x, y);
    write(str);
  end;

  procedure cursor(k: char); // Процедура отривоывающая и перемещающая курсор
  begin
    pr (' ', 15, 28, 13); // Затираем предыдущее изображение курсора
    pr (' ', 15, 28, 15);
    pr (' ', 15, 28, 17);
    pr (' ', 15, 28, 19);
    
    case k of // При нажатии клавиши W или S, пзиия курсора меняется соответсвенно
      'w': begin if cursor_position <> 1 then Dec(cursor_position); end;
      's': begin if cursor_position <> 4 then Inc(cursor_position); end;
    end;
    
    if k = #13 then // Если был нажат Enter, то объявляем переключение отображаемой страницы
    begin
      case cursor_position of
        1: begin game:= true; is_page_switched := true; end;
        2: begin menu_page := 'rules'; is_page_switched := true; end;
        3: begin menu_page := 'about'; is_page_switched := true; end;
        4: begin clrscr; halt; end;
      end;
    end;
    
    case cursor_position of // Отрисовываем курсор, в зависимости от позиции
      1: pr('>', 15, 28, 13); 
      2: pr('>', 15, 28, 15);
      3: pr('>', 15, 28, 17);
      4: pr('>', 15, 28, 19);
    end;
  end;

  procedure main_menu; // Главная страница меню
  begin
    clrscr;  // Очищаем экран
    show_logo; // Все лого
    pr('AKA свипер майнов', 9, 51,8);
    pr('или же просто Сапер', 12, 49,9);
      
    pr ('Начать игру', 15, 30, 13); // Отрисовываем кнопки
    pr ('Правила и управление', 15, 30, 15);
    pr ('Об авторе', 15, 30, 17);
    pr ('Выход', 15, 30, 19);
      
    pr ('>', 15, 28, 13); // Отривовывем курсор в начальной позиции
    cursor_position := 1; // Задаем начальную позицию курсора
    while is_page_switched = false do // Цикл, для управление курсором. Работает пока не будет объявлена смена страницы
    begin
      cursor(readkey);  
    end;  
  end;

  procedure rules_menu; // Меню с правилами
  var
    i, j: integer;
  begin
    clrscr; // Очщаем экран
    
    for i := 1 to 18 do // Отрисовываем рамку
    begin
      for j := 1 to 70 do
      begin
        textcolor(15);
        gotoxy(j, i);
        if (i = 1) or (i = 18) or (j = 1) or (j = 70) then write('█') // Если ячейка имеет кординаты на указанной границе, то рисуем границу
        else write(' ');
      end;
    end;
    
    pr('Число в ячейке показывает, сколько мин скрыто вокруг данной ячейки', 15, 3, 3); // Вывод текста
    pr('Если рядом с открытой ячейкой есть пустая ячейка, то', 15, 3, 5);
    pr('она откроется автоматически', 15, 3, 6);
    pr('Если вы открыли ячейку с миной, то игра проиграна', 15, 3, 8);
    pr('Игра продолжается до тех пор, пока вы не откроете все', 15, 3, 10);
    pr('незаминированные ячейки.', 15, 3, 11);
    pr('Для того, чтобы открыть ячейку нажмите V', 15, 3, 13);
    pr('Для того, чтобы пометить ячейку, как мину, нажмите C', 15, 3, 15);
    pr('> В главное меню', 15, 2, 20);
    
    while is_page_switched = false do // Цикл, работающий, пока не будет объявлено, что страница сменилась
    begin
      if KeyPressed then // Если нажата клавишу
      begin
        if readkey = #13 then // Если нажат именно Enter, то...
        begin
          menu_page := 'main'; // Переключаем страницу на гравную
          is_page_switched := true; // Объявляем о переключении страницы
        end;
      end;
    end;
  end;
  
procedure about_menu; // Меню с информацие об авторе
  var
    i, j: integer;
  begin
    clrscr; // Очщаем экран
    
    for i := 1 to 15 do // Отрисовываем рамку
    begin
      for j := 1 to 70 do
      begin
        textcolor(15);
        gotoxy(j, i);
        if (i = 1) or (i = 15) or (j = 1) or (j = 70) then write('█') // Если ячейка имеет кординаты на указанной границе, то рисуем границу
        else write(' ');
      end;
    end;
    
    pr('Игрушка написана Кочаном (k04an)', 15, 3, 3); // Вывод текста
    pr('Зачем? Ради практики и немного от безделия', 15, 3, 5);
    pr('Как связатся? Думаю не стоит.', 15, 3, 7);
    pr('Но если совсем нужно, то: cabbjunk@ya.ru', 15, 3, 9);
    pr('Отель? Триваго', 15, 3, 11);
    pr('Орда? Сосатб', 15, 3, 13);
    pr('> В главное меню', 15, 3, 18);
    
    while is_page_switched = false do // Цикл, работающий, пока не будет объявлено, что страница сменилась
    begin
      if KeyPressed then // Если нажата клавишу
      begin
        if readkey = #13 then // Если нажат именно Enter, то...
        begin
          menu_page := 'main'; // Переключаем страницу на гравную
          is_page_switched := true; // Объявляем о переключении страницы
        end;
      end;
    end;
  end;
 
  procedure show_menu; // Основная процедура показа меню
  begin
    menu_page := 'main';
    game := false;
    while game = false do
    begin
      is_page_switched := false;
      while is_page_switched = false do
      begin
        case menu_page of
        'main': main_menu;
        'rules': rules_menu;
        'about': about_menu;
        end;
      end;  
    end;
      
  end;
 
end.

