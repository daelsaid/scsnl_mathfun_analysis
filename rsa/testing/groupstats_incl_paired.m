% This script performs 1 group or 2 group fMRI analysis
% It first loads configuration file containing groupstats parameters
% This group-stats scripts are compatible with both Analyze and NIFTI formats
% To use either format, change the data type in groupStats_config.m.template
%-add warning message for two group stats with covariates, currently not
% supported yet to avoid confusion. - Tianwen, 12/11/2014
%
% To run group analysis: type at Matlab command line:
% >> groupstats('groupstats_config.m')
%
% _________________________________________________________________________
% 2009-2010 Stanford Cognitive and Systems Neuroscience Laboratory
%d
% $Id tianwen chen: groupstats.m 2010-01-02
% $Id Rui Yuan, 2018-02-12,
% $ID daelsaid: 20190726 added functionality to run paired t-test
% -------------------------------------------------------------------------
clear all;
% group_paired_status=1
Config_File='/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/scripts/config_scripts/td_pre_vs_post_compnum_ratio_groupstats_config_swgcar.m'
% Config_File=('/Volumes/menon/projects/daelsaid/2019_mathfun/scripts/config_scripts/local_md_pre_vs_post_compdot_ratio_groupstats_config_swgcar.m')

%function groupstats(Config_File)

% Show the system information and write log files
warning('off', 'MATLAB:FINITE:obsoleteFunction')
c     = fix(clock);
disp('==================================================================');
fprintf('fMRI GroupAnalysis start at %d/%02d/%02d %02d:%02d:%02d\n',c);
disp('==================================================================');


% fname = sprintf('groupanalysis-%d_%02d_%02d-%02d_%02d_%02.0f.log',c);
% diary(fname);
disp(['Current directory is: ',pwd]);
disp('------------------------------------------------------------------');
currentdir = pwd;

% -------------------------------------------------------------------------
% Check group analysis configuration and load it if it exists
% -------------------------------------------------------------------------
Config_File = strtrim(Config_File);
if(exist(Config_File,'file')==0)
    fprintf('Cannot find the configuration file ... \n');
    diary off;
end

[ConfigFilePath, Config_File, ConfigFileExt] = fileparts(Config_File);

%Config_File = Config_File(1:end-2);
eval(Config_File);
clear Config_File;

% container
spm_version             = strtrim(paralist.spmversion);
software_path           = '/oak/stanford/groups/menon/toolboxes/';
%software_path           = '/Volumes/menon/toolboxes/';

spm_path                = fullfile(software_path, spm_version);
%spmgpstatsscript_path   = ['/Volumes/menon/scsnlscripts/brainImaging/mri/fmri/glmActivation/groupStats/' spm_version];
%%spmgpstatsscript_path   = ['/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/glmActivation/groupStats/' spm_version];

spmgpstatsscript_path   = '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/batchtemplates/';
% spmgpstatsscript_path   = '/Volumes/menon/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/batchtemplates/';

sprintf('adding SPM path: %s\n', spm_path);
addpath(genpath(spm_path));
sprintf('adding SPM based group stats scripts path: %s\n', spmgpstatsscript_path);
addpath(genpath(spmgpstatsscript_path));

% -------------------------------------------------------------------------
% Read in parameters
% -------------------------------------------------------------------------

subjlist_file    = strtrim(paralist.subjlist_file);
project_dir      = strtrim(paralist.projectdir);
stats_folder     = strtrim(paralist.stats_folder);
output_folder    = strtrim(paralist.output_folder);
reg_file         = strtrim(paralist.reg_file);
analysis_type    = strtrim(paralist.analysis_type);
fmri_type        = strtrim(paralist.fmri_type);
template_path    = strtrim(paralist.template_path);
spm_version      = strtrim(paralist.spmversion);
group_paired_t   = strtrim(paralist.group_paired_status);


% spm version
% software_path    = '/Volumes/menon/software/';
software_path    = '/oak/stanford/groups/menon/software/';
spm_path         = fullfile(software_path, spm_version);
% add spm path
sprintf('adding SPM path: %s\n', spm_path);
addpath(genpath(spm_path));


