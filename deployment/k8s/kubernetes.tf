locals {
  bastion_autoscaling_group_ids     = ["${aws_autoscaling_group.bastions-k8s-ithaqueue-com.id}"]
  bastion_security_group_ids        = ["${aws_security_group.bastion-k8s-ithaqueue-com.id}"]
  bastions_role_arn                 = "${aws_iam_role.bastions-k8s-ithaqueue-com.arn}"
  bastions_role_name                = "${aws_iam_role.bastions-k8s-ithaqueue-com.name}"
  cluster_name                      = "k8s.ithaqueue.com"
  master_autoscaling_group_ids      = ["${aws_autoscaling_group.master-us-east-1b-masters-k8s-ithaqueue-com.id}"]
  master_security_group_ids         = ["${aws_security_group.masters-k8s-ithaqueue-com.id}"]
  masters_role_arn                  = "${aws_iam_role.masters-k8s-ithaqueue-com.arn}"
  masters_role_name                 = "${aws_iam_role.masters-k8s-ithaqueue-com.name}"
  node_autoscaling_group_ids        = ["${aws_autoscaling_group.nodes-k8s-ithaqueue-com.id}"]
  node_security_group_ids           = ["${aws_security_group.nodes-k8s-ithaqueue-com.id}"]
  node_subnet_ids                   = ["${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"]
  nodes_role_arn                    = "${aws_iam_role.nodes-k8s-ithaqueue-com.arn}"
  nodes_role_name                   = "${aws_iam_role.nodes-k8s-ithaqueue-com.name}"
  region                            = "us-east-1"
  route_table_private-us-east-1b_id = "${aws_route_table.private-us-east-1b-k8s-ithaqueue-com.id}"
  route_table_public_id             = "${aws_route_table.k8s-ithaqueue-com.id}"
  subnet_us-east-1b_id              = "${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"
  subnet_utility-us-east-1b_id      = "${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"
  vpc_id                            = "vpc-0395fe1dfe8c8e25a"
}

output "bastion_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.bastions-k8s-ithaqueue-com.id}"]
}

output "bastion_security_group_ids" {
  value = ["${aws_security_group.bastion-k8s-ithaqueue-com.id}"]
}

output "bastions_role_arn" {
  value = "${aws_iam_role.bastions-k8s-ithaqueue-com.arn}"
}

output "bastions_role_name" {
  value = "${aws_iam_role.bastions-k8s-ithaqueue-com.name}"
}

output "cluster_name" {
  value = "k8s.ithaqueue.com"
}

output "master_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.master-us-east-1b-masters-k8s-ithaqueue-com.id}"]
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-k8s-ithaqueue-com.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-k8s-ithaqueue-com.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-k8s-ithaqueue-com.name}"
}

output "node_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.nodes-k8s-ithaqueue-com.id}"]
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-k8s-ithaqueue-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-k8s-ithaqueue-com.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-k8s-ithaqueue-com.name}"
}

output "region" {
  value = "us-east-1"
}

output "route_table_private-us-east-1b_id" {
  value = "${aws_route_table.private-us-east-1b-k8s-ithaqueue-com.id}"
}

output "route_table_public_id" {
  value = "${aws_route_table.k8s-ithaqueue-com.id}"
}

output "subnet_us-east-1b_id" {
  value = "${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"
}

output "subnet_utility-us-east-1b_id" {
  value = "${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"
}

output "vpc_id" {
  value = "vpc-0395fe1dfe8c8e25a"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_attachment" "bastions-k8s-ithaqueue-com" {
  elb                    = "${aws_elb.bastion-k8s-ithaqueue-com.id}"
  autoscaling_group_name = "${aws_autoscaling_group.bastions-k8s-ithaqueue-com.id}"
}

resource "aws_autoscaling_attachment" "master-us-east-1b-masters-k8s-ithaqueue-com" {
  elb                    = "${aws_elb.api-k8s-ithaqueue-com.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-east-1b-masters-k8s-ithaqueue-com.id}"
}

