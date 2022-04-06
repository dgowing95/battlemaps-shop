resource "aws_lb" "lb" {
    name = "orion-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = aws_subnet.public.*.id

    tags = {
        Name = "orion-lb"
    }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Page not found."
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "battlemaps" {
    name = "battlemap-tg"
    port = "80"
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    target_type = "ip"
    health_check {
        enabled = false
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_lb_listener_rule" "battlemaps" {
    listener_arn = aws_lb_listener.https.arn
    priority = 1
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.battlemaps.arn
    }
    condition {
        host_header {
            values = [var.site_url]
        }
    }
}