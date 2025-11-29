# Clean-Up-Crew

Clean up crew is a video game

# Rules 

## Wirting Style 

### Code 

Each variables are clearly named, their name shall be clear and understandable, so that it is easier for someone else to be read to understand. 

~~object = ...~~
object_in_view : RigidBody3D = ...

Each variables are named using the the following style : 

i_am_a_function

All in lower case and with a '_' separating each word 

In the case of a global variable then it is preferable to name it in full caps like : 

I_AM_A_GLOBAL_VARIABLE

Functions respect a similar naming convention. It is preferable for the inputs of a function and what it is supposed to returned be typed. A short explaination of what the function does is also preferable 

### Folders

Each folders are named following the camelcase convention A.E : 

IAmFolder
FolderingIsMyJob
FolderIAmAFolder

Each file resides in their specific folders.

### Files

Each files start with their first letter capitalized, and each word being seperated with '_' like : 

I_am_a_file
Filing_is_my_job

## Git Organization 

### Branches 

Each new functions shall be developped into their specific branches, and then merged into the main, only when they are in a viable, reliable state. The main representes the current version of the game, so no half baked, un-tested updates are supposed to end up in there. 

### Commits 

Each commits should start with the naming of the branch it is done in. A boiled down version of what was done in said commit. And then a short description of the job that was done. Like : 
--Branch name----job done------short description------
Combat system - added recoil "Now shooting a weapon does blablabla..."

Do not commit everything you do. Except in the case of hot fixes / bug correction then just wait until you've done a substential amount of work. It makes it easier to track everything that's going on 

