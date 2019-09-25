
% Configuration file for export_spmresults.m
%
% _________________________________________________________________________
% 2009-2010 Stanford Cognitive and Systems Neuroscience Laboratory
%
% $Id: export_spmresults_config.m.template 2010-06-26 $
% LC edited 2018-11-19
% -------------------------------------------------------------------------

%-Please specify parallel or nonparallel
%-e.g. for individualstats, set to 1 (parallel)
%-for groupstats, set to 0 (nonparallel)
paralist.parallel = '0';
%-Please specify project directory
paralist.projectdir = '/oak/stanford/groups/menon/projects/shelbyka/2017_TD_MD_mathfun/results/taskfmri/groupstats/rsa/';

% Please specify the list of group stats folders
%single folder
%paralist.stats_folder_path_list = 'groupstats_ncc_sym_pre_swaor_spm12';
%list of folder names in a text file

paralist.stats_folder_path_list = 'groupstats_rsa_list.txt';


% Please specify the contrast folder name
%single folder
%paralist.contrast_folder_list = '001T_positive covariate';
%list of folder names in text file
paralist.contrast_folder_list = 'con_lists.txt';
%paralist.contrast_folder_list = '001T_dot_vs_num'
% Please specify the contrast name: 1 = pos; 2 = neg
% paralist.contrast_index = 1;
% If want to look at all contrasts:
paralist.contrast_index = [];

%provide the full path of the folder holding all groupstats results (Note the different folder structures for tasfmri or restfmri
paralist.currentdir = '/oak/stanford/groups/menon/projects/shelbyka/2017_TD_MD_mathfun/results/taskfmri/groupstats/rsa/'; 

% Please specify the mask file (full path), if no masking, leave as ''
%paralist.mask_file = '/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/masks/vbm_grey_mask.nii';
% If no mask:
paralist.mask_file = '';

% Please specify the correction method for multiple comparisons
% uncorrected: 'none'; family-wise: 'FWE'; false discovery: 'FDR'
paralist.multiple_correction = 'none';

% Please specify the p value
%paralist.pval = 0.01;
paralist.pval=0.005;

% Please specify the spatial extent threshold (in voxels)
%paralist.spatial_extent = 128;
paralist.spatial_extent = 87
% Please specify the group name for txt files
%paralist.user_input = 'p01_128vox';
paralist.user_input = 'p005_87vox'
% Please specify the number of local maxima to display
paralist.NumMax = 3;

% Please specify the distance between local maximas (in mm)
paralist.DisMax = 8;

%-SPM version, this only matters when you try to use group-averaged images as a mask
paralist.spmversion='spm12';
