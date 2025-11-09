output "environment" {
  value = local.environment
}

output "ec2_public_ips" {
  value = [for i in aws_instance.web : i.public_ip]
}

output "alb_dns" {
  value = aws_alb.web_alb.dns_name
}