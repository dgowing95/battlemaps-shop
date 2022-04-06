resource "aws_acm_certificate" "cert" {
    domain_name = var.site_url
    validation_method = "DNS"
    subject_alternative_names = [
        "www.${var.site_url}",
    ]
    lifecycle {
      create_before_destroy = true
    }
}