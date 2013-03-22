n = 30;
avg = zeros(n, 1);

d = zeros(1080, 1920);
for i = 1:30
    d(:,:) = dep(i, :, :);
    rect = rects{i};
    rectangle = d(round(rect(1,2)):round(rect(1,2)+rect(1,4)), round(rect(1,1)):round(rect(1,1)+rect(1,3)));
    avg(i) = sum(sum(rectangle))/size(find(rectangle), 1);
end
