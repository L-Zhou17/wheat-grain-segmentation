clear,clc,close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_samples_datasets = [120, 40, 40]; % number of samples for training, validation and prediction
map_size = 512; % size of generated images
max_num = 300; % maximum number of objects
target = 'Wheat'; % name of the object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
root = [target '-Gen/'];
modes = {'train', 'valid', 'test'};
mkdir(root);
for mm = 1:3
    mode = modes{mm};
    sam_num = num_samples_datasets(mm);
    mkdir([root 'images/' mode '/']);
    mkdir([root 'labels/' mode '/']);
    mkdir([root 'masks/'  mode '/']);
    list = dir([target '-base/image/*.png']);
    list = {list.name}';
    for pp = 1:sam_num
        fid2  = fopen([root,'labels/',mode,'/',num2str(pp),'.txt'],'a+');
        idx = (1:length(list))';
        rowrank = randperm(size(idx, 1));
        idx = idx(rowrank,:);  
        map_img = uint8(zeros(map_size, map_size, 3));
        map_ann = uint8(zeros(map_size, map_size, 3));
        map_roi = logical(zeros(map_size, map_size));
        for ii = 1:max_num
            temp_idx = idx(ii);
            temp_img = imread([target '-base/image/' list{temp_idx}]);
            temp_ann = imread([target '-base/label/' list{temp_idx}]);
            [temp_img, temp_ann] = imRandResizeRotate(temp_img, temp_ann, 80, 120);
    
            temp_roi = (temp_ann(:,:,2) + temp_ann(:,:,3))>0;
            [tw, th, tc] = size(temp_img);
            start_y = randi([3, map_size-tw-2]);
            for jj = 6:map_size-th
                temp_compare = map_roi(start_y:start_y+tw-1, jj:jj+th-1);
                if sum(sum(temp_compare & temp_roi)) ~= 0
                    continue
                else
                    rd = randi([0, 1]);
                    map_blk = logical(zeros(map_size, map_size));
                    map_img(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) = map_img(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) + temp_img;
                    map_ann(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) = map_ann(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) + temp_ann;
                    map_roi(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) = map_roi(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) + temp_roi;
                    map_blk(start_y:start_y+tw-1, jj-rd:jj+th-1-rd, :) = temp_roi;
                    [maps, points] = IO_Edge2ContinueList(map_blk);
                    fprintf(fid2,'%d', 0); 
                    fprintf(fid2,' ');
                    for NN = 1:length(points)
                        fprintf(fid2,'%f ', points(NN)); 
                        fprintf(fid2,' ');
                    end
                    fprintf(fid2,'\n');
                    break;
                end
            end
        end
        imwrite(map_img,[root 'images/' mode '/' num2str(pp) '.png']);
        imwrite(map_ann,[root 'masks/'  mode '/' num2str(pp) '.png']);
        fclose(fid2);
    end
end

figure
subplot(221)
imshow(map_img)
subplot(222)
imshow(map_ann)
subplot(223)
imshow(map_roi)
