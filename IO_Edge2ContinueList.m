function [map, list] = IO_Edge2ContinueList(img)
    list = [];
    img = IO_impadding(img,2);
    im2 = imdilate(img,strel('disk',1));
    tar = im2 - img;
    tar = tar(3:end-2,3:end-2);
    [w, h] = size(tar);
    map = zeros(w, h);
    [yy,xx] = find(tar>0);
    num = 0;
    flag_find = 0;
    x0 = xx(1);
    y0 = yy(1);
    x0_old = x0;
    y0_old = y0;
    for nn = 1:length(xx)
        flag2 = 0;
        for jj = x0-1:x0+1
            for ii = y0-1:y0+1
                if jj == x0 && ii == y0
                    continue;
                end
                if tar(ii,jj)>0 && map(ii,jj)==0
                    num = num+1;
                    map(ii,jj) = num;
                    list = [list,[jj/h,ii/w]];
                    flag_find = 1;
                    break
                end
            end
            if flag_find == 1
                break;
            end
        end
        if flag_find == 1
            flag_find = 0;
            x0_old = x0;
            y0_old = y0;
            x0 = jj;
            y0 = ii;
        else
            x0 = x0_old;
            y0 = y0_old;
        end
    end
end