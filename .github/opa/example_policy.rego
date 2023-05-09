package main

import future.keywords.in

default allow = false

actions_to_check := {"create", "update"}

##############################
# Helper functions
##############################

# Function to fetch `resource_changes` for resources which are either getting created or updated
planned_resource_changes[resource] {
    some resource in input.resource_changes
    actions_to_check[_] in resource.change.actions
}

# Function to fetch `aws_instance` from the resources shortlisted by `planned_resource_changes`
aws_instance_resources[resource] {
    resource := planned_resource_changes[_]
    resource.type == "aws_instance"
}

##############################
# Main function
##############################

#  Allow only and only if `associate_public_ip_address` has been explicitly set to `false`
allow {
    instance := aws_instance_resources[_]
    instance.change.after.associate_public_ip_address == false
}