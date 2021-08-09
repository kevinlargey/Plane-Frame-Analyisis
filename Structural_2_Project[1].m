disp('*************************************************');
disp('****************  Welcome To  *******************');
disp('************* The Matrix Analysis ***************');
disp('************ of Structures Program **************');
disp('*************************************************');
disp('*************************************************');
disp('********* By: Kevin Largey and Nam Pham *********');
disp('*************************************************');   


%Part I: Data is read in from Excel File into the matrix trussdata. Project
%number is displayed to user.

trussdata=xlsread('trussdata.xlsx');
ProjectNumber=trussdata(1,15);
fprintf('Project Number: %i',ProjectNumber);

%Part II-VI: Data is extracted from Excel file into different matrices and
%integers.  Input data is formatted and displayed to user.

global NJ COORD;
NJ=trussdata(1,1);
COORD=zeros(NJ,2);
for i=1:NJ
    COORD(i,1)=trussdata(i+1,1);
    COORD(i,2)=trussdata(i+1,2);
end

global NS MSUP;
NS=trussdata(1,3);
MSUP=zeros(NS,3);
for i=1:NS
    MSUP(i,1)=trussdata(i+1,3);
    MSUP(i,2)=trussdata(i+1,4);
    MSUP(i,3)=trussdata(i+1,5);
end

global NMP EM;
NMP=trussdata(1,6);
EM=zeros(NMP,1);
for i=1:NMP
    EM(i,1)=trussdata(i+1,6);
end

global NCP CP;
NCP=trussdata(1,7);
CP=zeros(NCP,1);
for i=1:NCP
    CP(i,1)=trussdata(i+1,7);
end

global NM MPRP;
NM=trussdata(1,8);

MPRP=zeros(NM,4);

for i=1:NM
    MPRP(i,1)=trussdata(i+1,8);
    MPRP(i,2)=trussdata(i+1,9);
    MPRP(i,3)=trussdata(i+1,10);
    MPRP(i,4)=trussdata(i+1,11);
end

global NJL JP PJ;
NJL=trussdata(1,12);
JP=zeros(NJL,1);
PJ=zeros(NJL,2);
for i=1:NJL
    JP(i,1)=trussdata(i+1,12);
    PJ(i,1)=trussdata(i+1,13);
    PJ(i,2)=trussdata(i+1,14);
end

fprintf('\n\n');
fprintf('*****************Input Data*****************');
fprintf('\n\n');
fprintf('Number of joints: %i\n',NJ);
fprintf('Number of supports: %i\n',NS);
fprintf('Number of members: %i\n\n',NM);

Joint=(1:NJ);
Joint=Joint';
X_Coordinate=COORD(:,1);
Y_Coordinate=COORD(:,2);

JointCoordinate_Table=table(Joint,X_Coordinate,Y_Coordinate);
disp(JointCoordinate_Table);

Support_Joint=MSUP(:,1);
X_Restraint=strings();
Y_Restraint=strings();

for i=1:NS
    if MSUP(i,2)==1
        X_Restraint(i)='yes';
    else
        X_Restraint(i)='no';
    end
    
    if MSUP(i,3)==1
        Y_Restraint(i)='yes';
    else
        Y_Restraint(i)='no';
    end
end

X_Restraint=X_Restraint';
Y_Restraint=Y_Restraint';

JointSupport_Table=table(Support_Joint,X_Restraint,Y_Restraint);
disp(JointSupport_Table);

Material_Number=(1:NMP);
Material_Number=Material_Number';

E=EM(:);

Material_Table=table(Material_Number,E);
disp(Material_Table);

Cross_Section_Number=[1:NCP];
Cross_Section_Number=Cross_Section_Number';

Area=CP(:);

Cross_Section_Table=table(Cross_Section_Number, Area);
disp(Cross_Section_Table);

fprintf('\n');
disp('                           MEMBER DATA');
disp('*****************************************************************');


Member=(1:NM);
Member=Member';
Start_Joint=MPRP(:,1);
End_Joint=MPRP(:,2);
Material=MPRP(:,3);
Cross_Section=MPRP(:,4);

Member_Data_Table=table(Member,Start_Joint,End_Joint,Material,Cross_Section);
disp(Member_Data_Table);
fprintf('*****************End of Input Data*****************\n\n\n');

fprintf('*****************Output Data*****************\n');

%Part VII: Number of degrees of freedom is determined.

global NR NDOF;
NR=0;
for i=1:NS
    for i1=2:3
        if MSUP(i,i1)==1
            NR=NR+1;
        end
    end
end
NDOF=2*NJ-NR;

%Part VIII: NSC vector is generated, containing the coordinates of joints
%at degrees of freedom.

