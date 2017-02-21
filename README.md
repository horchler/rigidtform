rigidtform
========
#####Optimal rotation and translation between corresponding points.#####
######Version 1.0, 2-17-17######
#####Download Repository: [ZIP Archive](https://github.com/horchler/rigidtform/archive/master.zip)#####

--------

The [```RIGIDTFORM```](https://github.com/horchler/rigidtform/blob/master/rigidtform.m) function efficiently solves for the optimal rotation and translation between two sets of corresponding points in N dimensions. The solution minimizes the root mean squared deviation between the two sets of points. This is a generalization to N dimensions of the [Kabsch algorithm](https://en.wikipedia.org/wiki/Kabsch_algorithm) using singular value decomposition. The technique is described for three dimensions [here](http://nghiaho.com/?page_id=671).
  
```[R,T] = RIGIDTFORM(P1,P2)``` returns the rotation matrix, ```R```, and translation vector, ```T```, for the optimal rigid transform between two sets of corresponding N-dimensional points, ```P1``` and ```P2```. Each row of the equal-sized, real-valued floating point matrices ```P1``` and ```P2``` represents the N-dimensional coordinates of a point. The outputs, ```R``` and ```T```, are N-by-N and 1-by-N arrays, respectively. The transform can be applied as ```P1(i,:)*R+T``` to rotate and translate ```P1``` to ```P2``` or as ```(P2(i,:)-T)*R'``` to go from ```P2``` to ```P1```.
  
```[...] = RIGIDTFORM(P1,P2,DIM)``` optionally specifies which dimension the points are stored in of the two datasets, ```P1``` and ```P2```. The default is 1, i.e., each row represents the coordinates of a point. If ```DIM``` is 2, each column represents the coordinates of a point and the outputs ```R``` and ```T``` are transposed such that the transform can be applied as ```R*P1(:,i)+T``` to rotate and translate ```P1``` to ```P2```.
  
```[R,T,ERR] = RIGIDTFORM(...)``` returns the root mean squared error between each corresponding point in the datasets ```P1``` and ```P2``` as a column vector. If ```DIM``` is 2, ```ERR``` is transposed.
&nbsp;  

--------

Andrew D. Horchler, *horchler @ gmail . com*, [biorobots.case.edu](http://biorobots.case.edu/)  
Created: 12-8-16, Revision: 1.0, 2-17-17  

This version tested with Matlab 9.1.0.441655 (R2016b)  
Mac OS X 10.12.3 (Build: 16D32), Java 1.7.0_75-b13  
Compatibility maintained back through Matlab 8.3 (R2014a)  
&nbsp;  

--------

Copyright &copy; 2016&ndash;2017, Andrew D. Horchler  
All rights reserved.  

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of Case Western Reserve University nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ANDREW D. HORCHLER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.