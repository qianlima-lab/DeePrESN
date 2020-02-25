function [ mappedX ] = out_of_sample_elmae( stateMatrix, mapping )

mappedX = mapping.R * stateMatrix';
mappedX = mappedX';

