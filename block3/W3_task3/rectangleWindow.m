function s = rectangleWindow(intIng, x, y, h, w)

  a = intIng(h, w);
 
  if (x - 1) > 0
    b = intIng(h, w - 1);
  else
    b = 0;
  end
  
  if (y - 1) > 0
    c = intIng(y - 1, w);
  else
    c = 0;
  end
  
  if and(((y - 1)>0) , ((x - 1)> 0))
    d = intIng(y - 1, x - 1);
  else  
    d = 0;
  end
  
  s = a - b - c + d;
end
