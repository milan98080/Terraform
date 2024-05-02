resource "aws_lb" "my_load_balancer" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.alb_subnets

  enable_deletion_protection = false
}

resource "aws_wafv2_web_acl" "my_web_acl" {
  name        = "my-web-acl"
  scope       = "REGIONAL"
  description = "Web ACL to protect my ALB"

  default_action {
    allow {}
  }

  rule {
    name     = "allow-all"
    priority = 1
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "myWebAclMetrics"
      sampled_requests_enabled   = true
    }
    action {
      allow {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "myWebAclMetrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "my_web_acl_association" {
  resource_arn = aws_lb.my_load_balancer.arn
  web_acl_arn  = aws_wafv2_web_acl.my_web_acl.arn
}

