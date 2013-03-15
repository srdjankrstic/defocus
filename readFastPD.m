fid = fopen( 'tempinput.bin', 'rb' );
if fid == -1
	error( ['Cannot open file ' results_fname] );
end

type = 'uint32';

numpoints = fread(fid, 1, type);
numpairs = fread(fid, 1, type);
numlabels = fread(fid, 1, type);
maxiters = fread(fid, 1, type);

sum = 2 * numpoints - numpairs;
w = (sum + sqrt(double(sum*sum - 4*numpoints)))/2;
h = sum - w;

labelcosts = fread(fid, numpoints*numlabels, type);
labelcosts = reshape(labelcosts, h, w, numlabels);

pairs = fread(fid, 2*numpairs, type);
pairs = reshape(pairs, numpairs, 2);

xlabelcosts = fread(fid, numlabels*numlabels, type);
xlabelcosts = reshape(xlabelcosts, numlabels, numlabels);

edgecosts = fread(fid, numpairs, type);

fclose(fid);
