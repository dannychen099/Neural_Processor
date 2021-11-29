# ETRI eyeriss_v1 reference code


## MATLAB Model with RS Dataflow
The expected ofmap with a 5x5x2 ifmap and 3x3x2 filter is a 3x3x2 ofmap. Using the following example, the expected calculation is:
```Matlab
>> ifmap1 = [0 1 2 3 4; 1 2 3 4 5; 2 3 4 5 6; 3 4 5 6 7; 4 5 6 7 8];
>> ifmap2 = ifmap1 + 1

ifmap2 =

1     2     3     4     5
2     3     4     5     6
3     4     5     6     7
4     5     6     7     8
5     6     7     8     9

>> ofmap1 = imfilter(ifmap1, filter1) + imfilter(ifmap2, filter1);
>> ofmap2 = imfilter(ifmap1, filter2) + imfilter(ifmap2, filter2);
>> ofmap1(2:end-1, 2:end-1)     % Display the valid convolution data

ans =

114   150   186
150   186   222
186   222   258

>> ofmap2(2:end-1, 2:end-1)     % Display the valid convolution data

ans =

159   213   267
213   267   321
267   321   375
```

## C++ Model with the RS Dataflow
The MATLAB model can also be implemented in C++, and the same results are obtained.
