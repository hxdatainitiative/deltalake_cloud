variable "name" {
  type    = string
  default = "no name"
}

variable "description" {
  type    = string
  default = "Default description"
}

variable "glue_version" {
  type    = string
  default = "4.0"
}

variable "timeout" {
  type    = number
  default = 600
}

variable "worker_type" {
  type    = string
  default = "Standard"
}

variable "number_of_workers" {
  type    = number
  default = 2
}

variable "connections" {
  type    = string
  default = ""
}

variable "python_version" {
  type    = number
  default = 3
}

variable "script_location" {
  type    = string
  default = ""
}

variable "max_concurrent_runs" {
  type    = number
  default = 1
}

variable "runtime_arguments" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = "None"
}

variable "create_job" {
  type    = bool
  default = false
}

variable "crawler_name" {
  type    = string
  default = "None"
}

variable "create_native_delta_table" {
  type    = bool
  default = true
}

variable "delta_tables_locations" {
  type    = list
  default = []
}

variable "write_manifest" {
  type    = bool
  default = false
}

locals {
  name = var.name != "no name" ? var.name : var.crawler_name
}