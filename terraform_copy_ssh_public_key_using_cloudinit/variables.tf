variable "created_by" {
    type        = string
    description = <<-HERE_DOC
      Username and path of the person who applied this configuration.
      Run terraform with with variable:

        TF_VAR_created_by=$(whoami)@$(hostname):$(pwd)" terraform plan

      so later you can see the description of resource:

        lxc config show example-container | grep description:

    HERE_DOC
    default = "Not Defined"
}
