function [ output_args ] = attendance_alg_1( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    clear
    close all
    % this is where you stored images from classroom 
    load('variable.mat');
    image_dir = '/Users/nikitlonari/Desktop/violajones';

    files = dir(image_dir);
    files = files(4:end);

    number_of_files = size(files,1);

    % Initialize the Viola-Jones detector object
    faceDetector = vision.CascadeObjectDetector;
    %faceDetector.MinSize = [100 100];
    attendance = [20,2];
    attendance(20,1) = 0000;
    attendance(20,2) = 0;

    for i = 1:size(folder_matrix)
        attendance(i,1) = folder_matrix(i,1);
        attendance(i,2) = 0;
    end

    for file_count = 1:number_of_files
        filename = files(file_count).name;
        filename_full = fullfile(image_dir,filename);
    
        % read image
        I = imread(filename_full);
    
        % Find faces using Viola-Jones object, bboxes contains the rectangles
        % contain detected face images
        bboxes = step(faceDetector, I);
    
        %add rectangles on image for illustration
        %IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
        %figure(1), imshow(IFaces), title('Detected faces');
    
        % Here, extracted faces are stored in variable face_cropped and are
        % shown in a separate figure
        %figure(2); clf;
        for i = 1:size(bboxes,1)
            left = bboxes(i,1);
            up = bboxes(i,2);
            width = bboxes(i,3);
            height = bboxes(i,4);
        
            face_cropped = I(up:up+height,left:left+width,:);
            %face_cropped = I(up:100,left:100,:);
            face_cropped_resize = imresize(face_cropped,[100 100]);
            gray_image = im2double(face_cropped_resize);
            p = rgb2gray(gray_image);
            w(:,i) = p(:);
            new_phi = w(:,i)-mean_image;
            new_image_weight = Eig_faces'*new_phi;
            for j=1:n
                %M_distance(1,j) = sqrt((new_image_weight(:,1).^2) + ((weight_for_train_image(:,j).^2)));
                M_distance(1,j) = sqrt((new_image_weight(:,1)-weight_for_train_image(:,j))'*C'*(new_image_weight(:,1)-weight_for_train_image(:,j)));
            end
            [minimum_distance, column_no] = min(M_distance(1,:));
            threshold = 82;
            if minimum_distance<threshold
                if column_no>=1 && column_no<=100
                    classID = 0049;
                elseif column_no>100 && column_no<=150
                    classID = 4826;
                elseif column_no>150 && column_no<=250
                    classID = 5494;
                elseif column_no>250 && column_no<=350
                    classID = 6077;
                elseif column_no>350 && column_no<=450
                    classID = 8271;
                elseif column_no>450 && column_no<=550
                    classID = 8798;
                elseif column_no>550 && column_no<=650
                    classID = 9025;
                elseif column_no>650 && column_no<=750
                    classID = 9077;
                elseif column_no>750 && column_no<=850
                    classID = 9078;
                elseif column_no>850 && column_no<=950
                    classID = 9120;
                elseif column_no>950 && column_no<=1050
                    classID = 9885;
                elseif column_no>1050 && column_no<=1150
                    classID = 0482;
                elseif column_no>1150 && column_no<=1250
                    classID = 0587;
                elseif column_no>1250 && column_no<=1350
                    classID = 0788;
                elseif column_no>1350 && column_no<=1450
                    classID = 1297;
                elseif column_no>1450 && column_no<=1550
                    classID = 1512 ;
                elseif column_no>1550 && column_no<=1650
                    classID = 1844;
                elseif column_no>1650 && column_no<=1750
                    classID = 2710;
                elseif column_no>1750 && column_no<=1850
                    classID = 3213;
                end
            %elseif minimum_distance>threshold && minimum_distance<150 %non_face
            %    classID = 20;
            else
                classID = 0000;
            end
            %classID_array(i,1) = classID;
            %classID_num = str2double(classID);
            for ii = 1:size(attendance)
                if attendance(ii,1)  == classID
                    attendance(ii,2) = 1;
                    break;
               
                end
            end
    
            %if i < 21
            %   figure(2); subplot(4,5,i); imshow(face_cropped);
            %end
            IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, classID);
          
            title('Detected faces');
            hold on;
    
        end   
        imshow(IFaces)
    
        %IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
        %figure(1), imshow(IFaces), title('Detected faces');
        attendance
    
    
    
    
        % click on any figure to repeat the experiment on next image in the
        % image directory
        waitforbuttonpress;
    
    
        % by calling ginput(1) on first image of one class session, you can click on your face image, it returns x
        % and y of your click. Then, you can add some code to only keep
        % detected faces located close to your face in first image for easiness 
    
    %     if file_count == 1
    %         [subject_x,subject_y] = ginput(1);
    %     end

    end


end

