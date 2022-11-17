output "server_public_ip" {
  description = "The public IP of the EC2 Instance "
  value       = aws_instance.server.public_ip
}

output "server_private_ip" {
  description = "The private IP of the EC2 Instance "
  value       = aws_instance.server.private_ip
}

output "ssh_server_public_ip" {
  description = "Command for ssh to the Server public IP of the EC2 Instance"
  value       = "ssh ubuntu@${aws_instance.server.public_ip} -i ~/.ssh/key_pair"
}

output "https_server_public_ip" {
  description = "access to the server by IP"
  value       = "https://${aws_instance.server.public_ip}"
}

output "https_domain" {
  description = "access to the server by domain"
  value       = "https://${var.record_name}"
}
