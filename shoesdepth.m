function [depths] = shoesdepth(d1, d2, d3)
    k = 208;
    N = 3.5;
    f = 18;
    df = 1000;
    
    depths = zeros(2,3);
    depths(1,1) = (k*f*f*df) / (k*f*f + d1 * N * (df - f));
    depths(2,1) = (k*f*f*df) / (k*f*f - d1 * N * (df - f));
    depths(1,2) = (k*f*f*df) / (k*f*f + d2 * N * (df - f));
    depths(2,2) = (k*f*f*df) / (k*f*f - d2 * N * (df - f));
    depths(1,3) = (k*f*f*df) / (k*f*f + d3 * N * (df - f));
    depths(2,3) = (k*f*f*df) / (k*f*f - d3 * N * (df - f));
  