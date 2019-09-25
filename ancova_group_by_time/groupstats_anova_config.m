%%paralist.template_path = '/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/glmActivation/groupStats/spm12/batchtemplates/';

paralist.template_path='/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/batchtemplates/';'
paralist.spmversion = 'spm12';
paralist.subjlist_file = {...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_19MD_pre_without8015.csv', ...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_19MD_post_without8015.csv', ...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_21TD_pre.csv', ...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_21TD_post.csv'};
paralist.projectdir = '/oak/stanford/groups/menon/projects/shelbyka/2017_TD_MD_mathfun/';
% paralist.stats_folder = 'comparisondot_swgcar_pm';
paralist.stats_folder = 'num_7_all_near_vs_rest_VS_9_all_far_vs_rest';
paralist.contrastNames = {'nf_dot','nf_dot_neg'};
paralist.output_folder = 'anova_groupbytime_tdmd_prepost_7N_vs_9F_rsa_swgcar';
paralist.reg_file = [''];
% paralist.analysis_type = 'glm';
paralist.analysis_type = 'rsa';
paralist.fmri_type = 'taskfmri';
paralist.ttest_type_of_test = 'two_sample';
