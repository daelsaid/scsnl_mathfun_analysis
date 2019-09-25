% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/oak/stanford/groups/menon/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/anova_group_by_time/spmbatch/groupbytime_designspec_wmodel_estimation_batch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
