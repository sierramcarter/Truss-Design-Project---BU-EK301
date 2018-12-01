load('HoweTruss1');

[Rows,Cols]=size(C);
xComp = zeros(Rows,Cols);
yComp = zeros(Rows,Cols);
sumR = 0;
Rvec = [];
Rmax = 0;
FintVec = [];
Finternal = 0;
Fbuckling = 0;
SRmax = 0;
SRVec = [];
FbucklingVec = [];
for i=1:Cols
    for j=1:Rows
        if C(j,i)==1
            for k=1:Rows
                if (C(k,i)==1) && (k~=j)
                    xDiff = X(k)-X(j);
                    yDiff = Y(k)-Y(j);
                    R = sqrt(xDiff^2 + yDiff^2);
                    sumR = sumR + R;
                    xComp(j,i) = xDiff/R;
                    yComp(j,i) = yDiff/R;
                end
            end
        end
     end
end

% matrix manipulation
A = [xComp; yComp];
S = [Sx; Sy];
A = [A, S];
A = A^-1;
T = A*L;
for i=1:Cols
    for j=1:Rows
        if C(j,i)==1
            for k=1:Rows
                if (C(k,i)==1) && (k~=j)
                    xDiff = X(k)-X(j);
                    yDiff = Y(k)-Y(j);
                    R = sqrt(xDiff^2 + yDiff^2);
                    FintVec = [FintVec T(j)];
                    Finternal = T(j);
                    Fbuckling = 1439.043/R^2;
                    FbucklingVec = [FbucklingVec Fbuckling];
                    SR = Finternal/Fbuckling;
                    if SR > SRmax
                        SRmax = SR;
                    end
                    SRVec = [SRVec SR];
                end
            end
        end
     end
end
FbucklingVec;
for i=1:length(FbucklingVec)
    if rem(i,2) == 0
        FbucklingVec(i)
    end
end

% calculations
cost = 10*Rows + sumR/2;
Ffailure = abs(1/SRmax)
SRVecFinal = [];
for i = 1:length(SRVec)/2
    SRVecFinal = [SRVecFinal sqrt(SRVec(i)^2+SRVec(i+length(SRVec)/2)^2)];
end
SRVecFinal;
(SRVecFinal).^-1;
% printing
for i = 1:length(L)
    if L(i)~=0
        appliedLoad = abs(L(i));
        fprintf("Load: %.2f N \n", appliedLoad);
    end
end
fprintf("Member forces in Newtons \n");
for i = 1:length(T)-3
    if T(i) > 0
        fprintf("m%d: %.3f (%c)\n", i, T(i), 'T');
    else
        fprintf("m%d: %.3f (%c)\n", i, abs(T(i)), 'C');
    end
end
fprintf("Reaction forces in Newtons\n");
fprintf("Sx1: %.2f\n", T(length(T)-2));
fprintf("Sy1: %.2f\n", T(length(T)-1));
fprintf("Sy2: %.2f\n", T(length(T)));
fprintf("Cost of truss: $%.2f\n", cost);
fprintf("Theoretical max load/cost ratio is N/$: %.4f\n", Ffailure/cost);