disp('-------------- Contents of the Parameter List --------------------');
disp(paralist);
disp('------------------------------------------------------------------');
clear paralist;


% -------------------------------------------------------------------------
% Check folder and file
% -------------------------------------------------------------------------

if ~exist(template_path,'dir')
    disp('Template folder does not exist!');
end

numgroup     = length(subjlist_file);

if(numgroup > 2)
    disp('Maximum number of groups should only be TWO');
    %   diary off;
    return;
end

if(exist(subjlist_file{1}, 'file') == 0)
    fprintf('File does not exist: %s\n', subjlist_file{1});
    %   diary off;
    return;
end

if(numgroup == 2)
    if(exist(subjlist_file{2}, 'file') == 0)
        fprintf('File does not exist: %s\n', subjlist_file{2});
        %     diary off;
        return;
    end
end

% -------------------------------------------------------------------------
% Check covariate of interest
% -------------------------------------------------------------------------
if ~isempty(reg_file)
    if(numgroup == 2)
        fprintf('Covariate is not supported for two group stats\n');
        %     diary off;
        return;
    end
    numreg = length(reg_file);
    for i = 1:numreg
        if ~exist(reg_file{i}, 'file')
            fprintf('Covariates file does not exist: %s\n', reg_file{i});
            %       diary off;
            return;
        end
    end
    if(numgroup == 1)
        reg_names = cell(numreg,1);
        for i = 1:numreg
            [a b c d e] = regexpi(reg_file{i}, '(\w+)\.\w+$');
            reg_names{i} = e{1}{1};
            reg_file{i} = fullfile(currentdir,reg_file{i});
        end
        reg_vec = 1;
    end
else
    reg_vec = [];
end

% Initialize the batch system
spm_jobman('initcfg');
delete(get(0,'Children'));

% -------------------------------------------------------------------------
% Load subject list, constrast file and batchfile
% -------------------------------------------------------------------------

if(group_paired_t == 1)
    subjects1 = csvread(subjlist_file{1},1,0);
    subjects2 = csvread(subjlist_file{2},1,0);
    batchfile   = 'batch_group_paired_t.mat';
    numsubg1 = size(subjects1,1);
    numsubg2 = size(subjects2,1);
    sub_stats1 = cell(numsubg1,1);
    sub_stats2 = cell(numsubg2,1);
else
    subjects1 = csvread(subjlist_file{1},1,0);
    batchfile   = 'batch_1group.mat';
    numsubg1 = size(subjects1,1);

    if(numgroup == 2)
        subjects2 = csvread(subjlist_file{2},1,0);
        batchfile   = 'batch_2group.mat';
        numsubg2 = size(subjects2,1);
    end

    sub_stats1 = cell(numsubg1,1);
    if numgroup == 2
        sub_stats2 = cell(numsubg2,1);
    end
end

% path for individualstats
for subcnt1 = 1:numsubg1
    subject = subjects1(subcnt1);
    subject = char(pad(string(subject),4,'left','0'));
    fprintf('subjects1(subcnt1): %s \n',subject);
    visit   = num2str(subjects1(subcnt1,2));
    session = num2str(subjects1(subcnt1,3));
    sub_stats1{subcnt1,1} = fullfile(project_dir, 'results', fmri_type, 'participants', ...
        subject, ['visit',visit],['session',session], analysis_type, ...
        ['stats_', spm_version], stats_folder);
end
if numgroup == 2
    for subcnt2 = 1:numsubg2
        subject = subjects2(subcnt2);
        subject = char(pad(string(subject),4,'left','0'));
        visit   = num2str(subjects2(subcnt2,2));
        session = num2str(subjects2(subcnt2,3));
        sub_stats2{subcnt2,1} = fullfile(project_dir, 'results', fmri_type, 'participants', ...
            subject, ['visit',visit],['session',session], analysis_type, ...
            ['stats_', spm_version], stats_folder);
    end
end

contrastfile = fullfile(sub_stats1{1}, 'contrasts.mat');
load(contrastfile);

output_path = fullfile(project_dir, 'results', fmri_type, 'groupstats', ...
    analysis_type, [output_folder,'_', spm_version]);
mkdir(output_path);

cd (output_path);

