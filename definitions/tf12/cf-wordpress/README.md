# a definition that blends terraform with cloud formation

One might ask why you would do this? Perhaps a part of the organization, or a third 
party has a very comprehensive cloud formation stack to deploy. However, all of your 
existing tooling is written and deployed with terraform. While you could convert the 
cloud formation to terraform, and there are even scripts to do this, you would have to
then always convert the changes or require the other team to now manage their resource
in the language you have selected.

## benefits to a blended approach

* There is some functionality, like created SSH keys in AWS that cloud formation does not
support. This is demonstrated here, terraform can create the resources which can then be
used by cloud formation.
* Outputs from terraform modules can easily be passed as paramaters to the stack
* A terraform first organization likely already has well defined workflows for deploying terraform, those can now be applied to cloud formation with minimal translation. 
* A seperate group could manage the stack resources independently of terraform management
