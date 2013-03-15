function newd = propagate(im, e, d)

epsilon = 1;
lambda = 0.01;

h = size(im, 1);
w = size(im, 2);
if size(im, 3) == 1
    im2 = zeros(h, w, 3);
    im2(:, :, 1) = im; im2(:, :, 2) = im; im2(:, :, 3) = im;
    im = im2;
end

N = h * w;
L = zeros(N);
D = zeros(N);

for k = 1:N
    x = ceil(k/w);
    y = k - (x - 1) * w;
    if e(x, y)
        D(k, k) = 1;
    end
    if (x == 1 || y == 1 || x == h || y == w)
        continue;
    end
    
    meanmat = mean(mean(im((x-1):(x+1), (y-1):(y+1), :)));
    covmat = cov(reshape(im((x-1):(x+1), (y-1):(y+1), :), 9, 3));
       
    for pair = 1:81
        pix1 = ceil(pair/9);
        pix2 = pair - (pix1 - 1) * 9;
        offx1 = ceil(pix1/3) - 2;
        offy1 = pix1 - 3 * (offx1 + 1) - 2;
        offx2 = ceil(pix2/3) - 2;
        offy2 = pix2 - 3 * (offx2 + 1) - 2;
%        if ~(x + offx1 > 0 && x + offx1 <= h && y + offy1 > 0 && y + offy1 <= h && ...
%             x + offx2 > 0 && x + offx2 <= h && y + offy2 > 0 && y + offy2 <= h)
%            continue;
%        end
        i = (x + offx1 - 1) * w + y + offy1;
        j = (x + offx2 - 1) * w + y + offy2;
        ix = ceil(i/w); iy = i - (ix-1)*w;
        jx = ceil(j/w); jy = j - (jx-1)*w;
        
        if i == j
            krondelta = 1;
        else
            krondelta = 0;
        end

        L(i,j) = L(i,j) + ...
                 krondelta - (1/9) * ...
                             (1 + reshape((im(ix, iy, :) - meanmat), 3, 1)' * ...
                                  pinv(covmat + (epsilon/9)*eye(3)) * ...
                                  reshape((im(jx, jy, :) - meanmat), 3, 1));
    end
end

save temp.mat;
d = reshape(d', N, 1);
toc
newd = lsqr(L + lambda * D, lambda * D * d);
newd = reshape(newd, w, h)';
