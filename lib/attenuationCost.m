function cost = attenuationCost(c,rho,d,f,il,attn)
[~,T] = estimateGamma3Layer(c,rho,d,f,attn);

cost = abs(abs(T)-il);