resource "aws_s3_bucket_policy" "cf_oac_bucket_policy1" {
  bucket = var.primary_bucket_id_to_attache_policy
  policy = file("${path.module}/cf_bkt_policy1.json")
}

resource "aws_s3_bucket_policy" "cf_oac_bucket_policy2" {
  bucket = var.failover_bucket_id_to_attache_policy
  policy = file("${path.module}/cf_bkt_policy2.json")
}