resource "aws_autoscaling_group" "bastions-k8s-ithaqueue-com" {
  name                 = "bastions.k8s.ithaqueue.com"
  launch_configuration = "${aws_launch_configuration.bastions-k8s-ithaqueue-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"]

  tags = [
    {
      key                 = "KubernetesCluster"
      value               = "k8s.ithaqueue.com"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "bastions.k8s.ithaqueue.com"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
      value               = "bastions"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/role/bastion"
      value               = "1"
      propagate_at_launch = true
    },
    {
      key                 = "kops.k8s.io/instancegroup"
      value               = "bastions"
      propagate_at_launch = true
    }
  ]

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "master-us-east-1b-masters-k8s-ithaqueue-com" {
  name                 = "master-us-east-1b.masters.k8s.ithaqueue.com"
  launch_configuration = "${aws_launch_configuration.master-us-east-1b-masters-k8s-ithaqueue-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"]

  tags = [
    {
      key                 = "KubernetesCluster"
      value               = "k8s.ithaqueue.com"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "master-us-east-1b.masters.k8s.ithaqueue.com"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
      value               = "master-us-east-1b"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/role/master"
      value               = "1"
      propagate_at_launch = true
    },
    {
      key                 = "kops.k8s.io/instancegroup"
      value               = "master-us-east-1b"
      propagate_at_launch = true
    }
  ]

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-k8s-ithaqueue-com" {
  name                 = "nodes.k8s.ithaqueue.com"
  launch_configuration = "${aws_launch_configuration.nodes-k8s-ithaqueue-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"]

  tags = [
    {
      key                 = "KubernetesCluster"
      value               = "k8s.ithaqueue.com"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "nodes.k8s.ithaqueue.com"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
      value               = "nodes"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/role/node"
      value               = "1"
      propagate_at_launch = true
    },
    {
      key                 = "kops.k8s.io/instancegroup"
      value               = "nodes"
      propagate_at_launch = true
    }
  ]

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "b-etcd-events-k8s-ithaqueue-com" {
  availability_zone = "us-east-1b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "b.etcd-events.k8s.ithaqueue.com"
    "k8s.io/etcd/events"                      = "b/b"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_ebs_volume" "b-etcd-main-k8s-ithaqueue-com" {
  availability_zone = "us-east-1b"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "b.etcd-main.k8s.ithaqueue.com"
    "k8s.io/etcd/main"                        = "b/b"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_eip" "us-east-1b-k8s-ithaqueue-com" {
  vpc = true

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "us-east-1b.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_elb" "api-k8s-ithaqueue-com" {
  name = "api-k8s-ithaqueue-com-h2m16t"

  listener {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api-elb-k8s-ithaqueue-com.id}"]
  subnets         = ["${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"]

  health_check {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  cross_zone_load_balancing = false
  idle_timeout              = 300

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "api.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_elb" "bastion-k8s-ithaqueue-com" {
  name = "bastion-k8s-ithaqueue-com-tqd4c3"

  listener {
    instance_port     = 22
    instance_protocol = "TCP"
    lb_port           = 22
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.bastion-elb-k8s-ithaqueue-com.id}"]
  subnets         = ["${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"]

  health_check {
    target              = "TCP:22"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "bastion.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_iam_instance_profile" "bastions-k8s-ithaqueue-com" {
  name = "bastions.k8s.ithaqueue.com"
  role = "${aws_iam_role.bastions-k8s-ithaqueue-com.name}"
}

resource "aws_iam_instance_profile" "masters-k8s-ithaqueue-com" {
  name = "masters.k8s.ithaqueue.com"
  role = "${aws_iam_role.masters-k8s-ithaqueue-com.name}"
}

resource "aws_iam_instance_profile" "nodes-k8s-ithaqueue-com" {
  name = "nodes.k8s.ithaqueue.com"
  role = "${aws_iam_role.nodes-k8s-ithaqueue-com.name}"
}

resource "aws_iam_role" "bastions-k8s-ithaqueue-com" {
  name               = "bastions.k8s.ithaqueue.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_bastions.k8s.ithaqueue.com_policy")}"
}

resource "aws_iam_role" "masters-k8s-ithaqueue-com" {
  name               = "masters.k8s.ithaqueue.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.k8s.ithaqueue.com_policy")}"
}

resource "aws_iam_role" "nodes-k8s-ithaqueue-com" {
  name               = "nodes.k8s.ithaqueue.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.k8s.ithaqueue.com_policy")}"
}

