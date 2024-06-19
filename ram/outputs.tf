output "resource_association" {
  description = "Object with the AWS RAM resource association resource"
  value       = aws_ram_resource_association.this
}

output "principal_association" {
  description = "Object with the AWS RAM principal association resource"
  value       = aws_ram_principal_association.this
}