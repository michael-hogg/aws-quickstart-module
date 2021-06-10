# Test Kitchen Module main.tf

provider "aws" {
  default_tags {
    tags = {
      Project     = var.project
      Owner       = var.owner
      Contact     = var.contact
      Environment = var.environment
    }
  }
}

// IAM Resources
resource "aws_iam_policy" "test_kitchen_policy" {
  name        = "test_kitchen_iam_policy"
  description = "Policy which can be used for the test-kitchen user to perform cookbook testing activities"
  policy      = file("${path.module}/policies/test-kitchen-user.json")
}

resource "aws_iam_group" "test_kitchen_iam_group" {
  name = "test_kitchen_iam_group"
}

resource "aws_iam_group_policy_attachment" "test_kitchen_iam_policy_attachment" {
  group      = aws_iam_group.test_kitchen_iam_group.id
  policy_arn = aws_iam_policy.test_kitchen_policy.id
}

resource "aws_iam_user" "test_kitchen_user" {
  name = "test_kitchen_iam_user"
  path = "/"
}

resource "aws_iam_group_membership" "test_kitchen_group_membership" {
  name = aws_iam_group.test_kitchen_iam_group.name
  users = [
    aws_iam_user.test_kitchen_iam_user.name
  ]
  group = aws_iam_group.test_kitchen_iam_group.name
}


// Networking Resources
resource "aws_vpc" "test_kitchen_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "test_kitchen_internet_gateway" {
  vpc_id = aws_vpc.test_kitchen_vpc.id
}

resource "aws_subnet" "test_kitchen_public_subnet" {
  vpc_id                  = aws_vpc.test_kitchen_vpc.id
  cidr_block              = var.vpc_cidr
  map_public_ip_on_launch = true
}

resource "aws_network_acl" "test_kitchen_nacl" {
  vpc_id     = aws_vpc.test_kitchen_vpc.id
  subnet_ids = [aws_subnet.test_kitchen_public_subnet.id]

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_route_table" "test_kitchen_route_table" {
  vpc_id = aws_vpc.test_kitchen_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_kitchen_internet_gateway.id
  }
}

resource "aws_route_table_association" "test_kitchen_rt_association" {
  route_table_id = aws_route_table.test_kitchen_route_table.id
  subnet_id      = aws_subnet.test_kitchen_public_subnet.id
}

resource "aws_security_group" "test_kitchen_security_group" {
  vpc_id = aws_vpc.test_kitchen_vpc.id
}

resource "aws_security_group_rule" "test_kitchen_outbound" {
  description       = "Rule to enable nodes to reach the Internet"
  security_group_id = aws_security_group.test_kitchen_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "test_kitchen_ssh_ingress" {
  for_each          = var.trusted_cidr
  description       = "Rule to allow ingress SSH from trusted CIDR"
  security_group_id = aws_security_group.test_kitchen_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = each.value.cidr
}

resource "aws_security_group_rule" "test_kitchen_winrm_ingress" {
  for_each          = var.trusted_cidr
  description       = "Rule to allow ingress WinRM over HTTP from Trusted IP"
  security_group_id = aws_security_group.test_kitchen_security_group.id
  type              = "ingress"
  from_port         = 5985
  to_port           = 5985
  protocol          = "tcp"
  cidr_blocks       = each.value.cidr
}

resource "aws_security_group_rule" "test_kitchen_winrm_https_ingress" {
  for_each          = var.trusted_cidr
  description       = "Rule to allow ingress WinRM over HTTPS from Trusted IP"
  security_group_id = aws_security_group.test_kitchen_security_group.id
  type              = "ingress"
  from_port         = 5986
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = each.value.cidr
}
