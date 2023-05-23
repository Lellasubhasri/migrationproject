variable "vpc_cidr" {
    type = string
    description = "this is cidr address"
}

variable "number_of_azs" {
    description = "this is for number of AZs to use"
    type = number
}