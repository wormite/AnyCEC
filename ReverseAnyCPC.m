% reverse the CPC forming process and direct the light from the absorber.

%function result= ReverseAnyCPC()
clear;
clf;
delete('CPC.xls','Absorber.xls','sampledData.xls');
global g_unitLength;
g_unitLength = 6;

%% minimal step for the shape, the smaller the more accurate.
global g_minStep;
g_minStep = g_unitLength/1000;

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
g_minStepRatio = exp((accuracy-b)/a);
global g_absoberShapes;
g_absoberShapes = {'Pentagon','MiniChannel','SimpleCircle','CircleWithGapConsideration','58mm absorber icecream cone design','85mm absorber icecream cone design','hand drawn 1','hand drawn 2','Octagon','random points','changed shape','square','flat','improvedPentagon', 'oval shape','v groove','pentagon 120'};
global g_absorber;
g_absorber = [];
prompt = 'What is the half acceptance angle? (0-90) degrees';
def = {'45'};
dlg_title = 'Input';
num_lines = 1;
hAcceptance = inputdlg(prompt,dlg_title,num_lines,def);
hAcceptance = str2double(hAcceptance);
% hAcceptance
global g_acceptanceAngle;%change the number in degree
g_acceptanceAngle = hAcceptance/180*pi;
global g_barPos;%% bar position according to its crossing on X axis in ratio to the apperature
g_barPos=(1/2)*cot(g_acceptanceAngle);
global g_shapeData;
g_shapeData = [];
%% truncating according to the point counts,>0 <1
prompt = 'What is the truncation ratio according to ideal aperture? (0-100) per cent';
def = {'95'};
dlg_title = 'Input';
num_lines = 1;
trancation = inputdlg(prompt,dlg_title,num_lines,def);
trancation = str2double(trancation);

global g_truncatingPercentage;
g_truncatingPercentage=trancation/100;

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
figure(1);
plot(g_absorber(1,:),g_absorber(2,:));
axis equal;
hold on;
absorberExcelData = [];
for i = 1:size(g_absorber,2);
    pointStr = {sprintf('%.2fmm',g_absorber(1,i)), sprintf('%.2fmm',g_absorber(2,i)),'0mm'};
    absorberExcelData = [absorberExcelData;pointStr];
end;
%% calc the absorber area(length)
absLength = 0;
for i = 2:size(g_absorber,2);
    absLength = absLength+norm(g_absorber(:,i)-g_absorber(:,i-1));
end;

idealApertureLength = absLength/sin(g_acceptanceAngle);


i=1;
A = g_absorber(:,i);
B = g_absorber(:,i+1);
%C = g_absorber(:,i+2);
P = A;
g_shapeData = P;
%% stage = 0:involute;1:reflecting to particular angle;2:finish
stage = 0;
%wordCount = 1;
xlsData = [];
arcLength = 0;

while(stage < 2)
    A = g_absorber(:,i);
    B = g_absorber(:,i+1);
    % to avoid the case that the absorber is not closed, keep the C as it
    % is.
%     if(i+2<=size(g_absorber,2))
%         C = g_absorber(:,i+2);
%     end
    currP = P;    

    %% this only needs to be checked when the stage is still 0, i.e. barPoint needs to be checked for the current 
    %% P so that the program knows when to change to the second stange
    %% the sliding bar position:y=tan(g_acceptanceAngle)x+g_barOffset
    % bar perpendicular crossing point position
    if(stage == 0)
        tang=tan(g_acceptanceAngle);
        x_bar = (P(1)+tang*P(2)-tang*idealApertureLength*g_barPos)/(tang^2+1);
        y_bar = tang*x_bar+idealApertureLength*g_barPos;
        barPoint = [x_bar;y_bar];
    end;
    %writePos = sprintf('A%d',wordCount);
    pointStr = {sprintf('%.2fmm',P(1)), sprintf('%.2fmm',P(2)),'0mm'};
    xlsData = [xlsData;pointStr];
    %wordCount= wordCount+1;
    PB = B-P;
    PBar = barPoint-P;
    if(CrossProduct(PB,PBar)>=0)
        stage = 0;
    elseif(P(1)>1/2*idealApertureLength*g_truncatingPercentage && P(2)>=B(2))
        stage = 2;
    else
        stage = 1;
    end
    %currPoint = g_absorber(:,1);
    if(stage==0)
        %pause(0.02);
        %old
