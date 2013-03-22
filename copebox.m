files = extractfield(dir('cam1*'), 'name');

n = size(files, 2);
rects = cell(1, n);

for f = 1:n
    im = imread(files{f});
    fsel = figure;
    imshow(im);
    maxx = size(im, 1);
    maxy = size(im, 2);

    rectshere = [];
    i = 0;
    while 1
        i = i + 1;
        newrect = getrect;

        % allow sloppiness
        newrect(1) = max(newrect(1), 1);
        newrect(2) = max(newrect(2), 1);
        newrect(3) = min(newrect(3), maxy - newrect(1));
        newrect(4) = min(newrect(4), maxx - newrect(2));

        % break on double click
        if newrect(3) == 0 && newrect(4) == 0
            break;
        end
        rectshere(i,:,:) = newrect;
    end
    close(fsel);

    rects{f} = rectshere;
end

save('copebox.mat', 'rects');
