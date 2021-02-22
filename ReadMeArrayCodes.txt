
This file includes the implementation of the binary measurement matrices constructed based on parity check matrices of Array codes.
This construction receives two inputs , 'n' , 'j' which show the dimensionality of the unknown vector 'x' (or the number of the columns in the measurement matrix) and the column-weight respectively and outputs a binary matrix of jq*q^2 dimensions.
This matrix is proved to have girth equal to 6. 

In our paper [1], we have proved that binary matrices with fixed column-weight are able to satisfy Robust Null-Space Property (RNSP) and achieve robust sparse recovery. We have also proved that in order to get the highest compression rate in any compressive sensing problem (using RNSP as the recovery guarantee), matrices with girth 6 are enough!

-If you use this code in your research please support us by citing our paper in [1].

[1] Compressed Sensing Using Binary Matrices of Nearly Optimal Dimensions, Mahsa Lotfi and Mathukumalli Vidyasagar, arXiv: 1808.03001\
