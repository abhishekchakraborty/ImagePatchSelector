function imgHandle = plotImgBlocks( img, displayBlockList, blockSize )

% Get Image Blocks
imgSize = size( img );
numBlocks = ceil( imgSize(1:2) ./ blockSize );

% Get region boundary X and Y sequences
blockX = blockSize(1)*[ 1 : numBlocks(1) ];
blockY = blockSize(2)*[ 1 : numBlocks(2) ];

% Mark given blocks
markedImg = img;
for i = 1 : size( displayBlockList, 1 )
    fprintf( 'Block (%d,%d) being marked...\n', displayBlockList(i,2), displayBlockList(i,1) );
    block1Indices = [ (displayBlockList(i,1)-1)*blockSize(1) + 1 : min( displayBlockList(i,1)*blockSize(1), imgSize(1) ) ];
    block2Indices = [ (displayBlockList(i,2)-1)*blockSize(2) + 1 : min( displayBlockList(i,2)*blockSize(2), imgSize(2) ) ];
    blockMat = img( block1Indices, block2Indices, : );
    
    % % Convert Color to Gray
    % modifiedBlockMat = rgb2gray( blockMat );
    % modifiedBlockMat = repmat( modifiedBlockMat, [ 1 1 size(img,3) ] );
    % 
    % % Keep only Blue component
    % modifiedBlockMat = zeros( size( blockMat ) );
    % modifiedBlockMat(:,:,3) = blockMat(:,:,3);
    
    % Add an offset
    additiveOffset = 70;
    modifiedBlockMat = blockMat + additiveOffset;
    modifiedBlockMat = min( modifiedBlockMat, 255 );
    
    markedImg( block1Indices, block2Indices, : ) = modifiedBlockMat;
end;

imgHandle = imshow( markedImg );
hold on;

% Draw boundaries
for j = blockX
    plot( [ 1 size(img,2) ],[ j j ],'w-');    
end;

for i = blockY
    plot( [ i i ],[ 1 size(img,1) ],'w-');
end;
    
hold off;
