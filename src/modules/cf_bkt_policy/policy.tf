resource "aws_s3_bucket_policy" "cf_oac_bucket_policy" {
  bucket = var.bucket_id_to_attache_policy
  policy = data.aws_iam_policy_document.cf_s3_bucket_policy.json
}



data "aws_iam_policy_document" "cf_s3_bucket_policy" {
  statement {
    actions = [ "s3:GetObject" ]
    resources = [ "${var.bucket_arn}/*" ]
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [var.cloudfront_arn]
    }
  }
}

