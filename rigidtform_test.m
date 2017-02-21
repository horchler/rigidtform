function maxerr = rigidtform_test
%RIGIDTFORM_TEST  

%   Andrew D. Horchler, horchler @ gmail . com, Created 2-15-17
%   Revision: 1.0, 2-17-17


m = randi([1 10]);  % Number of dimensions (integer > 0)
n = randi([1 1e2]); % Number of points (integer > 0)

R_orig = orth(randn(m));                % Random rotation matrix
t_orig = randn(1,m);                    % Random translation vector

P1 = rand(n,m);                         % Random point cloud
P2 = bsxfun(@plus,P1*R_orig,t_orig);    % Transform points

[R,t,err] = rigidtform(P1,P2(1:end,:)); % Find optimal transform
P3 = bsxfun(@plus,P1*R,t);              % Apply optimal transform to points
maxerr = max(err);                      % Maximum RMSE

% Plot points
figure;
if m == 1
    z = zeros(n,1);
    plot(1+z,P1(:,1),'ro',...
         2+z,P2(:,1),'bo',...
         2+z,P3(:,1),'k.');
elseif m == 2
    plot(P1(:,1),P1(:,2),'ro',...
         P2(:,1),P2(:,2),'bo',...
         P3(:,1),P3(:,2),'k.');
else
    plot3(P1(:,1),P1(:,2),P1(:,3),'ro',...
          P2(:,1),P2(:,2),P2(:,3),'bo',...
          P3(:,1),P3(:,2),P3(:,3),'k.');
end
axis equal;
grid on;
legend('P1','P2','P1 Transformed');
title([int2str(m) ' dimensions, ' int2str(n) ' points, Maximum RMSE: ' ...
       num2str(maxerr,6)]);