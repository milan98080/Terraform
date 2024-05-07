output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "load_balancer_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.app_lb.zone_id
}

output "load_balancer_arn" {
  value = aws_lb.app_lb.arn
}

output "backend_sg_id" {
  value = aws_security_group.ecs_sg.id
}