global NSC;
NSC=zeros(4,1);
j=0;
k=NDOF;
for i=1:NJ
    icount=0;
    for i1=1:NS
        if MSUP(i1,1)==i
            icount=1;
            for i2=1:2
                i3=(i-1)*2+i2;
                if MSUP(i1,(i2+1))==1
                    k=k+1;
                    NSC(i3,1)=k;
                else
                j=j+1;
                NSC(i3,1)=j;
                end
            end       
        end
    end
    if icount==0
        for i2=1:2
            i3=(i-1)*2+i2;
            j=j+1;
            NSC(i3,1)=j;
        end
    end
end

%Part IX: Structure Matrix is generated.

global S GK;
S=zeros(NDOF,NDOF);
for i=1:NM
    JB=MPRP(i,1);
    JE=MPRP(i,2);
    I=MPRP(i,3);
    E=EM(I);
    I=MPRP(i,4);
    A=CP(I);
    XB=COORD(JB,1);
    YB=COORD(JB,2);
    XE=COORD(JE,1);
    YE=COORD(JE,2);
    BL=sqrt((XE-XB)^2+(YE-YB)^2);
    CX=(XE-XB)/BL;
    CY=(YE-YB)/BL;
    GK=MSTIFFG(E,A,BL,CX,CY,GK);
    S=STORES(JB,JE,NDOF,NSC,GK,S);
end

%Part X: Formation of joint load vector.

global P;
P=zeros(NDOF,1);
for i=1:NJL
    i1=JP(i);
    i2=(i1-1)*2;
    for j=1:2
        i2=i2+1;
        N=NSC(i2);
        if N<=NDOF
            P(N)=P(N)+PJ(i,j);
        end
    end
end

%Part XI: Joint displacements are calculate using Gauss-Jordan method.

global d;
d=zeros(NDOF,1);
d=S\P;

global BK T V U Q F R;
R=zeros(NR,1);
Qout=string();
for i=1:NM
    JB=MPRP(i,1);
    JE=MPRP(i,2);
    I=MPRP(i,3);
    E=EM(I);
    I=MPRP(i,4);
    A=CP(I);
    XB=COORD(JB,1);
    YB=COORD(JB,2);
    XE=COORD(JE,1);
    YE=COORD(JE,2);
    BL=sqrt((XE-XB)^2+(YE-YB)^2);
    CX=(XE-XB)/BL;
    CY=(YE-YB)/BL;
    V=MDISPG(JB,JE,NDOF,NSC,d,V);
    T=MTRANS(CX,CY,T);
    U=MDISPL(V,T,U);
    BK=MSTIFFL(E,A,BL,BK);
    Q=MFORCEL(BK,U,Q);
    if Q(1,1)>0
        a=abs(Q(1,1));
        b=a+" (C)";
    else
        a=abs(Q(1,1));
        b=a+" (T)";
    end
    Qout(i,1)=b;
    F=MFORCEG(T,Q,F);
    R=STORER(JB,JE,NDOF,NSC,F,R);
end

%Part XII: Member forces and support reactions are calculated.

dd=zeros(NJ,2);
m=0;
for i=1:NJ
    for j=1:2
        m=m+1;
        N=NSC(m);
        if N<=NDOF
            dd(i,j)=d(N);
        end
    end
end

%Part XIII: Output is formatted into respective matrices and displayed to
%user.

Rx=zeros(NS,1);
Ry=zeros(NS,1);
j=1;
for i=1:NS
    if MSUP(i,2)==1
        Rx(i,1)=R(j,1);
        j=j+1;
    elseif  MSUP(i,2)==0
        Rx(i,1)=0;
    end
    if MSUP(i,3)==1
        Ry(i,1)=R(j,1);
        j=j+1;
    elseif MSUP(i,3)==0
        Ry(i,1)=0;
    end
end


fprintf('NDOF:\n\n');
disp(NDOF)
fprintf('NSC:\n\n');
disp(NSC)
fprintf('Structure Stiffness Matrix:\n\n');
disp(S)
fprintf('Joint Load Vector:\n\n');
disp(P)

Joint_No=(1:NJ)';
X_Translation=dd(:,1);
Y_Translation=dd(:,2);
table_joint_displacements=table(Joint_No,X_Translation,Y_Translation);
fprintf('**************Joint Displacements**************\n\n');
disp(table_joint_displacements)

Member=(1:NM)';
Axial_Force=Qout;
table_axial_forces=table(Member,Axial_Force);
fprintf('********Member Axial Forces********\n\n');
disp(table_axial_forces)

Joint_No=MSUP(:,1);
X_Force=Rx;
Y_Force=Ry;
table_support_reactions=table(Joint_No,X_Force,Y_Force);
fprintf('********Support Reactions********\n\n');
disp(table_support_reactions)
fprintf('*****************End of Output Data*****************\n');


    
        
            
    


    
    
