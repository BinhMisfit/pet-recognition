function [dcData,imgData] = dc_wavelet(dc_folder_path)
    allFiles=dir(dc_folder_path);
    allNames = {allFiles.name};
    nw=32*32; % wavelet resolution
    index=1;
    for i = 1:length(allNames)
        filename=fullfile(allNames{i});
        if (strcmp(filename,'.')==0) && (strcmp(filename,'..')==0) && (strcmp(filename,'.DS_Store')==0)
            filename=fullfile(dc_folder_path,filename);
            display(filename)
            I=imread(filename);
            J=imresize(I,[64,64]);
            J=rgb2gray(J); % should use the gray image for this example.
            [~,cH,cV,~] = dwt2(J,'Haar');
            nbcol = size(colormap(gray),1);
            cod_cH1 = wcodemat(cH,nbcol);
            cod_cV1 = wcodemat(cV,nbcol);
            cod_edge=cod_cH1+cod_cV1;
            dcData(:,index)=reshape(cod_edge,nw,1);
            imgData{index}=J;
            index=index+1;
        end
    end
end