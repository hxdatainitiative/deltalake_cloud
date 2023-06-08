variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "glue_version" {
  type = string
}

variable "timeout" {
  type = number
}

variable "worker_type" {
  type = string
}

variable "number_of_workers" {
  type = number
}

variable "connections" {
  type = string
}

variable "python_version" {
  type = number
}

variable "script_location" {
  type = string
}

variable "max_concurrent_runs" {
  type = number
}

variable "runtime_arguments" {
  type = string
}