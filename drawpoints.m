figure;
imshow(im);
hold on;
for i = 1:size(relx)
    plot(relx(i), rely(i), 'rx', 'MarkerSize', 8, 'LineWidth', 2);
    htext = text(relx(i) + 5, rely(i), strcat(strcat(num2str(i), ':'), num2str(d(round(rely(i)), round(relx(i))))));
    set(htext, 'Color', [1 0 0]);
    set(htext, 'FontWeight', 'bold');
end
hold off;
