provider "aws" {
 access_key = var.ACCESS_KEY
 secret_key = var.SECRET_ACCESS_KEY
 region = "ap-south-1"
}


resource "aws_key_pair" "ec2key" {

  key_name = "altair-ubuntu"

  public_key = "${file(var.public_key_path)}"

}