function normalized = normalize(d)
    max_d = max(d(:)); min_d = min(d(:));
    normalized = (d-min_d) / (max_d-min_d);
end
