module "network" {
  source = "./modules/network"
}

module "bastion" {
  source            = "./modules/bastion"
  private_subnet_id = module.network.private_subnet_ids[1]
}

module "frontend" {
  source = "./modules/frontend"
}

module "backend" {
  source          = "./modules/backend"
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnet_ids
  public_rt = module.network.public_rt_s3_endpoint
}

module "database" {
  source                         = "./modules/database"
  vpc_id                         = module.network.vpc_id
  backend_sg_id                  = module.backend.backend_sg_id
  primary_db_subnet_id           = module.network.private_subnet_ids[0]
  replica_db_subnet_id           = module.network.private_subnet_ids[1]
  private_subnet_ids_for_cluster = module.network.private_subnet_ids
}

module "route53" {
  source = "./modules/route53"
  cloudfront_distribution_zone_id = module.frontend.cloudfront_distribution_zone_id
  cloudfront_distribution_domain_name = module.frontend.cloudfront_distribution_dns_name
  alb_zone_id = module.backend.load_balancer_zone_id
  alb_dns_name = module.backend.load_balancer_dns_name
}

module "ml_service" {
  source = "./modules/ml-service"
  vpc_id = module.network.vpc_id
  subnet_ml = module.network.private_subnet_ids[0]
  backend_sg_id = module.backend.backend_sg_id
}

