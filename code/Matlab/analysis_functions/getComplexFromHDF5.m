function out = getComplexFromHDF5(filename,varname)

%load the data
rString = sprintf('%s_real',varname);
iString = sprintf('%s_imag',varname);

info = h5info(filename,rString);
chunkSize = info.ChunkSize;
totalSize = info.Dataspace.Size;

nElements = totalSize/chunkSize;

realPart = zeros(chunkSize,nElements);
imagPart = zeros(chunkSize,nElements);

for (cnt = 1:nElements)

    realPart(:,cnt) = h5read(filename,rString,(cnt-1)*chunkSize + 1, chunkSize);
    imagPart(:,cnt) = h5read(filename,iString,(cnt-1)*chunkSize + 1, chunkSize);

end

out = realPart + 1j*imagPart;