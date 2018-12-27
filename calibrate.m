function [major_threshold, minor_threshold] = calibrate(webcam_obj)

img = webcam_obj;
axis off

for i = 1:500

    c = snapshot(img);
    x = imresize(c, [90 90]);
 
    if i > 1

        im_diff(i,1) = sum(sum(sum(x - a)));
        im_diff(i,2) = sum(sum(sum(x(:,:,1) - a(:,:,1))));
        im_diff(i,3) = sum(sum(sum(x(:,:,2) - a(:,:,2))));
        im_diff(i,4) = sum(sum(sum(x(:,:,3) - a(:,:,3))));
        
        title({'Calibrating for Minor Movements.';'Kindly refrain from Performing any kind of Activity...';'Press Enter to Continue'})
        
        if i == 2
            pause()
        end
    end
    
    if i <= 250 && i > 1
        title({'Calibrating for Minor Movements.';'Kindly refrain from Performing any kind of Activity...'})     
    end
    
    if i == 250
        minor_threshold = calib(im_diff(:,1));
        title('Press Enter to Continue');
        pause()
    end   
    
    if i > 250 && i <= 500
        title({'Calibrating for Environmental Change.';'Kindly change the Surroundings, or move the device to a new location... '})
    end 
    
    if i == 500
        major_threshold = calib(im_diff(:,1));
        title('Press Enter to Continue.');
        pause()
    end   
    a = x;
end