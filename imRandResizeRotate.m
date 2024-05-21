function [new_img, new_ann] = imRandResizeRotate(img, ann, r1, r2)

temp_C3 = ann(:,:,3)>0;

p_resize = randi([r1 r2])./100;
p_rotate = randi([1 4]).*90;

new_img = imresize(img, p_resize);
new_img = imrotate(new_img, p_rotate);

temp_C3 = imresize(temp_C3, p_resize);
temp_C3 = imrotate(temp_C3, p_rotate);

temp_C3_2 = imdilate(temp_C3, strel('disk', 1)) - temp_C3;
new_ann = uint8(cat(3, temp_C3_2.*0, temp_C3_2.*255, temp_C3).*255);

end