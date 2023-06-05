resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.project
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "item_id"
  attribute {
    name = "item_id"
    type = "S"
  }
}