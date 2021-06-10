module "test-kitchen" {
    source = "../../modules/test-kitchen"
    project = "test-kitchen"
    owner = "platform-team"
    contact = "platform@example.com"
    environment = "development"
    vpc_cidr = "10.0.0.0/16"
    trusted_cidr = {
        myVpn = {
            cidr = "1.2.3.4"
        }
        myOtherVpn = {
            cidr = "4.3.2.1"
        }
    }
}
