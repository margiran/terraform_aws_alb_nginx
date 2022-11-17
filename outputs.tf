output "server_private_ip" {
  description = "The private IP of the EC2 Instance "
  value = aws_instance.server[*].private_ip
}

output "lb_dns_name" {
  description = "access to the server by domain"
  value       = "https://${aws_lb.main_lb.dns_name }"
}
