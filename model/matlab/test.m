% The important files are test.m and PE_Unit.m.

% params.mat includes pre-trained weights for an LeNet-5 model trained on
% MNIST data. Eventually, I'll expand this code to use that model.

% This code models one layer of convolution. It currently only supports one
% filter convolved with one input feature map. The PE grid as assumed to
% fit the convolution, but we'll need to split up computation in order to
% fit a 10x10 physical PE grid.

% Running this code outputs two (large) matrices. The first is the expected
% output after 2D convolution, using the built-in MATLAB imfilter as a
% reference. The second matrix is (nearly) the same result using a PE grid.
% There is a small error, on the order of 1e-14, which I guess is from
% floating-point errors.

% The general idea is this (for 3x3 filter, 5x5 ifmap, 3x3 ofmap):
%   time1:  filter row1 * ifmap row1 = [psum1, psum2, psum3]
%   time2:  filter row2 * ifmap row2 = [psum4, psum5, psum6]
%   time3:  filter row3 * ifmap row3 = [psum7, psum8, psum9]
%           <accumulate psums downwards>
%           ofmap(1,1) = psum7 + psum4 + psum1
%           ofmap(1,2) = psum8 + psum5 + psum2
%           ofmap(1,3) = psum9 + psum6 + psum3
%   ofmap = [ofmap(1,1) ofmap(1,2) ofmap(1,3)
%                 0          0           0         
%                 0          0           0   ]      
%
%   time4:  filter row1 * ifmap row2 = [psum1, psum2, psum3]
%   time5:  filter row2 * ifmap row3 = [psum4, psum5, psum6]
%   time6:  filter row3 * ifmap row4 = [psum7, psum8, psum9]
%           <accumulate psums downwards>
%           ofmap(2,1) = psum7 + psum4 + psum1
%           ofmap(2,2) = psum8 + psum5 + psum2
%           ofmap(2,3) = psum9 + psum6 + psum3
%   ofmap = [ofmap(1,1) ofmap(1,2) ofmap(1,3)
%            ofmap(2,1) ofmap(2,2) ofmap(2,3)   
%                 0          0           0   ]
% ...and so on. This repeats for the height of the output feature map.

%% Set up environment and PE array
clear; clc;
H = 32;  % Input Feature Map (ifmap) Height
W = 32;  % Input Feature Map (ifmap) Width

R = 5;  % Filter Height
S = 5;  % Filter Width

U = 1;  % Convolution Stride

E = (H - R + U)/U;  % Output Feature Map (ofmap) Height
F = (W - S + U)/U;  % Output Feature Map (ofmap) Width

% Dimensions of PE array
arrayRows = 10;
arrayColumns = 10;

% Create dummy data for testing
filterArray = rand(R,S);
ifmapArray = rand(H,W);
ofmapArray = zeros(E,F);


% TODO: wrap ifmap to fit size of PE array

%% Calculate what we should get after 2D convolution. This is our baseline.
expectedOutput = imfilter(ifmapArray, filterArray);
paddingSize = (R-1)/2;
expectedOutput = expectedOutput(1+paddingSize:end-paddingSize, 1+paddingSize:end-paddingSize)    % Remove invalid outer data (we have no buffer in our raw calculation)

%% Create the PE array using objects
for i = 1:arrayRows
    for j = 1:arrayColumns
        PE(i,j) = PE_Unit();
    end
end

%% Calculate each row of output feature map pixels. 
for ofmapRow = 1:height(ofmapArray)
    for filterRow = 1:width(filterArray)

        % Load a Row-Stationary (RS) primitive. This is one row from the
        % filter, and one row of the input feature map.
        RSloadRow(PE, filterArray(filterRow,:), ifmapArray(filterRow+ofmapRow-1,:), width(ofmapArray));
        
        % Calculate the result from the RS primitive. This performs a MAC
        % operation on every PE in the array.
        for i = 1:arrayRows
            for j = 1:arrayColumns
                result = PE(i,j).MAC();
        
                % Put the resulting partial sum (psum) into the add buffer. It will
                % be accumulated on the next cycle.
                PE(i,j).addBuffer = result;
            end
        end
    end
    
    % After calculating a set of RS primitives, add up the psums to produce
    % a row of output feature map pixels.
    for col = 1:width(ofmapArray)
        % NOTE: this uses sum() instead of the PE array to do the
        % computation. I will try to rework this to use the PE array with
        % as few clock cycles as possible. One potential option would be to
        % modify the PE to include a mux, so that we can do either a MAC or
        % an ADD operation. If ADD is selected, we can accumulate psums
        % vertically.
        ofmapArray(ofmapRow, col) = sum([PE(1:width(filterArray),col).output]);
    end
    
    % Zero out add buffer for the next cycle. The psums between ofmap
    % pixels are not needed.
    for i = 1:arrayRows
        for j = 1:arrayColumns
            PE(i,j).addBuffer = 0;
        end
    end
end

% Display the output feature map after processing.
ofmapArray


% Function to load an RS primitive.
function RSloadRow(PEarray, filterRowData, ifmapRowData, ofmapWidth)
    % Load PE array with filter weights. Rows of weights are reused across
    % PEs horizontally:
    % PE grid:  w1  w1  w1
    %           w2  w2  w2
    %           w3  w3  w3
    for filterIndex = 1:length(filterRowData)
        % Take a row of PEs that will be used, and assign them the same
        % filter weight value
        [PEarray(filterIndex,1:ofmapWidth).filterCoefficient] = deal(filterRowData(filterIndex));
    end

    % Load PE array with ifmap values. Rows of ifmap values are reused
    % across PEs diagonally:
    % PE grid:  ifmap1  ifmap2  ifmap3
    %           ifmap2  ifmap3  ifmap4
    %           ifmap3  ifmap4  ifmap5
    % Diagonally shift each column over each row.
    diagonalShift = 0;
    for i = 1:length(filterRowData)
        col = 1;
        for j = 1:ofmapWidth
            PEarray(i,j).inputFeature = ifmapRowData(col+diagonalShift);
            col = col + 1;
        end
        diagonalShift = diagonalShift + 1;
    end
end