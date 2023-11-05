# Terraform Module <img src="../resources/assets/vendor/terraform/Terraform_VerticalLogo_ColorWhite_RGB.png" width="200" align="right" />

## AWS Compute

This module manages compute instances hosted by _Amazon Inc._ making use of the configuration utility `cloud-config` to automate the initial server setup and configuration steps like hardening the SSH daemon, configuring custom DNS resolvers, isntalling packages etc. etc.

---

## 🚧 Usage

```hcl

module "aws_compute" {
  source = "./modules/vultr-private-networking"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  cloud_config = {
    hostname                  = "dummy1"
    fqdn                      = "dummy1.hollow.delta4x4.net"
    enable_ssh_pwauth         = false
    pwauth_expire_passwds     = false
    timezone                  = "UTC"
    locale                    = "en_US.UTF-8"
    preserve_hostname         = false
    prefer_fqdn_over_hostname = true
    manage_etc_hosts          = true

    users = [
      {
        name                = "mg"
        ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFq/wrfFp78IbNdlIYxo38sKFbIrst6f/7qhEajulHU6"
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        groups              = "sudo, docker"
        shell               = "/bin/bash"
      },
      {
        name                = "root"
        ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG726z3PvFunyae+KgIwhn9RQPP7U0m5DNmVHKbYnt5a"
        shell               = "/bin/bash"
      }
    ]

    chpasswd_users = [
      {
        name     = "mg"
        password = "$6$rounds=4096$mgFMJdev$Ef8.iRpzYGyreCE7cja24WyD6U3YXj/1HaEEtBkyY47UqblMTQ0k1O3Q2H7eGrt3IvTtyftanERm9ruPXOByv."
      },
      {
        name     = "root"
        password = "$6$rounds=4096$mgFMJdev$Ef8.iRpzYGyreCE7cja24WyD6U3YXj/1HaEEtBkyY47UqblMTQ0k1O3Q2H7eGrt3IvTtyftanERm9ruPXOByv."
      }
    ]
    ssh = {
      port           = 4322
      listen_address = "0.0.0.0"
      log_level      = "INFO"
      allow_users    = ["mg", "root"]
      allow_groups   = ["sudo", "root"]
    }
  }
}

```

---

### 📜 License

**[Proprietary](./LICENSE)**

### ✉ Contact

- **Admin**: Maximilian Gindorfer
- **E-Mail**: [maximilian.gindorfer@delta4x4.com](mailto:maximilian.gindorfer@delta4x4.com)
- **Mobile**: +49 8134 93020

### © Copyright

_Assets provided by:_ **[Design Barn Inc.](https://iconscout.com)**
