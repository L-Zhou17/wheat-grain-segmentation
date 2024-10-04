clear,clc,close all
warning('off','all');
threshold = 0.5;         % set the IoU threshold

fd_image = 'images';     % the folder of images (.png)
fd_labels = 'labels';     % the folder of labels (.txt)
fd_predictions = 'predictions';     % the folder of predictions (.txt)

fn_list = dir([fd_image '/*.png']); 
fn_list = {fn_list.name};
eval_list = [];

for ii = 1:length(fn_list)
    disp(ii)
    imname = fn_list{ii};
    fn_img = [fd_image '/' imname];
    fn_pr = [fd_labels '/' imname(1:end-3) 'txt'];
    fn_gt = [fd_predictions '/' imname(1:end-3) 'txt'];
    [~, GT] = YOLOSeg_txt2mask(fn_img, fn_gt, false);
    [~, PR] = YOLOSeg_txt2mask(fn_img, fn_pr, false);
    ins_PR = size(PR,3);
    ins_GT = size(GT,3);

    IoU_list_i = [0, 0];
    for kk = 2:ins_PR
        IoU_list_c = 0;
        temp_PR = PR(:,:,kk);
        for mm = 2:ins_GT
            temp_GT = GT(:,:,mm);
            temp_IoU = sum(sum(temp_PR & temp_GT)) / sum(sum(temp_PR | temp_GT));
            IoU_list_c = [IoU_list_c; temp_IoU];
        end
        [a1, a2] = max(IoU_list_c);
        IoU_list_i = [IoU_list_i; [a1, a2]];
    end
    
    mAP50 = sum(IoU_list_i(2:end, 1)>threshold)/(size(IoU_list_i,1)-1);
    mIoU = mean(IoU_list_i(2:end, 1));
    eval_list = [eval_list; [mAP50, mIoU, ins_PR, ins_GT]];
end
mAP50_dataset = sum(eval_list(:,1).*eval_list(:,3))/sum(eval_list(:,3));
mIoU_dataset = sum(eval_list(:,2).*eval_list(:,3))/sum(eval_list(:,3));
disp(['mAP = ' num2str(mAP50_dataset)])
disp(['mIoU = ' num2str(mIoU_dataset)])
