
sralist.parallel = '0';
paralist.spmversion = 'spm12';
paralist.data_type='nii'
%-spm batch templates location and full file path of subject list CSVS based on test type
paralist.template_path = '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/batchtemplates/';
%subject list
paralist.subjlist_file = {'/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_19MD_pre_without8015.csv',...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_19MD_post_without8015.csv'};
%project dir
paralist.projectdir = '/oak/stanford/groups/menon/projects/shelbyka/2017_TD_MD_mathfun/';
%individual stats output folder
paralist.stats_folder='stats_spm12_swgcar_comp_dot_2019';
paralist.condition='near_vs_far'
paralist.flexible_contrasts_output_dir='stats_spm12_swgcar_comp_dot_2019';
%list contrast file that will be pulled from each subject's folder and
%subtracted
paralist.contrastname='con_0011'
paralist.conname_suffx='post_minus_pre'

%regression file path
paralist.reg_file = [''];
%analysis type , glm, rsa etc
paralist.analysis_type = 'glm';
paralist.fmri_type = 'taskfmri';
%enter type of t-test, paired_sample, one_sample, two_sample as options
paralist.ttest_type_of_test='paired_sample'; 
%list contrast names for rsa analysis
paralist.contrastNames = {'nf_num','nf_num_neg'};
% paralist.stats_folder = 'comparisondot_swgcar_pm';
% paralist.output_folder = 'groupstats_md_pre_vs_post_compdot_ratio_swgcar';
