function [edges, tagged] = edgedetect(img, edgethresh)
    if size(img, 3) == 3
        bw = rgb2gray(img);
    else
        bw = img;
        img = repmat(bw, [1 1 3]);
    end
    r = img(:,:,1);
    edges = edge(bw, 'canny', edgethresh);
    r(edges) = 1;
    tagged = img;
    tagged(:,:,1) = r;
end
