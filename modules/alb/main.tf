# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false  #internet-facing ALB (accessible from the internet)
  load_balancer_type = "application"  #used for HTTP/HTTPS traffic
  security_groups    = [var.alb_sg_id]
  subnets            = [var.pub_sub_1a_id,var.pub_sub_2b_id]
  enable_deletion_protection = false  #ALB can be deleted easily (for dev/test environments)

  tags   = {
    Name = "${var.project_name}-alb"
  }
}



# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.project_name}-tg"
  target_type = "instance"
  port        = 80   #ALB will forward HTTP traffic to the targets on port 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300  #every 5 minutes
    path                = "/"
    timeout             = 60
    matcher             = 200  #healthy response must return HTTP 200 OK
    healthy_threshold   = 2   #Needs 2 consecutive healthy responses to be considered healthy
    unhealthy_threshold = 5   #5 failed checks to mark it unhealthy
  }

  lifecycle {
    create_before_destroy = true   #Ensures Terraform creates a new target group before deleting the old one
  }
}



# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80   # listener will listen for HTTP traffic on port 80
  protocol          = "HTTP" 

  default_action {
    type = "forward"   #Forwards incoming traffic to a target group
    target_group_arn = aws_lb_target_group.alb_target_group.arn  # ARN of the target group where traffic is forwarded
  }
}