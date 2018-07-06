function [image_feats] = spatial_pyramid(image_paths, colour)
%SPATIAL_PYRAMID Creates a 3 level pyramid and calculates SIFT histograms
%for each level of the pyramid. Each histogram is weighted and put
%into one big vector for each image

    vocab = load('vocab.mat');
    vocab = vocab.vocab;
    clusterSize = size(vocab, 2);
    pyramidLevels = 2;
    
    %calculate total number of features for the image
    totalNumberOfFeatures = 0;
    for i=1:(pyramidLevels+1)
       totalNumberOfFeatures = totalNumberOfFeatures + (4^(i-1)*clusterSize); 
    end
    %the features for each image is stored here
    image_feats = zeros(size(image_paths,1), totalNumberOfFeatures);
    
    %loop through each image and create the histogram for it
    for i=1:size(image_paths,1)
        pyramid_level = 0;
        all_histograms = zeros(1, totalNumberOfFeatures);
        countBegin = 1;
        countEnd = clusterSize;
        img = imread(image_paths{i});
        
        %LEVEL 0 - for pyramid level 0 get the features
        %get sift features and create hsitogream for this level
        weight = 1/(2^(pyramidLevels-pyramid_level));
        level_0_hist = create_sift_features(img, clusterSize, colour);
        %weight the histogram
        level_0_hist = level_0_hist.*weight; 
        %put histogram in all_histogram
        all_histograms(countBegin:countEnd) = level_0_hist;
        countBegin = countBegin + clusterSize;
        countEnd = countEnd + clusterSize;
        
        %LEVEL 1 - for pyramid level 1 get the features
        pyramid_level = pyramid_level + 1;
        weight = 1/(2^(pyramidLevels-pyramid_level));
        [r, c, rgb] = size(img);
        
        %split the image into 4 quadrants
        upLeft = img(1:round(r/2), 1:round(c/2), :);
        upRight = img(1:round(r/2), round(c/2):end, :);
        lowLeft = img(round(r/2)+1:end, 1:round(c/2), :);
        lowRight = img(round(r/2)+1:end, round(c/2)+1:end, :);
        
        %calculate sift features and histogreams and then weight 
        %histrograms for each quadrant
        
        %get SIFT features and get histogream for upper left quadrant
        %and then put it in all_histograms
        level_1_upLeft_hist = create_sift_features(upLeft, clusterSize, colour);
        level_1_upLeft_hist = level_1_upLeft_hist.*weight;
        all_histograms(countBegin:countEnd) = level_1_upLeft_hist;
        countBegin = countBegin + clusterSize;
        countEnd = countEnd + clusterSize;
        
        %get SIFT features and get histogream for upper right quadrant
        %and then put it in all_histograms
        level_1_upRight_hist = create_sift_features(upRight, clusterSize, colour);
        level_1_upRight_hist = level_1_upRight_hist.*weight;
        all_histograms(countBegin:countEnd) = level_1_upRight_hist;
        countBegin = countBegin + clusterSize;
        countEnd = countEnd + clusterSize;
        
        %get SIFT features and get histogream for lower left quadrant
        %and then put it in all_histograms
        level_1_lowLeft_hist = create_sift_features(lowLeft, clusterSize, colour);
        level_1_lowLeft_hist = level_1_lowLeft_hist.*weight; 
        all_histograms(countBegin:countEnd) = level_1_lowLeft_hist;
        countBegin = countBegin + clusterSize;
        countEnd = countEnd + clusterSize;
        
        %get SIFT features and get histogream for lower right quadrant
        %and then put it in all_histograms
        level_1_lowRight_hist = create_sift_features(lowRight, clusterSize, colour);
        level_1_lowRight_hist = level_1_lowRight_hist.*weight;
        all_histograms(countBegin:countEnd) = level_1_lowRight_hist;
        countBegin = countBegin + clusterSize;
        countEnd = countEnd + clusterSize;
        
        %LEVEL 2 - for pyramid level 2 get the features
        pyramid_level = pyramid_level + 1;
        weight = 1/(2^(pyramidLevels-pyramid_level));
        %loop through each quadrant and split the quadrant into 4 more
        %quadrants
        quadrants = {upLeft, upRight, lowLeft, lowRight};
        for j=1:size(quadrants,2)
            %split current quadrant into 4 more quadrants
        	quad_img = quadrants{j};
            [r, c, rgb] = size(quad_img);
            upLeft = quad_img(1:round(r/2), 1:round(c/2), :);
            upRight = quad_img(1:round(r/2), round(c/2):end, :);
            lowLeft = quad_img(round(r/2)+1:end, 1:round(c/2), :);
            lowRight = quad_img(round(r/2)+1:end, round(c/2)+1:end, :);
            
            %calculate sift features and histogreams and then weight 
            %histrograms for each quadrant
            level_2_upLeft_hist = create_sift_features(upLeft, clusterSize, colour);
            level_2_upLeft_hist = level_2_upLeft_hist.*weight;
            all_histograms(countBegin:countEnd) = level_2_upLeft_hist;
            countBegin = countBegin + clusterSize;
            countEnd = countEnd + clusterSize;
            
            level_2_upRight_hist = create_sift_features(upRight, clusterSize, colour);
            level_2_upRight_hist = level_2_upRight_hist.*weight;
            all_histograms(countBegin:countEnd) = level_2_upRight_hist;
            countBegin = countBegin + clusterSize;
            countEnd = countEnd + clusterSize;
            
            level_2_lowLeft_hist = create_sift_features(lowLeft, clusterSize, colour);
            level_2_lowLeft_hist = level_2_lowLeft_hist.*weight;
            all_histograms(countBegin:countEnd) = level_2_lowLeft_hist;
            countBegin = countBegin + clusterSize;
            countEnd = countEnd + clusterSize;
            
            level_2_LowRight_hist = create_sift_features(lowRight, clusterSize, colour);
            level_2_LowRight_hist = level_2_LowRight_hist.*weight;
            all_histograms(countBegin:countEnd) = level_2_LowRight_hist;
            countBegin = countBegin + clusterSize;
            countEnd = countEnd + clusterSize;
        end
        
        %put histogram in image_feats
        image_feats(i,:) = all_histograms;
    end
end

