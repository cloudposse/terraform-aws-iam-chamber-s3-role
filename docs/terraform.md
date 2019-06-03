## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| bucket_arn | ARN of S3 bucket | string | - | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| enabled | Set to `false` to prevent the module from creating any resources | string | `true` | no |
| max_session_duration | The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours | string | `3600` | no |
| name | Name (e.g. `app` or `chamber`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| policy_description | The description of the IAM policy that is visible in the IAM policy manager | string | `Access to S3 bucket` | no |
| principals_arns | List of ARNs to allow assuming the role. Could be AWS services or accounts, Kops nodes, IAM users or groups | list | `<list>` | no |
| read_only | Set to `true` to deny write actions for bucket | string | `false` | no |
| role_description | The description of the IAM role that is visible in the IAM role manager | string | `Role to access to S3 bucket` | no |
| role_enabled | Set to `false` to prevent the module from creating IAM role | string | `true` | no |
| services | Names of chamber services | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | The Amazon Resource Name (ARN) specifying the role |
| role_id | The stable and unique string identifying the role |
| role_name | The name of the IAM role created |
| role_policy_document | IAM policy to access chamber s3 |

