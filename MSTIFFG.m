function [GK] = MSTIFFG(E,A,BL,CX,CY,GK)

%Function MSTIFFG for determining the member global stiffness matrix.

z=E*A/BL;
z1=z*(CX^2);
z2=z*(CY^2);
z3=z*CX*CY;
GK(1,1)=z1;
GK(2,1)=z3;
GK(3,1)=-z1;
GK(4,1)=-z3;
GK(1,2)=z3;
GK(2,2)=z2;
GK(3,2)=-z3;
GK(4,2)=-z2;
GK(1,3)=-z1;
GK(2,3)=-z3;
GK(3,3)=z1;
GK(4,3)=z3;
GK(1,4)=-z3;
GK(2,4)=-z2;
GK(3,4)=z3;
GK(4,4)=z2;
end
