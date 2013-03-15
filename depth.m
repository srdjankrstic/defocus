function sol = depth(image_file, varargin)
    if (nargin > 1)
        options = varargin{1};
    else
        options = struct('DEBUG', 0);
    end
    
    tic
    %clear all;
    %load('plank302.mat');

    %% Parameters:
    if ~isfield(options, 'edgethresh')
        options.edgethresh = 0.03;
    end
    if ~isfield(options, 'reblur_size')
        options.reblur_size = [10 10];
    end
    if ~isfield(options, 'reblur_sigma')
        options.reblur_sigma = 2;
    end
    
%     %% Read relevant EXIF data if not supplied:
%     if (~isfield(options, focal_length) || ~isfield(options, f_stop))
%         exif = imfinfo(image_file);
%         options.focal_length = exif.DigitalCamera.FocalLength;
%         options.f_stop = exif.DigitalCamera.FNumber;
%     end
    
    %% Calculate:
    % read in the image and find edges
    im = im2double(imread(image_file));
    if size(im, 3) == 3
        bw = rgb2gray(im);
    else
        bw = im;
    end

    [e, t] = edgedetect(bw, options.edgethresh);
    if options.DEBUG
        h = imshow(t);
        waitfor(h);
    end

    % calculate the gradient magnitude of the original image everywhere
    [Gmag, Gdir] = imgradient(bw);

    % reblur and find the gradient magnitudes of the reblurred image
    G = fspecial('gaussian', options.reblur_size, options.reblur_sigma);
    bw2 = imfilter(bw, G);
    [Gmag2, Gdir2] = imgradient(bw2);

    % calculte the ratio between the gradient magnitudes at edge locations
    Grat = Gmag ./ Gmag2;
    Grat = Grat .* e;

    % depth correlates with original blur, which we get as 1/sqrt(rat^2-1) at edges
    d = zeros(size(Grat));
    for i= 1:size(Grat,1)
        for j = 1:size(Grat,2)
            if Grat(i,j) > 1
                d(i,j) = options.reblur_sigma/sqrt(Grat(i,j)^2 - 1);
            end
        end
    end
    
    if options.DEBUG
        imshow(d);
    end
    
    %drawpoints;
%    selectrect;
%    drawavgs;

    smoothed = propagate(im, e, d);
    save withnewd.mat;
    toc
%    smoothed = fastPD(d, bw, 1);

%    smoothed = fastPD(d, options.DEBUG);
    figure; imshow(smoothed, []);

    sol = smoothed;
    toc
end

