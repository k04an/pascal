// Сборка процедур и функций, которыми я часто пользуюсь
unit cabbtoolkit;

  interface
  
    function map(src, s1, e1, s2, e2: real): real;
    
    
  implementation
  
    function map(src, s1, e1, s2, e2: real): real; // Функция map. Аналог функции из языка Processing. Без понятия, как это работает
    begin
      Result := s2 + (e2 - s2) * ((src - s1) / (e1 - s1));  
    end;

end.