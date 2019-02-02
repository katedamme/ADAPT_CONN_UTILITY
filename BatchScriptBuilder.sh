!# /bin/tcsh
### CONN BATCH Script Builder
#### By KSF Damme 2019
####  
####  The following script takes a subject list and looks for ROI masks to make a CONN batch script. PLEASE READ ALL OF THE INSTRUCTIONS BEFORE RUNNING THE SCRIPT
####   How to use this script:
####    1. Make a folder on the ADAPT Mac (/Users/adaptprogram/Documents/frontalsub/rest) for your analyses
####    2. In your analyses folder:
####         a. make a list of the IDs that you would like to process (it should be a text file where the subject ids are a new line with no header line) call that file "subj.txt" - make sure there are no extra lines at the bottom
####         b. Copy this file into the analyses folder and before running the script 
####         c. IF YOU ARE DOING AN ROI ANALYSES: make a folder called "ROI" (NOTE: CONN requires these to be in .nii format); update the names and dimensions below
####         d. IF YOU ARE NOT DOING ROI ANALYSES: comment out the ROI section below
####    3. OPTIONAL:
####         a. IF YOU ARE USING TASK CONDITIONS: you will also need to go through and update the number sessions (LOOK for "MULTIPLE CONDITIONS") in the script below to activate the script portions uncomment the line by deleting the # before the session loop; in the analyses folder put a separate text files for each consition that has the onset times for the condition the text file should have the subject number conditions then name of the condition and the session number (e.g., ${subj}_Other.Onset_MR${session}.txt); 
####    4. OUTPUT: if the task runs properly there should be a Batch.m file in your analyses folder that you can run in MATLAB and a folder "batch_files" with all of the text sections (e.g. structurals, condition set up)
#### When the above is done run the script from the terminal by setting the environment to tcsh and then ./BatchScriptBuilder.sh
####         

#### Creates text file sections and texts  ####
#### Header section
echo "Making Headers..."
echo "clear BATCH " >>! conn_hdr.txt
echo "BATCH.filename=""'"`pwd`"/Batch.mat""'"";" >>! conn_hdr.txt
echo "BATCH.Setup.isnew=1;" >>! conn_hdr.txt
echo "BATCH.Setup.RT=2;" >>! conn_hdr.txt
echo "BATCH.Setup.acquisitiontype=1;" >>! conn_hdr.txt
echo "BATCH.Setup.analyses=[2];" >>! conn_hdr.txt
echo "BATCH.Setup.voxelmask=1;" >>! conn_hdr.txt
echo "BATCH.Setup.voxelmaskfile=fullfile(fileparts(which('spm')),'apriori','brainmask.nii');" >>! conn_hdr.txt
echo "BATCH.Setup.voxelresolution=1;" >>! conn_hdr.txt
echo "restdir=""'""/Users/adaptprogram/Documents/frontalsub/rest/data/""'"";" >>! conn_hdr.txt
echo "maskdir=""'"`pwd`"/ROI/""'"";" >>! conn_hdr.txt
echo "maskdir=""'"`pwd`"/ROI/""'"";" >>! conn_hdr.txt
echo "BATCH.Setup.nsubjects=`cat subj.txt|wc |cut -d\  -f7`;" >>! conn_hdr.txt
echo "BATCH.Setup.conditions.names={'rest'};" >>! conn_onsets.txt
echo "BATCH.Setup.covariates.names={'motion'};" >>! conn_motionoutlier.txt
echo "Headers done!"
echo 
echo "Building Subject Info..."
# Sets a subject counter variable (i)
 @ i = 1
