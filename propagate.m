function newd = propagate(im, d)

eps9 = 1/9;
lambda = 0.2;

h = size(im, 1);
w = size(im, 2);

% for plankton can put an artificial crazy edge around the border
%d(2,1:w) = 0.00001;
%d(h-1,1:w) = 0.00001;
%d(1:h,2) = 0.00001;
%d(1:h,w-1) = 0.00001;

N = h * w;
inner = (h-2)*(w-2);

Lind1 = zeros(81*inner, 1);
Lind2 = zeros(81*inner, 1);
Lindv = zeros(81*inner, 1);

offx = [-1 -1 -1  0  0  0  1  1  1];
offy = [-1  0  1 -1  0  1 -1  0  1];

count = 0;
for i = 2:(h-1)
    for j = 2:(w-1)
        window = im((i-1):(i+1), (j-1):(j+1));
        mn = mean(window(:));
        vr = var(window(:));
        for p = 1:9
            x1 = i + offx(p);
            y1 = j + offy(p);
            px1 = w * (x1 - 1) + y1;
            for q = 1:9
                x2 = i + offx(q);
                y2 = j + offy(q);
                px2 = w * (x2 - 1) + y2;
                count = count + 1;
                Lind1(count) = px1;
                Lind2(count) = px2;
                Lindv(count) = (px1 == px2)-(1/9)*(1 + ((eps9 + vr))*(im(x1,y1)-mn)*(im(x2,y2)-mn));
            end
        end                
    end
end

L = sparse(Lind1, Lind2, Lindv, N, N);

Dind = find(d');
D = sparse(Dind, Dind, ones(size(Dind)), N, N);

d = reshape(d', N, 1);
toc

newd  = (L + lambda * D)\(lambda * lambda * D * d);
%newd = lsqr(L + lambda * D, lambda * D * d, [], 10000);
newd = reshape(newd, w, h)';

% optionaly invert, depending what kind of visualization is preferred
newd = max(max(newd)) - newd;
