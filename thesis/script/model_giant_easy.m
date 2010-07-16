% identification
model=mfilename;

% geometry
geom='lshape';
num_refine=2;
num_refine_after=1;

% right hand side
dist_f={'uniform', {-1,1}, 0.0, 1 };
m_f=25;
p_f=3;
l_f=30;
cov_f_func=@gaussian_covariance;
lc_f=0.5;

% coefficient field
[a,b]=beta_find_ratio( 0.4 );
dist_k={'beta', {a,b}, 0.001, 1.0 };
m_k=15;
p_k=3;
l_k=20;
cov_k_func=@exponential_covariance;
lc_k=0.7;

% dirichlet boundary field
mean_g_func=make_spatial_func('0');

% solution
p_u=3;
