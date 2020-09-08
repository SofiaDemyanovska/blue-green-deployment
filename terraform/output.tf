output "loadbalancer_url" {
  value = aws_elb.puppet_theatre_back.dns_name
}

output "s3_url" {
  value = aws_s3_bucket.front.bucket_regional_domain_name 
}
