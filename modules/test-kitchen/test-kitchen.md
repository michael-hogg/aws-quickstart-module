# test-kitchen module

## Usage

The test kitchen module expects a CIDR for the Test Kitchen VPC and a set of Trusted CIDR ranges that test kitchen instances can be reached from. An example can be seen below. 

```hcl

module "test-kitchen" {
  source       = "../../modules/test-kitchen"
  vpc_cidr     = "10.0.0.0/16"
  trusted_cidr = ["1.2.3.4/32", "4.3.2.1/32"]
}

```