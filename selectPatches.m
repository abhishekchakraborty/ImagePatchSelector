function selectPatches( imgName, patchSize )

img = imread( imgName );

% Get Image Blocks
imgSize = size( img );
numBlocks = ceil( imgSize(1:2) ./ patchSize );

% Select Region for Patches
[ gridPatchList, imgH ] = selectRegionForPatches( imgName, patchSize );

% Get Patches
imgBlocks = splitImgIntoBlocks( img, patchSize );

% Mark Patches
imgH = plotImgBlocks( img, gridPatchList, patchSize );
set( imgH, 'ButtonDownFcn', @imageClickCallback ); % Edit Patches

dirName = regexprep( imgName, '.[0-9a-zA-Z]+$', '' );


% Click Callback
function imageClickCallback( objectHandle, eventData )
    axesHandle  = get(objectHandle,'Parent');
    buttonType = get(gcf,'SelectionType');
    coordinates = get(axesHandle,'CurrentPoint');
    coordinates = coordinates(1,1:2);
    coordinates = fliplr( coordinates ); % (x,y) -> (rows,cols)
    gridNum = ceil( coordinates ./ patchSize );
    
    message = '';
    switch buttonType
        case 'normal'
            message = sprintf( 'Block (%d,%d) selected... \n', gridNum(1), gridNum(2) );
            
            % include patch
            gridPatchList = [ gridPatchList ; gridNum(1), gridNum(2) ];
            gridPatchList = unique( gridPatchList, 'rows' );
            
            imgH = plotImgBlocks( img, gridPatchList, patchSize );
            set( imgH, 'ButtonDownFcn', @imageClickCallback );
            
        case 'alt'
            message = sprintf( 'Block (%d,%d) deselected... \n', gridNum(1), gridNum(2) );
            
            % remove patch
            gridPatchList( gridPatchList(:,1) == gridNum(1) & gridPatchList(:,2) == gridNum(2), : ) = [];
            
            imgH = plotImgBlocks( img, gridPatchList, patchSize );
            set( imgH, 'ButtonDownFcn', @imageClickCallback );
            
        case 'extend'
            message = sprintf( 'Save selected... \n' );
            
            % check if to be saved
            choice = questdlg( sprintf( 'Would you like to save the patches to a local directory named ''%s\'' ?', dirName ), 'Save', 'Cancel' );
            
            switch choice
                case 'Yes'
                    savePatches( imgName, imgBlocks, gridPatchList );
                case 'No'
                    message = strcat( message, sprintf( 'Save to ''%s'' cancelled... \n', dirName ) );
                otherwise
                    fprintf( message );
                    return
            end
            
        otherwise
            message = sprintf( 'Invalid selection made... \n' );
    end;
    
    fprintf( message );    
end

% Function to save patches
function savePatches( imgName, imgBlocks, patchList )
    mkdir( dirName );
    cd( dirName );
    
    % Save Image with Grid
    saveas( imgH, sprintf( '%s__%d_%d.jpg', dirName, patchSize(1), patchSize(2) ) );
    
    % Save patchList
    csvwrite( sprintf( '%s__%d_%d.csv', dirName, patchSize(1), patchSize(2) ), patchList );
    
    for i = 1 : size(patchList,1)
        blockName = sprintf( '%s__%d_%d.jpg', dirName, patchList(i,1), patchList(i,2) );
        imwrite( imgBlocks{patchList(i,1),patchList(i,2)}, blockName, 'jpg' );
    end;

    cd( '..' );
end

end