// Сборка процедур и функций, которыми я часто пользуюсь
unit cabbtoolkit;

  interface
  
    function map(scr, s1, e1, s2, e2: real): real;
    
    
  implementation
  
    function map(scr, s1, e1, s2, e2: real): real; // Функция map. Аналог функции из Processing. Без понятия, как это работает
    begin
      Result := b2 + (e2 - b2) * ((src - b1) / (e1 - b1));  
    end;

end.