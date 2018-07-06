function [histogram] = create_sift_features(img, clusterSize, colour, stepSize)
%Calclaute sift features and make histogram for a single image
    vocab = load('vocab.mat');
    vocab = vocab.vocab;
    img = im2single(img);
    %create hsitogram
    histogram = zeros(clusterSize, 1);
    %if colour = 1 then use colour channels when calculating the sift
    %features
    if colour == 1
        %noramlise each colour channel
        [R, G, B] = colour_normalization(img); 
        colour_channels = {R,G,B}; 
        total_d = []; 
        %get sift features of each colour channel
        for j =1:size(colour_channels, 2)
            %get sift features for current colour channel
            %and put them in total_d
            [f, d] = vl_dsift(single(colour_channels{j}), 'fast', 'step', stepSize); 
            d = single(d);
            total_d = [total_d; d]; 
        end
    %else use grey images
    else 
        %convert image to grey
        img = rgb2gray(img);
        %calculate the sift features
        [f, total_d] = vl_dsift(img, 'fast', 'step', stepSize);
        total_d = single(total_d);
    end
        %calculate distances between each feature with each cluster
        distances = vl_alldist2(vocab, total_d);
        for j=1:size(distances, 2)
           %get the cluster thats closest to each feature and then
           %incrememnt that bin in the histogram
           [M, I] = min(distances(:,j));
           histogram(I) = histogram(I) + 1;    
        end
        %normalise the histogram
        histogram = normc(histogram); 

end

