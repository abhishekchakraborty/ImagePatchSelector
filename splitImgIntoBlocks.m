function imgBlocks = splitImgIntoBlocks( img, blockSize )

% Get Image Blocks
imgSize = size( img );
numBlocks = ceil( imgSize(1:2)./blockSize );
imgBlocks = cell( numBlocks );

for i = 1 : numBlocks(1)
    for j = 1 : numBlocks(2)
        % Row Size
        if ( i*blockSize(1) > imgSize(1) )
            rows = [ (i-1)*blockSize(1) + 1 : imgSize(1) ];
        else
            rows = [ (i-1)*blockSize(1) + 1 : i*blockSize(1) ];
        end;
        % Column Size
        if ( j*blockSize(2) > imgSize(2) )
            cols = [ (j-1)*blockSize(2) + 1 : imgSize(2) ];
        else
            cols = [ (j-1)*blockSize(2) + 1 : j*blockSize(2) ];
        end;
        imgBlocks{i,j} = img( rows, cols, : );       
    end;
end;

% display blocks
% figure;
% for i = 1 : numBlocks(1)
%     for j = 1 : numBlocks(2)
%         subplot( numBlocks(1), numBlocks(2), (i-1)*numBlocks(2) + j ), imshow( imgBlocks{i,j}, 'InitialMag', 100, 'Border','tight' );
%     end;
% end;

size( imgBlocks );
