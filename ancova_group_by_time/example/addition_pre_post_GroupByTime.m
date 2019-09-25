% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/oak/stanford/groups/menon/projects/lchen32/2018_MathFUN_mindset/scripts/taskfmri/groupstats/Pre_Post/Group_by_Time/addition_pre_post_Tut_GroupByTime_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
