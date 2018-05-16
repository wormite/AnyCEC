%AnyCEC
clear;
clf;
%delete('CEC.xls','Absorber.xls','sampledData.xls');

prompt = 'What is the accuracy you want? (0-100) per cent';
def = {'40'};
dlg_title = 'Input';
num_lines = 1;
accuracy = inputdlg(prompt,dlg_title,num_lines,def);
accuracy = str2double(accuracy(1));
best = 0.00001;%100
worst = 0.7;%0
% expression:a*log(x)+b = accuracy;
a = 100/(log(best)-log(worst));
b = 100-a*log(best);
global g_minStepRatio;
g_minStepRatio = exp((accuracy-b)/a)*10;
global g_absoberShapes;
g_absoberShapes = {'Pentagon','MiniChannel','SimpleCircle','CircleWithGapConsideration','58mm absorber icecream cone design','85mm absorber icecream cone design','hand drawn 1','hand drawn 2','Octagon','random points','changed shape','square','flat','improvedPentagon', 'oval shape','v groove','pentagon 120'};
global g_absorber;
g_absorber = [];

% shapeName = questdlg('Choose absorber',...
%     'What is the absorber shape?,Excel files should be closed!',...
%     'MiniChannel','Pentagon','Pentagon');
% %'Circle','SimpleCircle','CircleWithGapConsideration'
[shapeNumber,v]=listdlg('PromptString','What is the shape?',...
    'SelectionMode','single',...
    'ListString',g_absoberShapes);
if(v==1)
    Absorber(shapeNumber);
else
    return;
end;

%% calc the absorber area(length)
absLength = 0;
for i = 2:size(g_absorber,2);
    absLength = absLength+norm(g_absorber(:,i)-g_absorber(:,i-1));
end;
g_absorber = g_absorber';
% %if it's closed loop, allow to choose the starting point;(rotate the absorber)
% if (norm(g_absorber(end,:)-g_absorber(1,:))<absLength/1000000)
%     start_index = 180;
%     if start_index ==1;
%         l_absorber = g_absorber;
%     else
%         l_absorber = [g_absorber(start_index:end,:);g_absorber(2:start_index,:)];
%     end
% else
%     l_absorber=g_absorber;
% end
figure(1);
%plot(l_absorber(:,1),l_absorber(:,2));
axis equal;
hold on;

%left part
parabolaEdgeX = 2500;
%parabolaEdgeY = 600;
panDistance = 15;
%parabolaDepth = 1250;
parabolaDepth = 900;
f = parabolaDepth;
parabolaEdgeY = parabolaEdgeX^2/(-4*f)+f;
x = -parabolaEdgeX:1:parabolaEdgeX;
%f = fzero(@(f) parabolaEdgeX^2/(-4*f)+f-parabolaEdgeY,parabolaDepth);
y = x.^2/(-4*f)+f;
%plot(x,y,'b-');
source_left = [-parabolaEdgeX,parabolaEdgeY];
source_right = [-60,parabolaDepth];
centerPan = [-panDistance,0];
%absorber = l_absorber+repmat(centerPan,size(l_absorber,1),1);
absorber = g_absorber;
plot(absorber(:,1),absorber(:,2));
AsymCEC(source_left,source_right,absorber);
%break;

% %right part
% source_left = [60,parabolaDepth];
% source_right = [parabolaEdgeX,parabolaEdgeY];
% start_index = size(g_absorber,1)+1-start_index;
% if start_index ==1;
%     l_absorber = g_absorber;
% else
%     l_absorber = [g_absorber(start_index:end,:);g_absorber(2:start_index,:)];
% end
% centerPan = [panDistance,-0];
% absorber = l_absorber+repmat(centerPan,size(l_absorber,1),1);
% plot(absorber(:,1),absorber(:,2));
% %absorber = flipud(absorber);
% AsymCEC(source_left,source_right,absorber);