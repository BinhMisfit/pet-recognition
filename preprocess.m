function [new_image] = preprocess(image_path)
    old_image = imread(image_path);
    new_image = imresize(old_image,[64,64]);
end