resource "aws_s3_bucket_policy" "cf_oac_bucket_policy" {
  bucket = var.bucket_id_to_attache_policy
  policy = file("${path.module}/cf_bkt_policy1.json")
}
