function [R,t,err] = rigidtform(P1,P2,dim)
%RIGIDTFORM  Optimal rotation and translation between corresponding points
%   
%   [R,T] = RIGIDTFORM(P1,P2) returns the rotation matrix, R, and
%   translation vector, T, for the optimal rigid transform between two sets
%   of corresponding N-dimensional points, P1 and P2. Each row of the
%   equal-sized, real-valued floating point matrices P1 and P2 represents
%   the N-dimensional coordinates of a point. The outputs, R and T, are
%   N-by-N and 1-by-N arrays, respectively. The transform can be applied as
%   P1(i,:)*R+T to rotate and translate P1 to P2 or as (P2(i,:)-T)*R' to go
%   from P2 to P1.
%   
%   [...] = RIGIDTFORM(P1,P2,DIM) optionally specifies which dimension the
%   points are stored in of the two datasets, P1 and P2. The default is 1,
%   i.e., each row represents the coordinates of a point. If DIM is 2, each
%   column represents the coordinates of a point and the outputs R and T
%   are transposed such that the transform can be applied as R*P1(:,i)+T to
%   rotate and translate P1 to P2.
%   
%   [R,T,ERR] = RIGIDTFORM(...) returns the root mean squared error between
%   each corresponding point in the datasets P1 and P2 as a column vector.
%   If DIM is 2, ERR is transposed.
%   
%   Example:
%       m = 3; n = 50; R_orig = orth(rand(m)); t_orig = rand(1,m);
%       P1 = rand(n,m); P2 = P1*R_orig+repmat(t_orig,n,1);
%       [R,t,err] = rigidtform(P1,P2); P3 = P1*R+repmat(t,n,1);
%       figure;
%       plot3(P1(:,1),P1(:,2),P1(:,3),'ro',...
%             P2(:,1),P2(:,2),P2(:,3),'bo',...
%             P3(:,1),P3(:,2),P3(:,3),'k.');
%       axis equal; grid on; title(['Maximum error: ' num2str(max(err))]);
%       legend('P1','P2','P1 Transformed');
%   
%   See also: SVD, IMREGTFORM, AFFINE2D, AFFINE3D

%   An N-dimensional implementation of the "Kabsch algorithm":
%   
%   [1] Wolfgang Kabsch (1976) "A solution for the best rotation to relate
%   two sets of vectors", Acta Crystallographica 32:922.
%   http://dx.doi.org/10.1107/S0567739476001873
%   
%   [2] Wolfgang Kabsch (1978) "A discussion of the solution for the best
%   rotation to relate two sets of vectors", Acta Crystallographica 34:827.
%   http://dx.doi.org/doi:10.1107/S0567739478001680

%   Andrew D. Horchler, horchler @ gmail . com, Created 12-8-16
%   Revision: 1.0, 2-20-17


% Check input points
if ~ismatrix(P1) || ~isfloat(P1) || ~isreal(P1) || ~all(isfinite(P1(:)))
    error('rigidtform:InvalidDataset1',...
          'First dataset must be a finite real floating point matrix.');
end
if ~ismatrix(P2) || ~isfloat(P2) || ~isreal(P2) || ~all(isfinite(P2(:)))
    error('rigidtform:InvalidDataset2',...
          'Second dataset must be a finite real floating point matrix.');
end

% Check that there are sufficient and equal number of input points
s = size(P1);
if ~isequal(s,size(P2))
    error('rigidtform:SizeMismatch',...
          'Size of input datasets must be equal.');
end

% Check dimension, transpose inputs if needed
if nargin < 3
    dim = 1;
else
    if ~isscalar(dim)
        error('rigidtform:NonscalarDimension',...
              'Dimension must be a scalar.');
    end
    if dim ~= 1 && dim ~= 2
        error('rigidtform:InvalidDimension','Dimension must be 1 or 2.');
    end
    if dim == 2
        P1 = P1';
        P2 = P2';
        s = s([2 1]);
    end
end

if s(2) > s(1) && s(2) > 2^15
    warning('rigidtform:LargeDimension',...
           ['Number of dimensions (%d) is very large. Datasets may be '...
            'transposed.'], s(2));
end

% Calculate centroids
c1 = mean(P1,1);
c2 = mean(P2,1);

% Center data, calculate H matrix, and return unitary matrices
[U,~,V] = svd(bsxfun(@minus,P1,c1)'*bsxfun(@minus,P2,c2));

% Calculate optimal rotation matrix
R = U*V';

% Correct R if needed to ensure right-handed coordinate system
if s(2) == 3 && det(R) < 0
    V(:,end) = -V(:,end);
    R = U*V';
end

% Calculate optimal translation vector
t = c2-c1*R;

% Calculate root mean squared distance error for each point, if requested
if nargout > 2
    d = P2-(P1*R+t);
    err = sqrt(sum(d.^2,2));
    
    % Check for and handle overflow
    idx = isinf(err);
    if any(idx)
        f = d(idx,1);
        for i = 2:s(2)
            f = hypot(f,d(idx,i));
        end
        err(idx) = f;
    end
end

% Return transposed outputs if needed
if dim == 2
    R = R';
    t = t';
    if nargout > 2
        err = err';
    end
end