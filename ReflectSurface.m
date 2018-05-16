function res = ReflectSurface(O, P, target)
res = ((target-P)/norm(target-P)+(P-O)/norm(P-O));
%%To deal with the normal direction coming in.
if norm(res)<eps
    PO = O-P;
    res(1)=-PO(2);
    res(2)=PO(1);
    res = res/norm(res);
end
end