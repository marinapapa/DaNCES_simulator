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
## Step 2. Make sure the submodule repository of rDaNCES is 
## also in the main repository folder.

## Install the rDaNCES package from source. Alternative you can use the 
## devtools package to install it from github.
install.packages("../rDaNCES/", repos = NULL, type="source")

###########################
## Step 3. Set repositories

## Name of experiment
exp_name <- 'rdances_demo'

# Relative path to the model's executable
model_exe_path <- 'simulator\\sim_demo\\bin\\dances.exe'

# Use the subdirectory that the .exe is in as the main simulation repository
main_repo <- 'simulator\\sim_demo'

# The default configuration file to use (should  be in the folder)
config_tmp_name <- paste0(main_repo, '\\demo_config.json')

# Create folders' structure
dirs <- rDaNCES::set_up_directories(sim_name = exp_name,
                           config_name = config_tmp_name,
                           model_exe = model_exe_path,
                           main_path =  main_repo
)
## New folders should be created to host the generated configs and
## parameter space tracking.


##################################
## Step 4. Check model run
## Try to run the model with the default config.
## The results should be stored in a sim_data folder.

## Interactive mode with GUI:
shell(paste0(dirs$MODEL_RUN_DIR,
             ' config=', 
             config_tmp_name  
             ))


######################################
## Step 5. Prepare for all simulations
## Create configuration files across the parameter space

### Parameter values
N <- c(10, 20, 50) # group size

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


#############################################
## Step 7. Load the data from the simulations
## Store them in a list of dataframes.

## The data are stored in a sim_data folder in 
## the main repository, in a folder named after
## the experiment. 

sim_data <- rDaNCES::import_base_data('sim_data/rdances_demo/20256231235481750674948780/',
                                      types = c('self'))

head(sim_data$self) ## the individual timeseries 
## the other elements of the list are the config
## and a simulation information list:
head(sim_data$sim_info)


## We can then import all the data from the simulations we run:
sim_data <- rDaNCES::import_multi_data('sim_data/rdances_demo/',
                                      types = c('self'))

## Now each element of the list is a simulation list as before
head(sim_data[[1]]$self) 

## To merge together results with the same configuration (parameter file)

sim_data <- rDaNCES::accum_sim_data(sim_data)

## Now each element of the list is a set with repetitions, with the 
## individual simulation ids (and how many runs) included in the 
## information file:
sim_data[[1]]$sim_info
