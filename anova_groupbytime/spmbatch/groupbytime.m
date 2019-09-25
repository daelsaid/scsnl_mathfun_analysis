% List of open inputs
% Factorial design specification: Factor matrix - cfg_entry
% Load Variables from .mat File: .mat Filename - cfg_files
% Load Variables from .mat File: Variables to load - cfg_choice
nrun = X; % enter the number of runs here
jobfile = {'/Users/yuanzh/Desktop/Sherlock/projects/daelsaid/2019_mathfun/scripts/taskfmri/groupstats/anova_group_by_time/groupbytime_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(3, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Factorial design specification: Factor matrix - cfg_entry
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Load Variables from .mat File: .mat Filename - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Load Variables from .mat File: Variables to load - cfg_choice
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
