resource "random_pet" "pet" {
  length = 1
}

resource "aws_security_group" "instances_sg" {
  name   = "${var.security_group_name}-instances-${random_pet.pet.id}_${terraform.workspace}"
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.security_group_name}-alb-${random_pet.pet.id}_${terraform.workspace}"
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "ingress_instances_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.instances_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "egress_full_instance" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.instances_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg.id
  source_security_group_id = aws_security_group.instances_sg.id
}

resource "aws_instance" "server" {
  count                  = var.server_count
  ami                    = var.ami
  instance_type          = var.server_instance_type
  vpc_security_group_ids = [aws_security_group.instances_sg.id]
  subnet_id              = aws_subnet.private-us-east-2a.id 
  root_block_device {
    volume_size = 100
    volume_type = "io1"
    iops        = 1000
  }
  user_data = templatefile("cloudinit_server.yaml", {})
  tags = {
    Name = "server_${random_pet.pet.id}_${terraform.workspace}"
  }
}

resource "aws_lb_target_group" "webserver_tg" {
  name     = "webserver-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  health_check {
    enabled             = true
    port                = 80
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 4
    unhealthy_threshold = 4
  }
}

resource "aws_lb_target_group_attachment" "webserver_tg_attach" {
  # for_each =toset(aws_instance.server)
  count = var.server_count

  target_group_arn = aws_lb_target_group.webserver_tg.arn
  target_id        = aws_instance.server[count.index].id
  port             = 80
}
resource "aws_lb" "main_lb" {
  name               = "main-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public-us-east-2a.id,
    aws_subnet.public-us-east-2b.id
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}