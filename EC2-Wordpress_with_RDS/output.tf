output "public_ip" {
  description = "Public IP inst"
  value       = aws_instance.my_instance.public_ip
}

