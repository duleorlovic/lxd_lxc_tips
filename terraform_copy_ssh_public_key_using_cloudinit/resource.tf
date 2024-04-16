resource "lxd_instance" "example" {
  name     = "example-container"
  image    = "ubuntu-daily:22.04"
  # TF_VAR_created_by=$(whoami)@$(hostname):$(pwd)" terraform plan
  description = "created_by ${var.created_by}"

  config = {
    # test connection with:
    # ssh ubuntu@"$(get_container_ip example-container)" cat .ssh/authorized_keys
    "cloud-init.user-data" = <<-EOF
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}
EOF
  }
}
