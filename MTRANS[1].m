function [T] = MTRANS(CX,CY,T)

%Function MTRANS for determining member transformation matrix

T=zeros(2,4);

T(1,1)=CX;
T(1,2)=CY;
T(2,3)=CX;
T(2,4)=CY;

end