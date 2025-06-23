##########################################
## This R file can help you start running 
## DaNCES simulations from R.

###############
## Prerequests

#install.packages("devtools")

###################################################
## Step 1. Copy paste your model's executable in the
## simulator folder as in the example or the downloaded 
## bin folder of a Release: https://github.com/marinapapa/DaNCES_framework/releases

####################################################
## Step 2. Clone the submodule repository of rDaNCES 
## here 

## Build the rDaNCES package
devtools::build("rDaNCES")

###########################
## Step 3. Set repositories

## Name of experiment
exp_name <- 'rdances_demo'

# Relative path to the model's executable
model_exe_path <- '..\\Simulation\\sim_demo\\dances.exe'

# Use the subdirectory that the .exe is in as the main simulation repository
main_repo <- dirname(model_exe_path)

# The default configuration file to use (should  be in the folder)
config_tmp_name <- paste0(main_repo, '/demo_config.json')

# Create folders' structure
dirs <- rDaNCES::set_up_directories(sim_name = exp_name,
                           config_name = config_tmp_name,
                           model_exe = model_exe_path,
                           main_path =  main_repo
)

##################################
## Step 4. Check model sun
## Try to run the model with the default config.
## The results should be stored in a sim_data folder.

shell(paste0(dirs$MODEL_RUN_DIR,
             ' config=', 
             config_tmp_name  
             ))


######################################
## Step 5. Prepare for all simulations
## Create configuration files across the parameter space

### Parameter values
N <- c(10, 50, 100, 500, 1000) # group size

# Number of repetitions of each parameter set:
reps <- 2

## Set up parameter combinations
param_set <- rDaNCES::construct_ParamSets(
  N = N, 
  output_folder = exp_name
)

## Create configuration files
rDaNCES::set_up_simulations(param_set, dirs)
print(paste0('We will run ', 
             length(list.files(dirs$EXP_CONFIGS_PATH)) * reps,
             ' simulations.'))

######################################
## Step 6. Prepare for all simulations
## Run all simulations

rDaNCES::run_simulations(dirs, reps)
