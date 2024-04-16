resource "lxd_instance" "example" {
  name     = "example-container"
  image    = "images:ubuntu/20.04"
  profiles = ["default"]

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
