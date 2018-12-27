clc; clear all;
img = webcam;
figure()
l = 90;
i = 1;


while 1
    
    c = snapshot(img);
    x = imresize(c, [l l]);
    values = 0:1/1000:.01;
    
    
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
    
    if i > 500
        
        subplot(1,2,1);
        image(c);
        
        if sum(sum(sum(x - a))) > minor_threshold && sum(sum(sum(x - a))) < 5*minor_threshold
            print = ['Movement Detected ',num2str(sum(sum(sum(x - a)))),'\n']; 
            fprintf(print);
            title('Slight Movement Detected')
        elseif sum(sum(sum(x - a))) > 5*minor_threshold
            print = ['Movement Detected ',num2str(sum(sum(sum(x - a)))),'\n']; 
            fprintf(print);
            title('Major Movement Detected')  
            if sum(sum(sum(x - a))) > major_threshold
                figure(2);
                [mit, mat] = calibrate(img);
            end
        else
            title('No Movement Detected')
            fprintf('No Movement Detected \n');
        end

        subplot(1,2,2)
        plot(0,0)
        title('Calibrating...')

        truesize([320 320]);
        scale = 0.01;
        pos = get(gca, 'Position');
        pos(2) = pos(2)+scale*pos(4);
        pos(4) = (1-scale)*pos(4);
        set(gca, 'Position', pos)

    end

    axis image;
    axis off;
        
    if i > 500
        
        if i > 500    
            subplot(1,2,2);
        end
    
    plot(i-120:i,im_diff(i-120:i,1),'-k') 
    xlim([i-120, i]);
    
    hold on
    
    plot(i-120:i,im_diff(i-120:i,2),'-r')
    plot(i-120:i,im_diff(i-120:i,3),'-b')
    plot(i-120:i,im_diff(i-120:i,4),'-g')
   
    title('Movemograph');
    
    hold off
    end
    
    
    a = x;
    
    i = i+1;
end