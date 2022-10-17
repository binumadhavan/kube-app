//upload public key. create the key-pair
resource "aws_key_pair" "web-key" {
  public_key = file("web_key.pub")
  key_name   = "web-key"
}