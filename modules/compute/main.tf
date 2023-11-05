
locals {
  ssh_allowed_users  = join(" ", var.cloud_config["ssh"].allow_users)
  ssh_allowed_groups = join(" ", var.cloud_config["ssh"].allow_groups)
}

data "template_file" "cloud_config" {
  template = file("${path.module}/templates/cloud-config.tftpl")

  vars = {
    users                 = yamlencode(var.cloud_config["users"])
    enable_ssh_pwauth     = var.cloud_config["enable_ssh_pwauth"]
    pwauth_expire_passwds = var.cloud_config["pwauth_expire_passwds"]
    chpasswd_users        = indent(4, yamlencode(var.cloud_config["chpasswd_users"]))

    timezone = var.cloud_config["timezone"]
    locale   = var.cloud_config["locale"]

    preserve_hostname         = var.cloud_config["preserve_hostname"]
    hostname                  = var.cloud_config["hostname"]
    fqdn                      = var.cloud_config["fqdn"]
    prefer_fqdn_over_hostname = var.cloud_config["prefer_fqdn_over_hostname"]
    manage_etc_hosts          = var.cloud_config["manage_etc_hosts"]

    ssh_port           = var.cloud_config["ssh"].port
    ssh_listen_address = var.cloud_config["ssh"].listen_address
    ssh_log_level      = var.cloud_config["ssh"].log_level
    ssh_allow_users    = local.ssh_allowed_users
    ssh_allow_groups   = local.ssh_allowed_groups
  }
}

data "template_cloudinit_config" "cloud_config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config.rendered
  }
}


