output "loadbalancer_url" {
  value = aws_elb.puppet_theatre_back.dns_name
}

output "s3_url" {
  value = aws_s3_bucket.puppet_theatre_back.bucket_regional_domain_name 
}
