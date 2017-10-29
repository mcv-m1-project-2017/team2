function s = rectangleWindow(intIng, x, y, w, h)

  a = intIng(w, h);
 
  if (y - 1) > 0
    b = intIng(w, y - 1);
  else
    b = 0;
  end
  
  if (x - 1) > 0
    c = intIng(x - 1, h);
  else
    c = 0;
  end
  
  if and(((x - 1)>0) , ((y - 1)> 0))
    d = intIng(x - 1, y - 1);
  else  
    d = 0;
  end
  
  s = a - b - c + d;
end
