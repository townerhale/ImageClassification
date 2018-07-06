function [image_feat] = get_colour_histograms(image_paths, quantisationLevel, colourspace, normalise, removeBlack)
    %quantisation level
    quantisationLevel = 11;
	N = size(image_paths, 1);
    %each pixel in image will have 
	d = quantisationLevel*quantisationLevel*quantisationLevel;
	%features of the image will be stored in this matrix
    image_feat = zeros(N, d);
	
	for h=1:size(image_paths, 1)
		img = imread(image_paths{h});        
        
        %if colourspace is 1 then rgb is used
        if colourspace == 2
        %make Rg
            imgR = img(:,:,1);
            imgG = img(:,:,2);
            imgB = img(:,:,3);
            R = imgR./(imgR+imgG+imgB);
            G = imgG./(imgR+imgG+imgB);
            img(:,:,1) = R;
            img(:,:,2) = G;
            img(:,:,3) = [];
        elseif colourspace == 3
        %make colour gray
            img = rgb2gray(img);
        elseif colourspace == 4
		%make hsv
            img = rgb2hsv(img);
        end
        
        img = double(img);
        
        %quantisize the image
		imquant = img/255;
		imquant = round(imquant*(quantisationLevel-1)) + 1;
		%create histogram
		colourHistogram = zeros(quantisationLevel, quantisationLevel, quantisationLevel,1);
        %loop through each pixel in imquant
		for i=1:size(imquant, 1)
            %get rgb values and put them in the colour histogram
			for j=1:size(imquant, 2)
				r = imquant(i,j,1);
				g = imquant(i,j,2);
				b = imquant(i,j,3);
				colourHistogram(r,g,b) = colourHistogram(r,g,b) + 1;
			end
        end
        
        %put the colour histogram into image_feat
		colourHistogram = transpose(colourHistogram(:));
        
        %normalise colour histogram, there are three different ways
        %zero mean is uncommented
        if normalise == 2
            colourHistogram = colourHistogram-mean(colourHistogram(:));
            %colourHistogram = colourHistogram./d;
            %colourHistogram = colourHistogram/std(colourHistogram(:));
        end
        
        %remove black
        if removeBlack == 2
            colourHistogram(1) = [];
        end
		image_feat(h,:) = colourHistogram;
	end
end