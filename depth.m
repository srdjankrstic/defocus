function sol = depth(image_file, varargin)
    if (nargin > 1)
        options = varargin{1};
    else
        options = struct('DEBUG', 0);
    end
    
    tic

    %% Parameters:
    if ~isfield(options, 'edgethresh')
        options.edgethresh = 0.08;
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
%    clear im;

    if options.DEBUG
        [e, t] = edgedetect(bw, options.edgethresh);
        h = imshow(t);
        waitfor(h);
    else
        e = edgedetect(bw, options.edgethresh);
    end

    % calculate the gradient magnitude of the original image everywhere
    Gmag = imgradient(bw);

    % reblur and find the gradient magnitudes of the reblurred image
    G = fspecial('gaussian', options.reblur_size, options.reblur_sigma);
    bw2 = imfilter(bw, G);
    Gmag2 = imgradient(bw2);

    % calculte the ratio between the gradient magnitudes at edge locations
    Grat = Gmag ./ Gmag2;
    Grat = Grat .* e;
    clear Gmag Gmag2;

    % depth correlates with original blur, which we get as 1/sqrt(rat^2-1) at edges
    d = zeros(size(Grat));
    for i= 1:size(Grat,1)
        for j = 1:size(Grat,2)
            if Grat(i,j) > 1
                d(i,j) = options.reblur_sigma/sqrt(Grat(i,j)^2 - 1);
            end
        end
    end
    clear Grat;
    
    % hack
    avg = mean(d(find(d(:))));
    stdev = std(d(find(d(:))));
    thresh = avg + 2.5*stdev;
    d(d > thresh) = 0;

    if options.DEBUG
        imshow(d);
    end
    
    %drawpoints;
    %selectrect;

%    h = imshow(normalize(d));
%    waitfor(h);

%    smoothed = fastPD(d, bw, 1);
    smoothed = propagate(bw, d);
    toc

    figure; imshow(smoothed, []);

    sol = smoothed;
    toc
end
