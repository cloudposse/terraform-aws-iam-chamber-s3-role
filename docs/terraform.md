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
| principals_arns | List of ARNs to allow assuming the role. Could be AWS services or accounts, Kops nodes, IAM users or groups | list | - | yes |
| read_only | Set to `true` to deny write actions for bucket | string | `false` | no |
| services | Names of chamber services | list | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | The Amazon Resource Name (ARN) specifying the role |
| role_id | The stable and unique string identifying the role |
| role_name | The name of the crated role |

