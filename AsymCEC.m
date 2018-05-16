function AsymCEC(source_left,source_right,l_absorber)
global g_minStepRatio;

plotLine(source_left,source_right);

right_tangPoint=TangCheck(source_left,l_absorber(1,:),l_absorber,-1);
plotLine(right_tangPoint,source_left);
%crossline from left source to right tangent
x1 = source_left-right_tangPoint;
left_tangPoint=TangCheck(source_right,l_absorber(1,:),l_absorber,1);
plotLine(left_tangPoint,source_right);
%crossline from right source to left tangent
x2 = source_right-left_tangPoint;
%% counter clock wise
for counterClockWise = [1,-1]

    if(counterClockWise == -1);
        l_absorber = flipud(l_absorber);
    end
    A = l_absorber(1,:);
    B = l_absorber(2,:);
    AB = B-A;
    plotLine(A,B,'-r');
    P = A+[AB(2),-AB(1)]*counterClockWise*g_minStepRatio*4;
    plotLine(A,P,'-g');

    while(1)
        P_tangPoint =TangCheck(P,A,l_absorber,counterClockWise);
        %plotLine(P,P_tangPoint,'-r');

        zone = ZoneCheck(source_left,source_right,x1,x2,P);
        if (zone==1)
            plotLine(P,P_tangPoint,'y')
            plotLine(P,source_right,'y')
            P_next = P+ReflectSurface(P_tangPoint, P, source_right)*norm(P-P_tangPoint)*g_minStepRatio;
            plotLine(P,P_next,'g-');
            A = P_tangPoint;
        elseif(zone==2)
            plotLine(P,P_tangPoint,'y')
            plotLine(P,source_left,'y')
            P_next = P+ReflectSurface(P_tangPoint, P, source_left)*norm(P-P_tangPoint)*g_minStepRatio;
            plotLine(P,P_next,'g-');
            A = P_tangPoint;
        elseif(zone==3)
            %%reflect to tangent direction
            plotLine(P,P_tangPoint,'y')
            plotLine(P,A,'y')
            reflector = ReflectSurface(P_tangPoint, P, P_tangPoint)*norm(P-P_tangPoint);
            reflector = reflector*-counterClockWise;
            P_next = P+reflector*g_minStepRatio;
            plotLine(P,P_next,'g-');
            A = P_tangPoint;
        elseif(zone==4)
            break;
        else
            display('zone error');
            break;
        end
        P=P_next;
    end
%see if obstructed by the body itself.

%see if exceeds the x2 line
%see if exceeds the x1 line


%%  clock wise
end;
end
