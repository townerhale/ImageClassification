function [train_image_feats test_image_feats] = cnn_feature_extraction()
    %load in the alexnet cnn_featue
    net = alexnet;
    %load the images
    imdsTrain = imageDatastore('../data/train', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
    imdsTest = imageDatastore('../data/test', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
    %resize the images
    inputSize = [227 227];
    imdsTrain.ReadFcn = @(loc)imresize(imread(loc),inputSize);
    inputSize = [227 227];
    imdsTest.ReadFcn = @(loc)imresize(imread(loc),inputSize);
    
    %the layer the features will be extracted from 
    layer = 'conv3';
    
    %extract training features
    train_image_feats = activations(net,imdsTrain,layer,'OutputAs','rows','ExecutionEnvironment','cpu');
    
    %extract  test features 
    test_image_feats = activations(net,imdsTest,layer,'OutputAs','rows','ExecutionEnvironment','cpu');


end