resource "aws_iam_role_policy" "bastions-k8s-ithaqueue-com" {
  name   = "bastions.k8s.ithaqueue.com"
  role   = "${aws_iam_role.bastions-k8s-ithaqueue-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_bastions.k8s.ithaqueue.com_policy")}"
}

resource "aws_iam_role_policy" "masters-k8s-ithaqueue-com" {
  name   = "masters.k8s.ithaqueue.com"
  role   = "${aws_iam_role.masters-k8s-ithaqueue-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.k8s.ithaqueue.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-k8s-ithaqueue-com" {
  name   = "nodes.k8s.ithaqueue.com"
  role   = "${aws_iam_role.nodes-k8s-ithaqueue-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.k8s.ithaqueue.com_policy")}"
}

resource "aws_key_pair" "kubernetes-k8s-ithaqueue-com-25b5b71a12a31286966e9a4cca1ca698" {
  key_name   = "kubernetes.k8s.ithaqueue.com-25:b5:b7:1a:12:a3:12:86:96:6e:9a:4c:ca:1c:a6:98"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.k8s.ithaqueue.com-25b5b71a12a31286966e9a4cca1ca698_public_key")}"
}

resource "aws_launch_configuration" "bastions-k8s-ithaqueue-com" {
  name_prefix                 = "bastions.k8s.ithaqueue.com-"
  image_id                    = "ami-0938c52697eb48ee2"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-k8s-ithaqueue-com-25b5b71a12a31286966e9a4cca1ca698.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.bastions-k8s-ithaqueue-com.id}"
  security_groups             = ["${aws_security_group.bastion-k8s-ithaqueue-com.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 32
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "master-us-east-1b-masters-k8s-ithaqueue-com" {
  name_prefix                 = "master-us-east-1b.masters.k8s.ithaqueue.com-"
  image_id                    = "ami-0938c52697eb48ee2"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-ithaqueue-com-25b5b71a12a31286966e9a4cca1ca698.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-k8s-ithaqueue-com.id}"
  security_groups             = ["${aws_security_group.masters-k8s-ithaqueue-com.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1b.masters.k8s.ithaqueue.com_user_data")}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-k8s-ithaqueue-com" {
  name_prefix                 = "nodes.k8s.ithaqueue.com-"
  image_id                    = "ami-0938c52697eb48ee2"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-k8s-ithaqueue-com-25b5b71a12a31286966e9a4cca1ca698.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-k8s-ithaqueue-com.id}"
  security_groups             = ["${aws_security_group.nodes-k8s-ithaqueue-com.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.k8s.ithaqueue.com_user_data")}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_nat_gateway" "us-east-1b-k8s-ithaqueue-com" {
  allocation_id = "${aws_eip.us-east-1b-k8s-ithaqueue-com.id}"
  subnet_id     = "${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "us-east-1b.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_route" "default-0-0-0-0--0" {
  route_table_id         = "${aws_route_table.k8s-ithaqueue-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-0ac832ba985a7acb0"
}

resource "aws_route" "private-us-east-1b-0-0-0-0--0" {
  route_table_id         = "${aws_route_table.private-us-east-1b-k8s-ithaqueue-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.us-east-1b-k8s-ithaqueue-com.id}"
}

resource "aws_route53_record" "api-k8s-ithaqueue-com" {
  name = "api.k8s.ithaqueue.com"
  type = "A"

  alias {
    name                   = "${aws_elb.api-k8s-ithaqueue-com.dns_name}"
    zone_id                = "${aws_elb.api-k8s-ithaqueue-com.zone_id}"
    evaluate_target_health = false
  }

  zone_id = "/hostedzone/Z00009921AN0EAWUAXGTH"
}

resource "aws_route53_record" "bastion-k8s-ithaqueue-com" {
  name = "bastion.k8s.ithaqueue.com"
  type = "A"

  alias {
    name                   = "${aws_elb.bastion-k8s-ithaqueue-com.dns_name}"
    zone_id                = "${aws_elb.bastion-k8s-ithaqueue-com.zone_id}"
    evaluate_target_health = false
  }

  zone_id = "/hostedzone/Z00009921AN0EAWUAXGTH"
}

