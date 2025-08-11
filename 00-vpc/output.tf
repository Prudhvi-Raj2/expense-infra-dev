# output "azs_info" {
#     value = module.vpc.azs_info

# }

# output "subnets_info" {
#   value = module.vpc.subnets_info
# }

output "public_subnets_ids" {
  value = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets_ids
}

output "database_subnets_ids" {
  value = module.vpc.database_subnets_ids
}

