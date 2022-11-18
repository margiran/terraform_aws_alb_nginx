output "server_private_ip" {
  description = "The private IP of the EC2 Instance "
  value       = aws_instance.server[*].private_ip
}

output "link_http" {
  description = "access to the web page"
  value       = "http://${aws_lb.main_lb.dns_name}"
}
