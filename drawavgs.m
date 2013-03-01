numrect = size(rect, 3);

avg = zeros(numrect, 1);
for i = 1:numrect
    rectangle = d(round(rect(1,2,i)):round(rect(1,2,i)+rect(1,4,i)), round(rect(1,1,i)):round(rect(1,1,i)+rect(1,3,i)));
    avg(i) = sum(sum(rectangle))/size(find(rectangle), 1);
end

figure;
imshow(im);
hold on;
for i = 1:numrect
    
%    rectangle('position', rect(:,:,i)', 'facecolor', 'r');
    plot([rect(1,1,i), rect(1,1,i)], [rect(1,2,i), rect(1,2,i)+rect(1,4,i)], 'Color', 'r', 'LineWidth', 2);
    plot([rect(1,1,i), rect(1,1,i)+rect(1,3,i)], [rect(1,2,i), rect(1,2,i)], 'Color', 'r', 'LineWidth', 2);
    plot([rect(1,1,i)+rect(1,3,i), rect(1,1,i)], [rect(1,2,i)+rect(1,4,i), rect(1,2,i)+rect(1,4,i)], 'Color', 'r', 'LineWidth', 2);
    plot([rect(1,1,i)+rect(1,3,i), rect(1,1,i)+rect(1,3,i)], [rect(1,2,i)+rect(1,4,i), rect(1,2,i)], 'Color', 'r', 'LineWidth', 2);

    htext = text(rect(1,1,i) + rect(1,3,i)/4, rect(1,2,i) + rect(1,4,i) + 10, num2str(avg(i)));
    set(htext, 'Color', [1 0 0]);
    set(htext, 'FontWeight', 'bold');
end
hold off;