%             newY = currP(2)-(B(1)-currP(1))*g_minStepRatio;
%             newX = currP(1)+(B(2)-currP(2))*g_minStepRatio;
%             P = [newX;newY];
%           new method, N is the mid point
        N = [0 0];
        N(2) = (currP(1)-B(1)+g_minStepRatio*B(2)+1/g_minStepRatio*currP(2))/(1/g_minStepRatio+g_minStepRatio);
        N(1) = g_minStepRatio*(B(2)-N(2))+currP(1);
        P(1) = 2*N(1)-currP(1);
        P(2) = 2*N(2)-currP(2);        
        plotLine(P,B);
    elseif(stage==1)
        %pause(0.001);
%% having trouble with accuracy, replacing this part by trigonometry.
%         angle=(pi/2+g_acceptanceAngle+ArcTan(B-currP))/2-pi/2;
%         newX = cos(angle)*norm(B-P)*g_minStepRatio+ currP(1);
%         newY = sin(angle)*norm(B-P)*g_minStepRatio+ currP(2);
%         P = [newX;newY];
%%
        %using flow line, the direction should be (g_acceptanceAngle+pi/2)
        %+ angle of BP divided by 2
        sinBP = (P(2)-B(2))/norm(PB);
        cosBP = (P(1)-B(1))/norm(PB);
        tanDir = (sin(g_acceptanceAngle+pi/2)+sinBP)/(cos(g_acceptanceAngle+pi/2)+cosBP);
        cosDir = sqrt(1/(1+tanDir^2));
        sinDir = tanDir/sqrt(1+tanDir^2);
        newX = cosDir*norm(B-P)*g_minStepRatio+ currP(1);
        newY = sinDir*norm(B-P)*g_minStepRatio+ currP(2);
        P = [newX;newY];
        %% the sliding bar position:y=tan(g_acceptanceAngle)x+idealApertureLength*2
        % bar perpendicular crossing point position
        tang=tan(g_acceptanceAngle);
        x_bar = (P(1)+tang*P(2)-tang*idealApertureLength*g_barPos)/(tang^2+1);
        y_bar = tang*x_bar+idealApertureLength*g_barPos;
        barPoint = [x_bar;y_bar];
        % the current barPoint is associated with the last P, need to plot
        % it first.
        plotLine(P,barPoint);
        plotLine(P,B);

    else
        break;
    end;
    plotLine(currP,P);
    plotLine([-currP(1),currP(2)],[-P(1),P(2)]);
    arcLength = arcLength+norm(currP-P);
    g_shapeData = [g_shapeData,P];
    %% find next point
    %PA = A-P;
    if( i+2 <= size(g_absorber,2)) % the finding of the tangent line has to meet the condition of not running out of points, especially the open shape(non closed loop abosrber)
        B = g_absorber(:,i+1);
        PB = B-P;
        C = g_absorber(:,i+2);
        PC = C-P;
        while(CrossProduct(PC,PB)>0);% find the tangent line to be PB
            i=i+1;
            %A = g_absorber(:,i);
            B = g_absorber(:,i+1);
            
            % check if the absorber is closed, if it is not, the program can
            % run out of points on C. If it is so, C has to be kept as the last
            % point.
            if(i+2>size(g_absorber,2))
                %i = i-1;
                %PA = A-P;
                PB = B-P;
                PC = C-P;
                break;
            end
            C = g_absorber(:,i+2);
            %PA = A-P;
            PB = B-P;
            PC = C-P;
            %plotLine(A,P);
        end    
    end
end
%g_shapeData
xlswrite('CPC.xls',xlsData);
xlswrite('Absorber.xls',absorberExcelData);
arcLength = arcLength*2
arcToApertureRatio = arcLength/(idealApertureLength*g_truncatingPercentage)
concRatio = 1/sin(g_acceptanceAngle)*g_truncatingPercentage
hightToAperture = (max(g_shapeData(2,:))-min(g_shapeData(2,:)))/((idealApertureLength*g_truncatingPercentage))
apertureResult = (idealApertureLength*g_truncatingPercentage)
%hard Coded sampling process:
pointNumber = 300;
xlsSampled = [];

if size(g_shapeData,2)>pointNumber
    ratio = floor(size(g_shapeData,2)/pointNumber);
    sampledData = {sprintf('%.3fmm',g_shapeData(1,1)), sprintf('%.3fmm',g_shapeData(2,1)),'0mm'};
    lastPoint = g_shapeData(:,1);
    for i = 1:ratio:size(g_shapeData,2);
        if (norm(lastPoint-g_shapeData(:,i))>arcLength/pointNumber/8)
            lastPoint = g_shapeData(:,i);
            pointStr = {sprintf('%.3fmm',g_shapeData(1,i)), sprintf('%.3fmm',g_shapeData(2,i)),'0mm'};
            sampledData = [sampledData;pointStr];    
        end;
    end;   
    xlswrite('sampledData.xls',sampledData);
else
    display('not enough points to sample');
end

%end
