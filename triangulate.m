load picked.mat
load Calib_Results.mat

for i = 1:30
    [s(i).ThreeDL, s(i).ThreeDR] = stereo_triangulation([s(i).pts1(:,1)'; s(i).pts1(:,2)'], [s(i).pts2(:,1)'; s(i).pts2(:,2)'], om, T, fc_left, cc_left, kc_left, alpha_c_left, fc_right, cc_right, kc_right, alpha_c_right);
end
