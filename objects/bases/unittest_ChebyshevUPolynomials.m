function unittest_ChebyshevUPolynomials
% UNITTEST_CHEBYSHEVUPOLYNOMIALS Test the CHEMYSHEV2POLYNOMIAL function.
%
% Example (<a href="matlab:run_example unittest_ChebyshevUPolynomials">run</a>)
%   unittest_ChebyshevUPolynomials
%
% See also CHEMYSHEV2POLYNOMIAL, MUNIT_RUN_TESTSUITE 

%   Aidin Nojavan slightly modified by Noemi Friedman
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'Chebyshev2Polynomial' );

%% Initialization
U=ChebyshevUPolynomials();

%% Recur_coeff
r=U.recur_coeff(4);
assert_equals(r,[[0,2,1];[0,2,1];[0,2,1];[0,2,1]],'recur_coeff');

%% evaluate
xi=[1,2,3,4];
y=U.evaluate(3, xi);
assert_equals(y,[1 2 3 4;1 4 15 56; 1 6 35 204; 1 8 63 496],'evaluate');

%% norm
n = [0 1; 3 5];
h = [1 1; 1 1];
assert_equals(U.sqnorm(n), h, 'nrm_arr');
assert_equals(U.sqnorm(n(:)), h(:), 'nrm_col');
assert_equals(U.sqnorm(n(:)'), h(:)', 'nrm_row');

%% consistency with weighting function
poly = ChebyshevUPolynomials();
N=4;

dist = poly.weighting_dist();
dom=dist.invcdf([0,1]);
fun = @(x)( poly.evaluate(N,x)'*poly.evaluate(N,x)*dist.pdf(x));
Q = integral(fun, dom(1), dom(2), 'ArrayValued', true, 'RelTol', 1e-6, 'AbsTol', 1e-6);
assert_equals(Q, diag(poly.sqnorm(0:N)), 'weighting_consistent');
