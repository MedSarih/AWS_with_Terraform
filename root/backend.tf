#remote backend
terraform {
  backend "s3" {
    bucket       = "mybucketmed2003"
    key          = "backend/demo.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}