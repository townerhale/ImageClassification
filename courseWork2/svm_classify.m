% Based on James Hays, Brown University

%This function will train a linear SVM for every category (i.e. one vs all)
%and then use the learned linear classifiers to predict the category of
%every test image. Every test feature will be evaluated with all 15 SVMs
%and the most confident SVM will "win". Confidence, or distance from the
%margin, is W*X + B where '*' is the inner product or dot product and W and
%B are the learned hyperplane parameters.

function predicted_categories = svm_classify(train_image_feats, train_labels, test_image_feats)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

%{
Useful functions:
 matching_indices = strcmp(string, cell_array_of_strings)
 
  This can tell you which indices in train_labels match a particular
  category. This is useful for creating the binary labels for each SVM
  training task.

[W B] = vl_svmtrain(features, labels, LAMBDA)
  http://www.vlfeat.org/matlab/vl_svmtrain.html

  This function trains linear svms based on training examples, binary
  labels (-1 or 1), and LAMBDA which regularizes the linear classifier
  by encouraging W to be of small magnitude. LAMBDA is a very important
  parameter! You might need to experiment with a wide range of values for
  LAMBDA, e.g. 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10.

  Matlab has a built in SVM, see 'help svmtrain', which is more general,
  but it obfuscates the learned SVM parameters in the case of the linear
  model. This makes it hard to compute "confidences" which are needed for
  one-vs-all classification.

%}

%unique() is used to get the category list from the observed training
%category list. 'categories' will not be in the same order as in coursework_starter,
%because unique() sorts them. This shouldn't really matter, though.
    categories = unique(train_labels); 
    num_categories = length(categories);


    
    predicted_categories = cell(size(test_image_feats,1), 1);
    LAMBDA = 0.0001;
    %get indices for the binary  labels
    binary_labels = zeros(num_categories, size(train_labels,1)); 
    indices = zeros(num_categories, size(train_labels, 1));
    for i=1:num_categories
         h = strcmp(categories(i), train_labels);
         binary_labels(i,:) = transpose(strcmp(categories(i), train_labels));
    end
    
    binary_labels(binary_labels==0) = -1;
    
    
    %train each svm
    confidences = zeros(num_categories, size(test_image_feats, 1));
    for i=1:num_categories
        %put the W and B values in svm_values
        labels = transpose(binary_labels(i,:));
        [W B] = vl_svmtrain(transpose(train_image_feats), labels, LAMBDA);
        %get confidence
        for j=1:size(test_image_feats, 1)
            %store each svms confidence in confidences
            %get confidence of each classifier
            confidence = W'*transpose(test_image_feats(j,:))+B;
            confidences(i,j) = confidence;
        end
    end
    
    %get the best confidences
    for i=1:size(confidences,2)
       [M, I] = max(confidences(:,i));
        classifiedAs = categories(I);
        predicted_categories(i) = classifiedAs; 
    end
    
%end of function    
end

