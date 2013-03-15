function MRF_labeling = fastPD(d, img, DEBUG)
    if (DEBUG)
        input_file = 'tempinput.bin';
        output_file = 'tempoutput.bin';
    else
        input_file = tempname('.');
        output_file = tempname('.');
    end
    
    fid = fopen(input_file, 'wb');
    if fid == -1
        error(['Cannot open file ' results_fname]);
    end
    
    h = size(d, 1);
    w = size(d, 2);
    numpoints = h * w;
    numlabels = 10;
    numpairs = 2 * h * w - h - w;
    maxiters = 100;
    type = 'uint32';

    % HACK
    avg = mean(d(find(d(:))));
    stdev = std(d(find(d(:))));
    d(d > avg + 2*stdev) = avg + 2 * stdev;
    d = normalize(d);
    
    if (DEBUG)
        display 'about to start writing'
        toc
        display ' '
    end
    
    fwrite(fid, numpoints, type);
    fwrite(fid, numpairs, type);
    fwrite(fid, numlabels, type);
    fwrite(fid, maxiters, type);
    
    % label costs at each point
    s = zeros(h, w, numlabels);
    for l = 0 : (numlabels - 1)
        diff = l/numlabels - d;
        diff = diff .* diff;
        
%        temp = diff;
        temp = 10 * abs(l * ones(h, w) - round((numlabels - 1) * d));
        temp(d == 0) = 0;
        s(:, :, l + 1) = temp;
    end
    fwrite(fid, s, type);
    
    if (DEBUG)
        display 'wrote label costs'
        toc
        display ' '
    end
    
    % pairs (each pixel is neighbor with 4 adjacent)
    for i = 1:h
        row = w * (i - 1);
%        for j = 1:(w-1)
%            fwrite(fid, row + j - 1, type);
%            fwrite(fid, row + j, type);
%        end
        temp = [row, kron((row + 1):(row + w - 2), [1 1]), w - 1];
        fwrite(fid, temp, type);
    end
    temp = zeros(1, 2 * w * (h - 1));
    temp(1:2:end) = 0 : (w * (h - 1) - 1);
    temp(2:2:end) = w : (w * h - 1);
    fwrite(fid, temp, type);
%    for i = 1:(h-1)
%        row1 = w * (i - 1);
%        row2 = w * i;
%        for j = 1:w
%            fwrite(fid, row1 + j - 1, type);
%            fwrite(fid, row2 + j - 1, type);
%        end
%    end
    
    if (DEBUG)
        display 'wrote pairs'
        toc
        display ' '
    end
    
    % inter-label costs (0 if same, 1 if adjacent, 2 otherwise)
    labelcosts = 2 * ones(numlabels, numlabels) - ...
                 2 * eye(numlabels) - ...
                 1 * diag(ones(numlabels - 1, 1), 1) - ...
                 1 * diag(ones(numlabels - 1, 1), -1);
    fwrite(fid, labelcosts, type);
    
    if (DEBUG)
        display 'wrote label costs'
        toc
        display ' '
    end
    
    % graph edge costs (const everywhere)
    fwrite(fid, ones(1, numpairs), type);
    
    % graph edge costs (cost if falls on image edges)
%    for i = 1:h
%        for j = 1:(w-1)
%            if xor(d(i,j),d(i,j+1))
%                fwrite(fid, 100, type);
%            else
%                fwrite(fid, 20, type);
%            end


%            fwrite(fid, 100 * exp(-abs(img(i, j) - img(i, j+1))^2));
%            fwrite(fid, round(exp(-(img(i, j) - img(i, j+1))^2)));
%        end
%    end
%    for i = 1:(h-1)
%        for j = 1:w
%            if xor(d(i,j), d(i+1,j))
%                fwrite(fid, 100, type);
%            else
%                fwrite(fid, 20, type);
%            end


%            fwrite(fid, 100 * exp(-abs(img(i, j) - img(i+1, j))^2));
%            fwrite(fid, round(exp(-(img(i, j) - img(i+1, j))^2)));
%        end
%    end
   
    if (DEBUG)
        display 'wrote edge costs'
        toc
        display ' '
    end
    
	fclose(fid);
    
    % run FastPD
    system(['FastPD.exe ' input_file ' ' output_file]);
    MRF_labeling = get_MRF_labeling(output_file);
    MRF_labeling = reshape(MRF_labeling, h, w);
%    MRF_labeling = max(max(MRF_labeling)) - MRF_labeling;
    
    % clean up
    if (~DEBUG)
        delete(input_file, output_file);
    end
end
