# Terraform template for initial projects

This repo is meant to hold the basic scaffolding for AWS projects in Hexacta

## Content
 * input
    * data    = information coming from already implemented repos
    * locals  = Custom constant information 
    * vars    = Dynamic variables
 * Providers  = Default tags to use and fill
 * Main       = Base code to declare resources
 * Output     = Output variables returning from resources declared
 * vars       = Location for .tfvars that can change depending on the environment

## Usage
The repo is restricted only to devops team to change. If a change is required, please fill a ticket 
through TFS with your request specifying this repo.

When starting a new project, fork this repository to the desired location and start your work there.