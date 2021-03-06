// file merton_jump_diff_call.cc
// author: Bernt Arne Oedegaard

#include <oxstd.h>
#include "financialNR.h"

const decl MAXN=50;

option_price_call_merton_jump_diffusion( decl S,
						decl X,
						decl r,
						decl sigma,
						decl time_to_maturity,
						decl lambda,
						decl kappa,
						decl delta) {
    decl tau=time_to_maturity;
    decl sigma_sqr = sigma*sigma;
    decl delta_sqr = delta*delta;
    decl lambdaprime = lambda * (1+kappa);
    decl gamma = log(1+kappa);
    decl c = exp(-lambdaprime*tau)*
	option_price_call_black_scholes(S,X,r-lambda*kappa,sigma,tau);
    decl log_n = 0;
    for (decl n=1;n<=MAXN; ++n) {
	log_n += log(n);
	decl sigma_n = sqrt( sigma_sqr+n*delta_sqr/tau );
	decl r_n = r-lambda*kappa+n*gamma/tau;
	c += exp(-lambdaprime*tau+n*log(lambdaprime*tau)-log_n)*
	    option_price_call_black_scholes(S,X,r_n,sigma_n,tau);
    }
    return c;
}
