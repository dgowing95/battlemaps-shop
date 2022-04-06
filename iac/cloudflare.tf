# resource "cloudflare_zone" "battlemaps" {
#     zone = var.site_url
#     plan = "free"
# }

# resource "cloudflare_record" "acm_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       value = dvo.resource_record_value
#       type   = dvo.resource_record_type
      
#     }
#   }
#   zone_id = cloudflare_zone.battlemaps.id
#   name = each.value.name
#   value = trimsuffix(each.value.value, ".")
#   type = each.value.type
#   proxied = false

# }
# resource "cloudflare_record" "domain" {
#     zone_id = cloudflare_zone.battlemaps.id
#     name = var.site_url
#     value = aws_lb.lb.dns_name
#     type = "CNAME"
#     proxied = true
# }