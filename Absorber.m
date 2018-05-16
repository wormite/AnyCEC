function totalLength = Absorber(shapeNumber)
global g_absorber;
global g_unitLength;
%% starting from the lowest point of the shape up to the highest point, the shape is symetrical in this case.
%% Note: the shape proposed must be starting from the y axis and end at y axis;
% 
% % %% examples:
totalLength = 0;
g_absorber = [];
switch shapeNumber
    case 1
        %pentagon shape
        radius  =96/2*cos(22.5/180*pi);
        bottomPoint=-102/2-0.5;
        g_absorber = [0;bottomPoint];
        for theta = 2*pi/5+3/2*pi:2*pi/5:(2+.5)*pi
            g_absorber = [g_absorber,[radius*cos(theta);radius*sin(theta)]];
        end

    case 2
        %% minichannel absorber:
        radius = .5;
        g_absorber = [0;0];
        g_absorber = [g_absorber,[radius;2]];
        g_absorber = [g_absorber,[radius;27]];     
        for theta = 0.001:10/180*pi:pi/2-0.001
        g_absorber = [g_absorber,[radius*cos(theta);70/2+radius*sin(theta)]];
        end;

    case 3
        %1.circle with radius being 10;
        radius = 16.7/2;
        for theta = 3/2*pi:0.5*pi/180:5/2*pi;
            g_absorber = [g_absorber,[radius*cos(theta);radius*sin(theta)] ];
        end

    case 4
        % circular shape with gap consideration
        radius  =96/2*cos(22.5/180*pi);
        bottomPoint=-102/2-1.5;
        g_absorber = [0;bottomPoint];
        angle = acos(radius/(-bottomPoint));
        for theta = -1/2*pi+angle+0.1/180*pi:0.5/180*pi:pi/2
            g_absorber = [g_absorber,[radius*cos(theta);radius*sin(theta)]];
        end;
    case 5
        %58mm absorber icecream cone design
        radius = 6; %% size of the center tube
        g_absorber = [0.12;0];
        for theta = 2*pi-0.3398:1*pi/180:2*pi+pi/2
        g_absorber = [g_absorber,[radius*cos(theta);radius*sin(theta)+3*radius] ];
        end
    case 6
        %85mm absorber icecream cone design
        radius = 6;
        g_absorber = [0.12;0];
        for theta = 2*pi-0.2026:1*pi/180:2*pi+pi/2
            g_absorber = [g_absorber,[radius*cos(theta);radius*sin(theta)+32.2950] ];
        end
    case 7
        % hand drawn 1.
        x = [-5,-4.8,-4,-3,0,3,4,4.8,5];
        y = [0,.3,.9,1.2,1.5,1.2,.9,.3,0];
        xx = -5:.25:5;
        yy = spline(x,y,xx);
        g_absorber = [yy;xx];
    case 8
        % hand drawn 2
        x = [-5,0,5];
        y = [0,1,0];
        xx = -5:.25:5;
        yy = spline(x,y,xx);
        g_absorber = [yy;xx];

    case 9
        %3.octangle
        g_absorber = [g_absorber,g_unitLength*[0;-1]];
        g_absorber = [g_absorber,g_unitLength*[2^.5/2;-2^.5/2]];
        g_absorber = [g_absorber,g_unitLength*[1;0]];
        g_absorber = [g_absorber,g_unitLength*[2^.5/2;2^.5/2]];
        g_absorber = [g_absorber,g_unitLength*[0;1]];

    case 10
        % random points.
        g_absorber = [g_absorber,g_unitLength*[0;-2]];
        g_absorber = [g_absorber,g_unitLength*[1;-1]];
        g_absorber = [g_absorber,g_unitLength*[2;1]];
        g_absorber = [g_absorber,g_unitLength*[2;1.5]];
        g_absorber = [g_absorber,g_unitLength*[0;3]];

    case 11
        % changed absorber
        radius = 6; %% size of the center tube
        g_absorber = [6;0];
        for theta = 0:1*pi/180:pi/2
            g_absorber = [g_absorber,[radius*cos(theta);radius*sin(theta)+3*radius] ];
        end;
    case 12
        radius  =92/2; 
        %square shape
        height = 5+radius;
        g_absorber = [0.001;0];
        g_absorber = [g_absorber,[radius*cos(0);height+radius*sin(0)]];
        g_absorber = [g_absorber,[radius*cos(pi/2-0.001);height+radius*sin(pi/2-0.001)]];
    case 13
        %flat absorber
        g_absorber = [10;0];
        g_absorber = [g_absorber,[0.1;0]];
    case 14
        %radius  =92/2; 
        offset = -2.5;
        %g_absorber = [0.001;-46];
        g_absorber = [0.001;-49+offset];
        %g_absorber = [g_absorber,[2.619;-45.1356]];
        g_absorber = [g_absorber,[44.91805974;9.91805974+offset]];
        g_absorber = [g_absorber,[24.68280878;38.81699307+offset]];
        g_absorber = [g_absorber,[0.001;38.81699307+offset]];
    case 15
        %% oval shape:
        g_absorber = [0;0];
 
        %g_absorber = [g_absorber,[0;28.2]];
        g_absorber = [g_absorber,[0;(63+4)]];
    case 16
        %% v groove shape
        %inner circle;
        i_radius = 14;
        %outer circle;
        o_radius = i_radius+2;
        %outer circle start point 
        theta = (acos(i_radius/o_radius)*180/pi-2)*pi/180;%15 is the angle starting from the middle line.
        theta = theta*0.99;
        %theta should be less(a little bit, not increasing fast) than
        if theta>acos(i_radius/o_radius);
            display('warning: starting angle should be less than:');
            acos(i_radius/o_radius)*180/pi;
        end
        start_angle = -pi/2+theta;
        g_absorber =[o_radius*cos(start_angle);o_radius*sin(start_angle)];
        %inner circle starting angle.
        i_start_angle = start_angle +acos(i_radius/o_radius);
        spacing = (pi/2-i_start_angle)/40;
        for step = i_start_angle:spacing:pi/2;
            g_absorber = [g_absorber ,[i_radius*cos(step);i_radius*sin(step)]];
        end
    case 17
        %radius  =92/2;
        ratio = 120/102;
        offset = -2.5*ratio;
        %g_absorber = [0.001;-46];
        g_absorber = [0.001;(-49+offset)*ratio];
        %g_absorber = [g_absorber,[2.619;-45.1356]];
        g_absorber = [g_absorber,[44.91805974*ratio;9.91805974*ratio+offset*ratio]];
        g_absorber = [g_absorber,[24.68280878*ratio;38.81699307*ratio+offset*ratio]];
        g_absorber = [g_absorber,[0.001;38.81699307*ratio+offset*ratio]];
end



%2.square with weird shape.
% g_absorber = [g_absorber,g_unitLength*[0;-2]];
% g_absorber = [g_absorber,g_unitLength*[1;-1]];
% g_absorber = [g_absorber,g_unitLength*[2;1]];
% g_absorber = [g_absorber,g_unitLength*[2;1.5]];
% g_absorber = [g_absorber,g_unitLength*[0;3]];


%% duplicating the other half.
if(g_absorber(1,end)>=0.00001)% the unequal ~= check does not satisfy, sometimes it fails below 1e-15.
    for i = size(g_absorber,2):-1:1
        g_absorber = [g_absorber,[-g_absorber(1,i);g_absorber(2,i)] ];
    end
else
    for i = size(g_absorber,2)-1:-1:1
        g_absorber = [g_absorber,[-g_absorber(1,i);g_absorber(2,i)] ];
    end
end
for i=1:size(g_absorber,2)-1
    totalLength=totalLength+norm(g_absorber(:,i)-g_absorber(:,i+1));
end
end