# tf-infra-falco-eks-audit-bridge
Terraform infrastructure for falco-eks-audit-bridge (as proposed in https://xebia.com/blog/monitoring-aws-eks-audit-logs-with-falco).
This creates a Kinesis Firehose stream sending data to an s3 bucket coming from your EKS cluster control plane logs, loosely based on [this](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs//SubscriptionFilters.html#FirehoseExample) AWS example. You can then use the [falco-eks-audit-bridge](https://github.com/xebia/falco-eks-audit-bridge) deployment to process your cluster cohtrol plane logs with Falco.


## Config
1. Make sure you set the correct loggroup in the locals.tf so it will generate the correct log_group_name that is going to be used as an input to Kinesis.
```
log_group_name = "/aws/eks/clustername${var.env == "master" ? "" : "-${var.env}"}/cluster"
```

2. Change the state.tf to work with your backend or add this code to your EKS definition in Terraform.

3. EKS Terraform config
Add the logging part to the EKS cluster (use AWS provider > 2.6.0) or enable this manual using the AWS Console.

```hcl
resource "aws_eks_cluster" "cluster" {
  name     = "cluster${local.branch_suffix}"
  role_arn = "${aws_iam_role.clusterrole.arn}"
  version = "${var.kubernetes_version}"  

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
```

The log group name format by default is /aws/eks/cluster-name/cluster.

## Needed variables
```hcl
###### AWS variables

variable region {
  default = "eu-west-1"
}

####### Deployment variables

variable account_id {
  type    = "string"
  default = "111111111111"
}

variable deploy_role {
  default = "somerole"
}

variable env {
  description = "Unique environment identifier"
  default     = "dev"
}
```