for i = 1:2:numTContrasts
    i
    conNum = sprintf('%03d', i);
    conName = contrastNames{i};

    if numTContrasts == 1
        invName = ['-', contrastNames{i}];
    else
        invName = contrastNames{i+1};
    end

    dirName = fullfile(pwd, [conNum 'T_' conName]);
    mkdir(dirName);
    cd(dirName);

    if exist('SPM.mat', 'file')
        disp('The stats directory contains SPM.mat. It will be deleted.');
        disp('-----------------------------------------------------------')
        % unix('/bin/rm -rf *');
        %delete *.mat;
    end

    load(fullfile(template_path,batchfile));
    if ~isempty(reg_vec)
        for j = 1:numreg
            regs = load(reg_file{j});
            matlabbatch{1}.spm.stats.factorial_design.cov(j).cname = reg_names{j};
            matlabbatch{1}.spm.stats.factorial_design.cov(j).c     = regs(:,1);
            matlabbatch{1}.spm.stats.factorial_design.cov(j).iCFT  = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(j).iCC   = 1;
            clear regs;
        end
    end
    % -----------------------------------------------------------------------
    % One and Two Group Analysis
    % -----------------------------------------------------------------------

    if(group_paired_t == 0)

        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {};

        for j=1:numsubg1
            %file = fullfile(sub_stats1{j}, ['con_0' conNum '.img,1']);
            file = fullfile(sub_stats1{j}, ['con_0' conNum '.nii,1']);
            matlabbatch{1}.spm.stats.factorial_design.des.t1.scans{j,1} = file;
        end

        if isempty(reg_vec)
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = conName;
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = invName;
        else
            % x, first of contrast vector, x is 1 only if reg_vec indicates no
            % regressors of interest.

            x = ~ismember(1, reg_vec);
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [x  reg_vec];
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [x -reg_vec];
        end
    else
        % --------------------------------------------------------------------
        % Two Group Analysis
        % --------------------------------------------------------------------
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {};

        for j=1:numsubg1
            file = fullfile(sub_stats1{j}, ['con_0' conNum '.nii,1']);
            matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1{j,1} = file;
        end

        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = {};

        for j=1:numsubg2
            file = fullfile(sub_stats2{j}, ['con_0' conNum '.nii,1']);
            matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2{j,1} = file;
        end
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = ['(g1-g2)(' conName ')'];
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['(g2-g1)(' conName ')'];
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1 0];
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1 0];
    end

    % Paired T-Test
    if (group_paired_t == 1)
        subjects1
        subjects2
        
        matlabbatch{1}.spm.stats.factorial_design.des = {};
        matlabbatch{1}.spm.stats.factorial_design.des.pt.pair.scans= {};

        for j=1:numsubg1
            sub_stats1{j}
            file = fullfile(sub_stats1{j}, ['con_0' conNum '.nii,1']);
            matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(j).scans{1,1} = file;
        end

        for j=1:numsubg2
            sub_stats2{j}
            file = fullfile(sub_stats2{j}, ['con_0' conNum '.nii,1']);
            matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(j).scans{2,1} = file;
        end

        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = ['(g1-g2)(' conName ')'];
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['(g2-g1)(' conName ')'];
        matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
        matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
    end

    % SPM.mat path for factorial desgin, SPM estimation and contrast.

    matlabbatch{1}.spm.stats.factorial_design.dir = {};
    matlabbatch{1}.spm.stats.factorial_design.dir{1} = pwd;
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {};
    matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = fullfile(pwd, 'SPM.mat');
    matlabbatch{3}.spm.stats.con.spmmat = {};
    matlabbatch{3}.spm.stats.con.spmmat{1} = fullfile(pwd, 'SPM.mat');

    save(batchfile,'matlabbatch');
    spm('defaults', 'FMRI');% Run group stats batch
    spm_jobman('run', ['./' batchfile]);
    cd ../
end

fprintf('Changing back to the directory: %s \n', currentdir);
c     = fix(clock);
disp('==================================================================');
fprintf('fMRI Group Stats finished at %d/%02d/%02d %02d:%02d:%02d \n',c);
disp('==================================================================');
cd(currentdir);
% diary off;
delete(get(0,'Children'));
clear all;
close all;
