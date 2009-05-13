function h=hermite( n, all_polys )
%HERMITE  Return the n-th Hermite polynomial.
%  H=HERMITE(N) with n integer and non-negative returns the n-th
%  (probabilistic) Hermite polynomial H_i(x). The returned polynomials is 
%  not normalized so that <H_i H_j>=i! delta_ij, where <.> denotes the
%  expected value with respect to the Gauss measure exp(-x^2/2)/sqrt(2*pi).
%  The algoritm uses the three term recurrence
%     $$H_{n+1}(x) = x H_n - n H_{n-1}$$
%  with H_0=1 and H_1=x. The returned polynomial uses the standard matlab
%  representation of polynomials where the first element corresponds to the 
%  highest power of x and the last element to the constant. E.g.: 
%  hermite(4) returns [1,0,-6,0,3] which means x^4-6*x^2+3. Polynomials of
%  this kind can be easily manipulated and evaluated in Matlab using the
%  functions polyint (integration), polyder (derivatives), conv
%  (multiplication) and polyval (evaluation).
%
%  H=HERMITE(N,TRUE) returns all Hermite polynomials up to degree N.
%
% Example
%   h3=hermite( 3 );
%   h4=hermite( 4 );
%   p7=conv(h3,h4);
%   x=linspace(-1,1); y=polyval(p7,x);
%   plot(x,y);
% 
% See also HERMITE_VAL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 

if n==0
    h=1;
    return;
end

if nargin<2 || ~all_polys
    p=1;
    q=[1 0];
    for i=1:n-1;
        %H_{n+1} = x H_n(x) - n H_{n-1}
        [q,p]=deal([q 0]-i*[0 0 p],q);
    end
    h=q;
else
    h=zeros(n+1,n+1);
    %H_0 = 1
    h(1,end)=1;
    %H_1 = x
    h(2,end-1)=1;
    for i=2:n
        %H_{n+1} = x H_n(x) - n H_{n-1}
        h(i+1,:)=[h(i,2:end) 0] - (i-1)*h(i-1,:);
    end
end



            
%a=ones(1,11), h=a'; for i=1:5; n=length(a)-1; a=[cumsum( a(2:n).*(1:n-1) )], h=[h [zeros(2*i,1);a']]; end; h