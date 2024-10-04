function [mask_BW, mask_instance] = YOLOSeg_txt2mask(fn_img, fn_txt, isPlot)
    img = imread(fn_img);
    fid = fopen(fn_txt, 'r');

    [im_w, im_h, ~] = size(img);
    mask_BW = zeros(im_w, im_h);
    mask_instance = zeros(im_w, im_h);
    
    if isPlot == true
        figure
        imshow(img)
        hold on
    end
    
    idx = 0;
    while ~feof(fid)
        line = fgetl(fid);
        row = sscanf(line, '%f');
        pgon = polyshape(row(2:2:end).*im_h, row(3:2:end).*im_w);
        if isPlot == true
            plot(pgon, EdgeColor='k',LineWidth=2,FaceAlpha=0.4);
        end
        idx = idx + 1;
        temp = poly2mask(row(2:2:end)*im_h, row(3:2:end)*im_w, im_w, im_h);
        mask_BW = mask_BW + temp;
        % mask_instance = mask_instance + temp.*idx;
        mask_instance = cat(3, mask_instance, temp);
        mask_instance(:,:,1) = ~mask_BW;
    end
    fclose(fid);