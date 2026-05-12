output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "artifact_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}