module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  user_data                   = null
  user_data_base64            = try(data.template_cloudinit_config.cloud_config.rendered, var.defaults.user_data_base64, null)
  user_data_replace_on_change = true

  for_each = var.items

  create                               = try(each.value.create, var.defaults.create, true)
  name                                 = try(each.value.name, var.defaults.name, "")
  ami_ssm_parameter                    = try(each.value.ami_ssm_parameter, var.defaults.ami_ssm_parameter, "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2")
  ami                                  = try(each.value.ami, var.defaults.ami, null)
  ignore_ami_changes                   = try(each.value.ignore_ami_changes, var.defaults.ignore_ami_changes, false)
  associate_public_ip_address          = try(each.value.associate_public_ip_address, var.defaults.associate_public_ip_address, null)
  maintenance_options                  = try(each.value.maintenance_options, var.defaults.maintenance_options, {})
  availability_zone                    = try(each.value.availability_zone, var.defaults.availability_zone, null)
  capacity_reservation_specification   = try(each.value.capacity_reservation_specification, var.defaults.capacity_reservation_specification, {})
  cpu_credits                          = try(each.value.cpu_credits, var.defaults.cpu_credits, null)
  disable_api_termination              = try(each.value.disable_api_termination, var.defaults.disable_api_termination, null)
  ebs_block_device                     = try(each.value.ebs_block_device, var.defaults.ebs_block_device, [])
  ebs_optimized                        = try(each.value.ebs_optimized, var.defaults.ebs_optimized, null)
  enclave_options_enabled              = try(each.value.enclave_options_enabled, var.defaults.enclave_options_enabled, null)
  ephemeral_block_device               = try(each.value.ephemeral_block_device, var.defaults.ephemeral_block_device, [])
  get_password_data                    = try(each.value.get_password_data, var.defaults.get_password_data, null)
  hibernation                          = try(each.value.hibernation, var.defaults.hibernation, null)
  host_id                              = try(each.value.host_id, var.defaults.host_id, null)
  iam_instance_profile                 = try(each.value.iam_instance_profile, var.defaults.iam_instance_profile, null)
  instance_initiated_shutdown_behavior = try(each.value.instance_initiated_shutdown_behavior, var.defaults.instance_initiated_shutdown_behavior, null)
  instance_type                        = try(each.value.instance_type, var.defaults.instance_type, "t3.micro")
  instance_tags                        = try(each.value.instance_tags, var.defaults.instance_tags, {})
  ipv6_address_count                   = try(each.value.ipv6_address_count, var.defaults.ipv6_address_count, null)
  ipv6_addresses                       = try(each.value.ipv6_addresses, var.defaults.ipv6_addresses, null)
  key_name                             = try(each.value.key_name, var.defaults.key_name, null)
  launch_template                      = try(each.value.launch_template, var.defaults.launch_template, {})
  metadata_options = try(each.value.metadata_options, var.defaults.metadata_options, {
    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 1
    "http_tokens"                 = "optional"
  })
  monitoring                          = try(each.value.monitoring, var.defaults.monitoring, null)
  network_interface                   = try(each.value.network_interface, var.defaults.network_interface, [])
  placement_group                     = try(each.value.placement_group, var.defaults.placement_group, null)
  private_ip                          = try(each.value.private_ip, var.defaults.private_ip, null)
  root_block_device                   = try(each.value.root_block_device, var.defaults.root_block_device, [])
  secondary_private_ips               = try(each.value.secondary_private_ips, var.defaults.secondary_private_ips, null)
  source_dest_check                   = try(each.value.source_dest_check, var.defaults.source_dest_check, null)
  subnet_id                           = try(each.value.subnet_id, var.defaults.subnet_id, null)
  tags                                = try(each.value.tags, var.defaults.tags, {})
  tenancy                             = try(each.value.tenancy, var.defaults.tenancy, null)
  volume_tags                         = try(each.value.volume_tags, var.defaults.volume_tags, {})
  enable_volume_tags                  = try(each.value.enable_volume_tags, var.defaults.enable_volume_tags, true)
  vpc_security_group_ids              = try(each.value.vpc_security_group_ids, var.defaults.vpc_security_group_ids, null)
  timeouts                            = try(each.value.timeouts, var.defaults.timeouts, {})
  cpu_options                         = try(each.value.cpu_options, var.defaults.cpu_options, {})
  cpu_core_count                      = try(each.value.cpu_core_count, var.defaults.cpu_core_count, null)
  cpu_threads_per_core                = try(each.value.cpu_threads_per_core, var.defaults.cpu_threads_per_core, null)
  create_spot_instance                = try(each.value.create_spot_instance, var.defaults.create_spot_instance, false)
  spot_price                          = try(each.value.spot_price, var.defaults.spot_price, null)
  spot_wait_for_fulfillment           = try(each.value.spot_wait_for_fulfillment, var.defaults.spot_wait_for_fulfillment, null)
  spot_type                           = try(each.value.spot_type, var.defaults.spot_type, null)
  spot_launch_group                   = try(each.value.spot_launch_group, var.defaults.spot_launch_group, null)
  spot_block_duration_minutes         = try(each.value.spot_block_duration_minutes, var.defaults.spot_block_duration_minutes, null)
  spot_instance_interruption_behavior = try(each.value.spot_instance_interruption_behavior, var.defaults.spot_instance_interruption_behavior, null)
  spot_valid_until                    = try(each.value.spot_valid_until, var.defaults.spot_valid_until, null)
  spot_valid_from                     = try(each.value.spot_valid_from, var.defaults.spot_valid_from, null)
  disable_api_stop                    = try(each.value.disable_api_stop, var.defaults.disable_api_stop, null)
  putin_khuylo                        = try(each.value.putin_khuylo, var.defaults.putin_khuylo, true)
  create_iam_instance_profile         = try(each.value.create_iam_instance_profile, var.defaults.create_iam_instance_profile, false)
  iam_role_name                       = try(each.value.iam_role_name, var.defaults.iam_role_name, null)
  iam_role_use_name_prefix            = try(each.value.iam_role_use_name_prefix, var.defaults.iam_role_use_name_prefix, true)
  iam_role_path                       = try(each.value.iam_role_path, var.defaults.iam_role_path, null)
  iam_role_description                = try(each.value.iam_role_description, var.defaults.iam_role_description, null)
  iam_role_permissions_boundary       = try(each.value.iam_role_permissions_boundary, var.defaults.iam_role_permissions_boundary, null)
  iam_role_policies                   = try(each.value.iam_role_policies, var.defaults.iam_role_policies, {})
  iam_role_tags                       = try(each.value.iam_role_tags, var.defaults.iam_role_tags, {})
}
