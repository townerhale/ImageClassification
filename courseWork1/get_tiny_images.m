function [image_feat] = get_tiny_images(train_image_paths, downSampleSize, normalise, colourspace, crop)
    %size the image will be downsampled to
	downSampleSize = 7;
	%create image_feat which contains
	N = size(train_image_paths, 1);
	d = downSampleSize*downSampleSize*3;
	image_feat = zeros(N, d);
    %loop through each training image
	for i=1:size(train_image_paths, 1)
		img = imread(train_image_paths{i});
        img = double(img);
        
        %if colourspace is 1 then rgb is used
        if colourspace == 2
        %use grayscale
            img = rgb2gray(img);
        elseif colourspace == 3
        %use rg colour space
            imgR = img(:,:,1);
            imgG = img(:,:,2);
            imgB = img(:,:,3);
            R = imgR./(imgR+imgG+imgB);
            G = imgG./(imgR+imgG+imgB);
            img(:,:,1) = R;
            img(:,:,2) = G;
            img(:,:,3) = [];
        elseif colourspace == 4
        %use HSV color space
            img = rgb2hsv(img);
        end
        
        
        if crop == 1
        %downsample the image
            img = imresize(img, [downSampleSize downSampleSize]);
        else
            %crop instead of downsample
            %get middle of image
            cropsize = 64;
            ymin = (size(img, 1)/2) + (cropsize/2);
            xmin = (size(img, 2)/2) + (cropsize/2);
            img = imcrop(img, [xmin ymin cropsize-1 cropsize-1]);
        end    
        %put colours in image into image_feat
		tiny_image_colours = transpose(img(:));
        
        %normalise colour histogram, there are three different ways
        %zero mean is uncommented
        if normalise == 2
            %tiny_image_colours = tiny_image_colours./d;
            tiny_image_colours = tiny_image_colours-mean(tiny_image_colours(:));
            %tiny_image_colours = tiny_image_colours/std(tiny_image_colours(:));
        end
        
		image_feat(i,:) = tiny_image_colours;
	end
end