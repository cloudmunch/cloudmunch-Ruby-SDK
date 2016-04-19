#!/usr/bin/ruby
###
###  (c) CloudMunch Inc.
### All Rights Reserved
### Un-authorized copying of this file, via any medium is strictly prohibited
###  Proprietary and confidential
###
###  ganesan@cloudmunch.com
###

$LOAD_PATH << '.'
 
class CloudmunchConstants
    #Assets
    STATUS_RUNNING = 'running'
    STATUS_STOPPED = 'stopped'
    STATUS_NIL = 'NIL'

    #Environments
    STATUS_RUNNING_WITH_WARNING = 'running_with_warning'
    STATUS_STOPPED_WITH_ERRORS = 'stopped_with_errors'
    STATUS_ACTION_IN_PROGRESS = 'action_in_progress'
    STATUS_CREATION_IN_PROGRESS = 'creation_in_progress'
end