foreach subj ( `cat subj.txt` )
	#### MULTIPLE CONDITIONS: The default is to assume REST (e.g., Rest at one time point) if you are using a task then put a # next to the line below that defines sessions to be 1 (set session = 1) and delete the # next to the session loop (foreach session...) then update the number of sessions to be equal to the number of conditions that you are analyzing (e.g., if you have to task conditions then it should read "foreach session (1 2)" or if you had three conditions it should read "foreach session (1 2 3)"
	set session = 1
	# foreach session (1 2 3)
	echo
	echo "adding ${subj}..."
	echo "subject counter: ${i}"
	echo "BATCH.Setup.structurals{${i}}{${session}}=[restdir ""'""${subj}/struc_brain_align.nii""'""];" >>! conn_stuctural.txt
	echo "BATCH.Setup.functionals{${i}}{${session}}=[restdir ""'""${subj}/filtered_align_func_data.nii""'""];" >>! conn_functional.txt
	echo "BATCH.Setup.covariates.files{1}{${i}}{${session}}=[restdir ""'""${subj}/art_regression_outliers_and_movement_filtered_align_func_data.mat'];" >>! conn_motionoutlier.txt

	#### MULTIPLE CONDITIONS: The default is to assume one session (e.g., Rest at one time point) if you are using a task then put a # next to all of the lines in the REST Section and uncomment the section below, You will need to update the two lines below to have the proper number of conditions replace the (Self Other Letter below) and update the durations there should be 1 for each monologue event  (here there were 45 s per condition and 3 45 sec blocks per scan : which is why it is 45 45 45 below)
	#echo "BATCH.Setup.conditions.names={""'""Other""'""};" >>! conn_conditions_Other.txt
	#echo "BATCH.Setup.conditions.names={""'""Self""'""};" >>! conn_conditions_Self.txt
	#echo "BATCH.Setup.conditions.names={""'""Letter""'""};" >>! conn_conditions_Letter.txt
	#echo "BATCH.Setup.conditions.onsets{1}{${i}}{${session}}=[`awk 'NR==1' ${subj}/${subj}_Self.Onset_MR${session}.txt |cut -d\  -f1` `awk 'NR==2' ${subj}/${subj}_Self.Onset_MR${session}.txt |cut -d\  -f1` `awk 'NR==3' ${subj}/${subj}_Self.Onset_MR${session}.txt |cut -d\  -f1`];" >>! conn_conditions_Self.txt
	#echo "BATCH.Setup.conditions.onsets{2}{${i}}{${session}}=[`awk 'NR==1' ${subj}/${subj}_Other.Onset_MR${session}.txt |cut -d\  -f1` `awk 'NR==2' ${subj}/${subj}_Other.Onset_MR${session}.txt |cut -d\  -f1` `awk 'NR==3' ${subj}/${subj}_Other.Onset_MR${session}.txt |cut -d\  -f1`];" >>! conn_conditions_Other.txt
	#echo "BATCH.Setup.conditions.onsets{3}{${i}}{${session}}=[`awk 'NR==1' ${subj}/${subj}_Letter.Onset_MR${session}.txt |cut -d\  -f1` `awk 'NR==2' ${subj}/${subj}_Letter.Onset_MR${session}.txt |cut -d\  -f1` `awk 'NR==3' ${subj}/${subj}_Letter.Onset_MR${session}.txt |cut -d\  -f1`];" >>! conn_conditions_Letter.txt
	#echo "BATCH.Setup.conditions.durations{1}{${i}}{${session}}=[45 45 45];" >>! conn_conditions_Self.txt
	#echo "BATCH.Setup.conditions.durations{2}{${i}}{${session}}=[45 45 45];" >>! conn_conditions_Other.txt
	#echo "BATCH.Setup.conditions.durations{3}{${i}}{${session}}=[45 45 45];" >>! conn_conditions_Letter.txt
	#end

	#### Rest Onset and Duration Section ####
	echo "BATCH.Setup.conditions.durations{1}{${i}}{${session}}=[inf];" >>! conn_durations.txt
	echo "BATCH.Setup.conditions.onsets{1}{${i}}{${session}}=[0];" >>! conn_onsets.txt

 	@ i +=1
end
echo "done!"
echo
echo "Starting ROI section... "
### ROI Section ### UPDATE THE ROIS NAMES AND DIMENSIONS
echo "BATCH.Setup.rois.names={""'""lh.Thalamus""'"",""'""lh.frontal""'"",""'""lh.occipital""'"",""'""lh.parietal""'"",""'""lh.postcentral""'"",""'""lh.precentral""'"",""'""lh.temporal""'"",""'""rh.frontal""'"",""'""rh.occipital""'"",""'""rh.parietal""'"",""'""rh.postcentral""'"",""'""rh.precentral""'"",""'""rh.temporal""'"",""'""rh.Thalamus""'""}; " >>! conn_ROI_section.txt
echo "BATCH.Setup.rois.dimensions={1,1,1,1,1,1,1,1,1,1,1,1,1,1}; " >>! conn_ROI_section.txt
@ m = 1
foreach file ( `ls ROI/*nii*| cut -d\/ -f2` )
	echo "BATCH.Setup.rois.files{${m}}=[maskdir ""'""${file}""'""];" >>! conn_ROI_section.txt
	@ m +=1
end 
echo "done."
echo "Building .m file..."
### ADDS the text files together to make the batch .M file
mkdir batch_files
cat conn_hdr.txt conn_stuctural.txt conn_functional.txt conn_ROI_section.txt conn_onsets.txt conn_durations.txt conn_motionoutlier.txt >>! Batch1Rest.m
echo "conn_batch(BATCH);" >>! Batch1Rest.m
mv conn*txt batch_files
echo "all done!"
