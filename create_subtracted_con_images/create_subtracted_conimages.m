function subtract_contrast_images(Config_File);
 
% Show the system information and write log files
warning('off', 'MATLAB:FINITE:obsoleteFunction');
disp(['Current directory is: ',pwd]);
disp('------------------------------------------------------------------');
currentdir = pwd;

Config_File = strtrim(Config_File);
if(exist(Config_File,'file')==0)
    fprintf('Cannot find the configuration file ... \n');
end
Config_File = strtrim(Config_File);
[ConfigFilePath, Config_File, ConfigFileExt] = fileparts(Config_File); 
eval(Config_File); 
clear Config_File;

% container
addpath('/oak/stanford/groups/menon/projects/shelbyka/2017_TD_MD_mathfun/results/taskfmri/participants');
addpath(genpath('/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun'));

spm_version             = strtrim(paralist.spmversion);
software_path           = '/oak/stanford/groups/menon/toolboxes/';
spm_path                = fullfile(software_path, spm_version);
% spmgpstatsscript_path   = ['/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/glmActivation/groupStats/' spm_version];
spmgpstatsscript_path   = '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/batchtemplates/';

sprintf('adding SPM path: %s\n', spm_path); addpath(genpath(spm_path));
sprintf('adding SPM based group stats scripts path: %s\n', spmgpstatsscript_path); addpath(genpath(spmgpstatsscript_path));

%% Parameters
% -------------------------------------------------------------------------
% Read in parameters
% -------------------------------------------------------------------------

subjlist_file    = strtrim(paralist.subjlist_file);
project_dir      = strtrim(paralist.projectdir);
stats_folder     = strtrim(paralist.stats_folder);
% output_folder    = strtrim(paralist.output_folder);
% reg_file         = strtrim(paralist.reg_file);
analysis_type    = strtrim(paralist.analysis_type);
fmri_type        = strtrim(paralist.fmri_type);
template_path    = strtrim(paralist.template_path);
spm_version      = strtrim(paralist.spmversion);
type_of_test     = strtrim(paralist.ttest_type_of_test);

switch type_of_test
    case 'single_sample'
        onegroup=1;twogroup=0;paired=0;
    case 'two_sample'
        onegroup=0; twogroup=1;paired=0;
    case 'paired_sample'
        onegroup=0; twogroup=0;paired=1;
        data_type       = strtrim(paralist.data_type)
        contrastname    = strtrim(paralist.contrastname)
        conname_suffx   = strtrim(paralist.conname_suffx)
  
        flexible_contrasts_output_dir= strtrim(paralist.flexible_contrasts_output_dir)
        flexible_contrasts_condition=strtrim(paralist.condition);
    otherwise
        error('')
end

switch analysis_type
    case 'rsa'
        rsa=1; glm=0; load_contrasts=0;
        basename_rsa=['rsa_zscore.nii,1'];
        contrastNames    = strtrim(paralist.contrastNames);
    case 'glm'
        rsa=0;glm=1;load_contrasts=1;
    otherwise
        error('')
end

disp('-------------- Contents of the Parameter List --------------------'); disp(paralist);
disp('------------------------------------------------------------------'); clear paralist;


%% Load subject list & set patths

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
numgroup     = length(subjlist_file);
subjects1 = csvread(subjlist_file{1},1,0); subjects1
numsubg1 = size(subjects1,1); numsubg1
sub_stats1 = cell(numsubg1,1);
main_subj_dir1=cell(numsubg1,1);

if onegroup
    batchfile   = 'batch_1group.mat';
elseif twogroup
    subjects2 = csvread(subjlist_file{2},1,0);
    batchfile   = 'batch_2group.mat';
    numsubg2 = size(subjects2,1);
    sub_stats2 = cell(numsubg2,1);
elseif paired
    subjects2 = csvread(subjlist_file{2},1,0);
    batchfile   = 'batch_group_paired_t.mat';
    numsubg2 = size(subjects2,1);
    substats_flex_contrasts_dir='flexible_contrasts';
    flexible_contrasts_output_name=[contrastname,'_', flexible_contrasts_condition '_post_minus_pre.nii'];
    main_subj_dir2=cell(numsubg2,1)
    sub_stats2 = cell(numsubg2,1);
else
    disp('error')
end

for subcnt1 = 1:numsubg1
    subject = subjects1(subcnt1);
    subject = char(pad(string(subject),4,'left','0'));
    fprintf('subjects1(subcnt1): %s \n',subject);
    visit   = num2str(subjects1(subcnt1,2));
    session = num2str(subjects1(subcnt1,3));
    sub_stats1{subcnt1,1} = fullfile(project_dir, 'results', fmri_type, 'participants', ...
        subject, ['visit',visit],['session',session], analysis_type, ...
        ['stats_', spm_version], stats_folder);
    if paired
        main_subj_dir1{subcnt1} = fullfile(project_dir, 'results', fmri_type, 'participants',subject);
        substats_con_outdir1{subcnt1}=fullfile(main_subj_dir1{subcnt1},substats_flex_contrasts_dir,stats_folder);
        substats_contrast_output_nii1=fullfile(project_dir, 'results', fmri_type, 'participants', ...
            subject,substats_flex_contrasts_dir,stats_folder, flexible_contrasts_output_name);
    end
end

for subcnt2 = 1:numsubg2
    subject = subjects2(subcnt2);
    subject = char(pad(string(subject),4,'left','0'));
    visit   = num2str(subjects2(subcnt2,2));
    session = num2str(subjects2(subcnt2,3));
    sub_stats2{subcnt2,1} = fullfile(project_dir, 'results', fmri_type, 'participants', ...
        subject, ['visit',visit],['session',session], analysis_type, ...
        ['stats_', spm_version], stats_folder);
    if paired
        main_subj_dir2{subcnt2} = fullfile(project_dir, 'results', fmri_type, 'participants',subject);
        substats_con_outdir{subcnt2} = fullfile(main_subj_dir2{subcnt2},substats_flex_contrasts_dir,stats_folder);
        substats_contrast_output_nii2 = fullfile(project_dir, 'results', fmri_type, 'participants', ...
            subject,substats_flex_contrasts_dir,stats_folder,flexible_contrasts_output_name);
    end
end


%% create subtracted constrast images
for subj=1:numsubg1
    if ~exist((substats_con_outdir1{length(numsubg1),subj}),'dir')
        mkdir(substats_con_outdir1{length(numsubg1),subj});
    else
        continue
        
    dir=fullfile(substats_con_outdir1{length(numsubg1),subj});
    cd(dir);
    
    %set contrast image paths 
    img1=[sub_stats1{subj,1},['/',contrastname, data_type]];
    img2=[sub_stats2{subj,1},['/',contrastname, data_type]];
    
    %subtract img2 from img1
    spm_imcalc_ui([img1;img2] ,flexible_contrasts_output_name, 'i2-i1')
end

fprintf('Changing back to the directory: %s \n', currentdir);
cd(currentdir);
delete(get(0,'Children')); clear all; close all;
end

