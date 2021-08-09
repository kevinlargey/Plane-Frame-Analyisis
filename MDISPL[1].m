function[U] = MDISPL(V,T,U)

%Function MDISPL for determining member local displacement vector.

U=zeros(2,1);

U=T*V;

end
