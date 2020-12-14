# terraform-worker-examples
This repository includes some samples that do straight forward VPC creation with EC2 instance building.

It highlights a few of the key features of the terraform worker:
- reusable top level code
- simplified configuation leveraging Jinja
- modularity through the ability to easily swap different modules and reuse the outputs
- linking together modules via thee remote outputs
- isolating failure domains by breaking deployments into many pieces, without increased complexity

The examples are all AWS specific, but the same logic and rules can also be leveraged using any provider, with either the AWS or GCP state backends supported by terraform (more to come!)

# terraform 13+ support
Terraform 13 introduced a significant change to how modules and providers are configured, the worker works with both terraform 12 and 13 (untested with 14), however with 13 the plugins are required to be defined in each definition instead of the configuration, and since the providers specified in the configuration are shared between all definitions, it requires adding plugin requirements to definitions even if that definition does not use the provider. Ultimately this will lead to simpler configuration / handling but not yet!

## the examples
These are very simple examples! They don't include any host configuration or security management etc...

#### `setup`

These examples require an s3 bucket to store the terraform remote state, the commands below assume the bucket will be named: `s3bucket`. A specific region also needs to be used for storing the state, these examples will use `us-west-2` but may deploy to other regions. These examples were created using Terraform 13, and may not work with older versions (though the worker fully supports Terraform 0.12+). The terraform location in these examples is in ~/bin/terraform, but may need updated depending on where you've got terraform.

#### `worker-dev.yaml`

This is a typical stack, it includes deployments of a new vpc, new frontend, and new backend service.

```
worker \
  --config-file worker-dev.yaml \
  --backend s3 \
  --backend-region us-west-2 \
  --aws-region us-west-2 \
  --backend-bucket s3bucket \
  terraform example-dev \
  --show-output \
  --terraform-bin ~/bin/terraform \
  --apply
```

#### `worker-vpc-only.yaml`

This creates only a VPC, useful for testing the differences between deployments in an existing VPC and creating a new one.

```
worker \
  --config-file worker-vpc-only.yaml \
  --backend s3 \
  --backend-region us-west-2 \
  --aws-region us-east-2 \
  --backend-bucket s3bucket \
  terraform example-vpc \
  --show-output \
  --terraform-bin ~/bin/terraform \
  --apply
```

To remove the infrastructure, the command is the same as above but change `--apply` to `--destroy`


#### `worker-prod.yaml`

This is similar to the dev stack, but it assumes using an existing VPC, and also deploying a legacy application. It changes one variable that is set across the terraform definitions. This file needs edited to have the proper VPC_ID supplied for your VPC, it could also be supplied via a `--config-var` and inserted via Jinja.

```
worker \
  --config-file worker-prod.yaml \
  --backend s3 \
  --backend-region us-west-2 \
  --aws-region us-east-2 \
  --backend-bucket s3bucket \
  terraform example-prod \
  --show-output \
  --terraform-bin ~/bin/terraform \
  --apply
```

To remove the infrastructure, the command is the same as above but change `--apply` to `--destroy`

#### `worker-single.yaml`

This is a unified configuration file, that can be executed against the same deployments as the other examples, but requires a `--config-var` to be set specifying the environment, this demonstrates the power afforded by the jinja templates

for a dev deployment that matches the development config above:
```
worker \
  --config-var environment=dev \
  --config-file worker-single.yaml \
  --backend s3 \
  --backend-region us-west-2 \
  --aws-region us-west-2 \
  --backend-bucket s3bucket \
  terraform example-dev \
  --show-output \
  --terraform-bin ~/bin/terraform \
  --apply
```

for a prod deployment that matches the production config above:
```
worker \
  --config-var environment=dev \
  --config-file worker-single.yaml \
  --backend s3 \
  --backend-region us-west-2 \
  --aws-region us-east-2 \
  --backend-bucket s3bucket \
  terraform example-prod \
  --show-output \
  --terraform-bin ~/bin/terraform \
  --apply
```

As in the previous examples, using `--destroy` can remove all of the infrastructure created.
## todo

There are some more examples to complete
- [ ] using hook scripts
- [ ] using alternate providers
- [ ] using environment variables for configuration
- [ ] looping definitions with Jinja

## directories
`definitions` this is the location that we point to in the configuration files where all of the top level modules/code are stored. These are the entry points for the worker terraform runs.

`terraform-modules` this is required to exist in the `--repository-root` location (defaults to directory where worker is executed from). This is a location to store any custom modules.
