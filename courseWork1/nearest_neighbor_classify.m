function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats, K)
	%number of neighbours
    K = 7;
    %this vector contains the distances from each training example for a
    %test image
	closestNeighbours = zeros(size(train_image_feats,1), 1);
    %the K closest classes for to a test image 
    topK = {};
    %the final predicted categories for each test image
    predicted_categories = {};
    %loop through each test image and predict class for test image
    for h = 1: size(test_image_feats, 1)
        %calculate ed
        % with ed, mankowski and cityblock
        closestNeighbours = pdist2(test_image_feats(h,:),train_image_feats, 'cityblock');
        
        %%%OTHER DISTANCE METHODS%%%
        
        %histogram intersection
         %for i = 1 : size(train_image_feats, 1)
             %closestNeighbours(i,:) = sum(min(test_image_feats(h,:), train_image_feats(i,:)));
         %end
         %closestNeighbours = closestNeighbours./sum(train_image_feats, 2);
         
        %L1-norm
        %for i = 1 : size(train_image_feats, 1)
            %closestNeighbours(i) = sum(abs((test_image_feats(h,:)-train_image_feats(i,:))));
        %end
        
        %L2-norm
        %for i = 1 : size(train_image_feats, 1)
            %closestNeighbours(i) = sum((test_image_feats(h,:)-train_image_feats(i,:)).^2);
        %end
        
        %%%END OF OTHER DISTANCE METHODS%%%
        
        %sort closestNeighbours and put the new order in sortedEDs and the
        %original indices in indeces
        [sortedEDs indeces] = sort(closestNeighbours, 'ascend');
        
        for k=1:K
             class = train_labels{indeces(k)};
             topK{k} = class;
        end
        %get most common/mode class in topK
		[classes, ~, map] = unique(topK);
		classifiedAs = classes(mode(map));
        predicted_categories(h) = classifiedAs;
    end
    %transpose predicted categories so its correct for coursework_starter.m
    predicted_categories = transpose(predicted_categories);
end