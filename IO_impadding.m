function img_new = IO_impadding(img,d)
[w, h] = size(img);
img_new = zeros(w+2*d, h+2*d);
img_new(d+1:d+w,d+1:d+h) = img;

end