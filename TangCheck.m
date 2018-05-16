%%tangent checking function.
% P is the point to find the tangent from
% curr is the curr tagent(estimated)
% shape is the aborber shape. Can be the whole shape or part of it.
% using counterClockWise as the default.(right hand rule).
% !! the P curr line should not cross the absorber shape otherwise it will
% result in a 90 degrees minimum instead of tangent line.
% flag 
function [tangPoint, tangIndex, flag]=TangCheck(P,curr,shape,counterClockWise)
if ~exist('P', 'var')
    P = [0,0];
end
if ~exist('curr', 'var')
    curr =[1,0];
end
if ~exist('shape', 'var')
    shape =[1,1;1,7;1,7;1,4];
end
if ~exist('counterClockWise', 'var')
    counterClockWise = 1;
end
% check if curr is on shape.
% t = find(shape-repmat(curr,size(shape,1),1)==0);
% if isempty(t)
%     display('error, curr is not part of shape');
% end
if(P==curr)
%     tangPoint = shape(t+1,:);
%     tangIndex = t+1;
%     flag = 0;
%     exit;
    display('error, P and Curr at the same place')
end
P_curr = curr-P;
P_shape = shape-[P(1)*ones(size(shape,1),1),P(2)*ones(size(shape,1),1)];
P_currUnit = P_curr/norm(P_curr);
res = zeros(size(P_shape,1),1);
parfor i = 1:size(P_shape,1);
    P_shapeUnit = P_shape(i,:)/norm(P_shape(i,:));
    res(i) = CrossProduct(P_currUnit,P_shapeUnit);
end

[M,I]=max(res*-counterClockWise);
tangPoint = shape(I,:);
tangIndex = I;
flag = 1;
end 


