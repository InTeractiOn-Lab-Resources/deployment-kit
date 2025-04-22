output "instance_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.sandbox.public_ip
}

output "key_pair_name" {
  description = "Name of the key pair created in AWS (used to SSH into the instance)"
  value = aws_key_pair.default.key_name
}
