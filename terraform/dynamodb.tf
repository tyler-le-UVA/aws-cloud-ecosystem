resource "aws_dynamodb_table" "ratings_table" {
  name         = "user-ratings"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}