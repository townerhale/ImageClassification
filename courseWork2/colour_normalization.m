function [R, G, B] = colour_normalization(img)
%COLOUR_NORMALIZATION Summary of this function goes here
%   Detailed explanation goes here
img = single(img);
R = img(:,:,1); 
G = img(:,:,2); 
B = img(:,:,3); 

R = (R - mean(R(:)))./ std(R(:));
G = (G - mean(G(:)))./ std(G(:));
B = (B - mean(B(:)))./ std(B(:));
end

