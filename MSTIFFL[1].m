function [BK] = MSTIFFL(E,A,BL,BK)

%Function MSTIFFL for determining member local stiffness matrix.

BK=zeros(2,2);

Z=E*A/BL;

BK(1,1)=Z;
BK(2,1)=-Z;
BK(1,2)=-Z;
BK(2,2)=Z;

end