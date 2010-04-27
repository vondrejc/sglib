%clear

%% 1. Define the geometry
geom='lshape';
num_refine=2;
show_mesh=false;
[pos,els,G_N,ptdata]=load_pdetool_geom( geom, num_refine, show_mesh );
[d,N]=size(pos);


%% 2.2 Define the covariance
cov_k_handle=@exponential_covariance;
lc_k=[0.1 0.4];
cov_k_func={cov_k_handle, {lc_k,1}};

% x=point_range( [-1,0,1], 'N', 200 );
% plot( x, funcall( cov_k_func, [x;0*x], [] ) ); hold all;
% plot( x, funcall( cov_k_func, [0*x;x], [] ) ); hold off;
% legend( 'x-direction', 'y-direction' )
% title( 'Step 2.2: Define the covariance of $\kappa$' );
% userwait;

%% 2.3 Check the KL convergence
C_k=covariance_matrix( pos, cov_k_func );
[k_i_k,sigma_k_k]=kl_solve_evp( C_k, G_N, 40 );
[kl_rem,params,sigma_ex]=kl_estimate_eps( sigma_k_k, 'Nout', 100, 'full', true );
kl_rem_old=kl_rem;
sigma_k_k_old=sigma_k_k;

%% 
eps_k=0.05;
l_k=find(kl_rem<=eps_k,1,'first');
m_k=l_k;
[k_i_alpha, I_k]=expand_gaussian_field_pce( cov_k_func, pos, G_N, m_k );

%% show different approximation quality for mean+var depending on number of
%% Gaussians
mh=multiplot_init(2,4);
msel=[20,40,80,m_k];

for m2=msel
    k_i_alpha2=k_i_alpha(:,1:m2);
    I_k2=I_k(1:m2,:);
    h=multiplot; 
    plot_kl_pce_mean_var( pos, els, [], k_i_alpha2, I_k2 );
    h=multiplot; 
    plot_kl_pce_mean_var( pos, els, [], k_i_alpha2, I_k2 );
    view(45,0);
end
same_scaling(mh,'z');
same_scaling(mh,'c');


for m2=msel
    h=multiplot; 
    save_figure( h, {'kl_not_enough_2d_%d', m2}, 'png' );
    h=multiplot; 
    save_figure( h, {'kl_not_enough_2d_%d_side', m2}, 'png' );
end

%%
[k_i_k,sigma_k_k]=kl_solve_evp( C_k, G_N, 200 );
[kl_rem,params,sigma_ex]=kl_estimate_eps( sigma_k_k, 'Nout', 200, 'full', true );

%%
multiplot_init(2,1);
h=multiplot;
plot( sigma_k_k );
plot( msel, sigma_k_k(msel), '*' );
plot( sigma_k_k_old );
h=multiplot;
plot( 1:200, kl_rem(1:200) );
plot( msel, kl_rem(msel), '*' );
plot( 1:200, kl_rem_old(1:200) );

