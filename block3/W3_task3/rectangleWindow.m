function s = rectangleWindow(integral_image, x, y, w, h)

  a = integral_image(w, h);
 
  if (y - 1) > 0
    b = integral_image(w, y - 1);
  else
    b = 0;
  end
  
  if (x - 1) > 0
    c = integral_image(x - 1, h);
  else
    c = 0;
  end
  
  if and(((x - 1)>0) , ((y - 1)> 0))
    d = integral_image(x - 1, y - 1);
  else  
    d = 0;
  end
  
  s = a - b - c + d;
end