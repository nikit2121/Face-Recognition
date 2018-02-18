start_path = uigetdir(  );  % select the folder,containing class folder.
fldrs = dir(fullfile(start_path));
n=0;
m=0;
file_counter=0;
folder_count = numel(fldrs)-3;
folder_matrix = [];
file_matrix = [];
sum = zeros(10000,1);
for ii = 1:numel( fldrs )
    if fldrs(ii).name(1) == '.'
       continue; % skip '.' and '..' assuming all other sub folders do not start with .
    end
    if ~fldrs(ii).isdir
       continue; % skip non subfolders entries
    end
    %sum = zeros(10000,1);
    m=m+1;
    filename_int = str2double(fldrs(ii).name);
    folder_matrix(m,1) = filename_int;
    subfolder = dir( fullfile(start_path, fldrs(ii).name));% list all subfolder
    for iii = 1:numel(subfolder)
        if subfolder(iii).name(1) == '.'
            continue; % skip '.' and '..' assuming all other sub folders do not start with .
        end
        if ~subfolder(iii).isdir
            continue; % skip non subfolders entries
        end
        test_folder = subfolder(iii).name;
        compare = strcmp(test_folder,'test');
        if compare == 1
            continue; % skip test folder
        end
        numberoffiles = dir( fullfile(start_path, fldrs(ii).name,subfolder(iii).name,'*.jpg'));
        for iiii = 1:numel( numberoffiles )
            n=n+1;
            iname = fullfile( start_path, fldrs(ii).name, subfolder(iii).name,numberoffiles(iiii).name ); % read image
            image = imread(iname);
            t = im2double(image);
            w = rgb2gray(t);
            iv(:,n) = w(:);
            sum = sum + iv(:,n);
         end
    end
    file_counter = file_counter+iiii;
    file_matrix(1,m) = file_counter;
end 
mean_image = sum/n;
for i=1:n
    phi(:,i) = iv(:,i)-mean_image;
end
A = phi;
C = A'*A;
[eig_vector, eig_vals] = eig(C);
eig_vals_vect = diag(eig_vals);
[sorted_eig_vals, eig_indices] = sort(eig_vals_vect,'descend');
sorted_eig_vector = zeros(n);
for i=1:n
    sorted_eig_vector(:,i) = eig_vector(:,eig_indices(i));
end
%short_sorted_eig_vector = sorted_eig_vector(1:1850,1:200);
faces = (A*sorted_eig_vector);
Eig_faces = normc(faces);
weight_for_train_image = Eig_faces'*phi;
save('variable.mat','weight_for_train_image','iv','mean_image','Eig_faces','n','C','folder_matrix','file_matrix');