function [ mappedX, mapping ] = compute_mapping_elmae( stateMatrix, dim )

% [mappedX, R ]= sparse_elmae( stateMatrix', dim );

[mappedX, R ]= elmae( stateMatrix', dim );
mappedX = mappedX';
mapping.R = R;
