resource "lxd_instance" "example" {
  name     = "example-container"
  image    = "ubuntu-daily:22.04"

  config = {
    "user.user-data" = <<-EOF
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