resource "aws_route_table" "k8s-ithaqueue-com" {
  vpc_id = "vpc-0395fe1dfe8c8e25a"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
    "kubernetes.io/kops/role"                 = "public"
  }
}

resource "aws_route_table" "private-us-east-1b-k8s-ithaqueue-com" {
  vpc_id = "vpc-0395fe1dfe8c8e25a"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "private-us-east-1b.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
    "kubernetes.io/kops/role"                 = "private-us-east-1b"
  }
}

resource "aws_route_table_association" "private-us-east-1b-k8s-ithaqueue-com" {
  subnet_id      = "${aws_subnet.us-east-1b-k8s-ithaqueue-com.id}"
  route_table_id = "${aws_route_table.private-us-east-1b-k8s-ithaqueue-com.id}"
}

resource "aws_route_table_association" "utility-us-east-1b-k8s-ithaqueue-com" {
  subnet_id      = "${aws_subnet.utility-us-east-1b-k8s-ithaqueue-com.id}"
  route_table_id = "${aws_route_table.k8s-ithaqueue-com.id}"
}

resource "aws_security_group" "api-elb-k8s-ithaqueue-com" {
  name        = "api-elb.k8s.ithaqueue.com"
  vpc_id      = "vpc-0395fe1dfe8c8e25a"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "api-elb.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_security_group" "bastion-elb-k8s-ithaqueue-com" {
  name        = "bastion-elb.k8s.ithaqueue.com"
  vpc_id      = "vpc-0395fe1dfe8c8e25a"
  description = "Security group for bastion ELB"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "bastion-elb.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_security_group" "bastion-k8s-ithaqueue-com" {
  name        = "bastion.k8s.ithaqueue.com"
  vpc_id      = "vpc-0395fe1dfe8c8e25a"
  description = "Security group for bastion"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "bastion.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_security_group" "masters-k8s-ithaqueue-com" {
  name        = "masters.k8s.ithaqueue.com"
  vpc_id      = "vpc-0395fe1dfe8c8e25a"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "masters.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_security_group" "nodes-k8s-ithaqueue-com" {
  name        = "nodes.k8s.ithaqueue.com"
  vpc_id      = "vpc-0395fe1dfe8c8e25a"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "nodes.k8s.ithaqueue.com"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.api-elb-k8s-ithaqueue-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.bastion-k8s-ithaqueue-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-elb-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.bastion-elb-k8s-ithaqueue-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion-to-master-ssh" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.bastion-k8s-ithaqueue-com.id}"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "bastion-to-node-ssh" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.bastion-k8s-ithaqueue-com.id}"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-k8s-ithaqueue-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.api-elb-k8s-ithaqueue-com.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-k8s-ithaqueue-com.id}"
  from_port         = 3
  to_port           = 4
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-protocol-ipip" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "4"
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4001" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port                = 2382
  to_port                  = 4001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.nodes-k8s-ithaqueue-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-elb-to-bastion" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.bastion-k8s-ithaqueue-com.id}"
  source_security_group_id = "${aws_security_group.bastion-elb-k8s-ithaqueue-com.id}"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "ssh-external-to-bastion-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.bastion-elb-k8s-ithaqueue-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1b-k8s-ithaqueue-com" {
  vpc_id            = "vpc-0395fe1dfe8c8e25a"
  cidr_block        = "172.32.224.0/19"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "us-east-1b.k8s.ithaqueue.com"
    SubnetType                                = "Private"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}

resource "aws_subnet" "utility-us-east-1b-k8s-ithaqueue-com" {
  vpc_id            = "vpc-0395fe1dfe8c8e25a"
  cidr_block        = "172.32.128.0/22"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                         = "k8s.ithaqueue.com"
    Name                                      = "utility-us-east-1b.k8s.ithaqueue.com"
    SubnetType                                = "Utility"
    "kubernetes.io/cluster/k8s.ithaqueue.com" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

terraform {
  required_version = ">= 0.9.3"
}
