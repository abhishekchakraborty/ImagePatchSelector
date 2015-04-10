function [ gridPatchList, imgH ] = selectRegionForPatches( imgName, patchSize )

img = imread( imgName );

% Display
imgH = plotImgBlocks( img, [], patchSize );

% Mark Region
roiH = imfreehand;
positionList = getPosition( roiH );
delete( roiH );
polyH = impoly(gca, positionList);
setVerticesDraggable( polyH, logical(0) );
polyF = makeConstrainToRectFcn('impoly',[ min(positionList(:,1)) max(positionList(:,1)) ],[ min(positionList(:,2)) max(positionList(:,2)) ]);
setPositionConstraintFcn( polyH, polyF );
% disp( positionList );

positionList = fliplr( positionList ); % (x,y) -> (rows,cols)

% Get Grid of selected patches

% Get Boundary
gridBoundary = ceil( positionList ./ ( ones( size( positionList, 1 ), 1 ) * patchSize ) );
gridBoundary = unique( gridBoundary, 'rows' );
fprintf( 'Co-ordinates of grid cells on boundary:\n' );
disp( gridBoundary );

% Get Bounding Box
gridMin = min( gridBoundary );
gridMax = max( gridBoundary );
[gridBox1, gridBox2] = ndgrid( [ gridMin(1) : gridMax(1) ], [ gridMin(2) : gridMax(2) ] );
gridBox = [ gridBox1(:), gridBox2(:) ];

% Get Internal Grid Points
[ in, on ] = inpolygon( gridBox(:,2), gridBox(:,1), gridBoundary(:,2), gridBoundary(:,1) );
gridPatchList = gridBox( in == 1, : );

end