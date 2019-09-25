paralist.parallel = '0';
paralist.template_path = '/oak/stanford/groups/menon/scsnlscripts/brainImaging/mri/fmri/glmActivation/groupStats/spm12/batchtemplates/';
paralist.spmversion = 'spm12';
paralist.contrastNames = {'dot_near_vs_far','dot_near_vs_far_neg'};
paralist.subjlist_file = {...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_19MD_pre_without8015.csv', ...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_19MD_post_without8015.csv', ...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_21TD_pre.csv', ...
    '/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/data/subjectlist/group_21TD_post.csv'};
paralist.projectdir = '/oak/stanford/groups/menon/projects/shelbyka/2017_TD_MD_mathfun/';
paralist.stats_folder = 'comparisondot_swgcar_pm';
paralist.output_folder = 'test_anova_groupbytime_tdmd_prepost_compdot_ratio_swgcar';
paralist.reg_file = [''];
paralist.analysis_type = 'glm';
paralist.fmri_type = 'taskfmri';
paralist.ttest_type_of_test = 'two_sample';