# Module catalog

Path: `tf/modules/<provider>/<module>/<version>`. Prefer a cut version (`vN`) in long-lived envs;
`main` is the development head (see [versioning.md](versioning.md)). Inputs marked * are
required.

## AWS

### aws/vpc

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `main` | one VPC, DNS support + hostnames on, tagged | `env`*, `tag`*, `cidr`*, `shreg`, `tags` | `vpc_id`, `cidr` |
| `v1` | one VPC, fixed `172.31.0.0/16`, untagged | `env`, `reg`, `tag` (unused) | `vpc_id` |

### aws/subnet

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `main` | one subnet in a chosen AZ, no public IPs by default | `env`*, `tag`*, `vpc_id`*, `cidr`*, `availability_zone`*, `map_public_ip_on_launch`, `shreg`, `tags` | `subnet_id`, `availability_zone` |
| `v1` | one subnet, AWS-chosen AZ, public IPs on launch | `vpc_id`, `cidr`, `env`, `reg`, `tag` | — |

### aws/sg

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `main` | a security group with the given ingress rules (none by default) and open egress | `env`*, `tag`*, `vpc_id`*, `ingress` (list of `{description, from_port, to_port, protocol, cidr_blocks, security_groups}`), `shreg`, `tags` | `sg_id` |
| `v1` | a security group open to all traffic in and out | `vpc_id`, `env`, `reg`, `tag` | — |

### aws/rds

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `main` | a private, encrypted Postgres instance + its DB subnet group; generated alphanumeric master password; final snapshot on delete; deletion protection on by default | `env`*, `tag`*, `subnet_ids`* (≥ 2 AZs), `security_group_ids`*, `db_name`*, `username`*, `engine_version` (`16`), `instance_class` (`db.t4g.micro`), `allocated_storage` (20), `backup_retention_period` (7), `deletion_protection` (true), `shreg`, `tags` | `address`, `port`, `db_name`, `username`, `password` (sensitive), `dsn` (sensitive, `sslmode=require`) |

### aws/ecr

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `main` | an image repository `${env}-${shreg}-${tag}`, scan on push, optional untagged-image expiry, a policy for the account and for Lambda (same account) to pull | `env`*, `tag`*, `force`, `expire_untagged` (true), `untagged_expire_days` (7), `shreg`, `tags` | `repository_url`, `repository_name`, `repository_arn` |
| `v1` | the repository + account policy; AWS rejects the policy as declared (its second statement names a fixed `hello` repo and has no Principal) — no env uses it | `env`, `tag`, `force`, `reg`, `shreg` | — |

Set `expire_untagged = false` when a function may still run an image whose tag was re-pushed
(an untagged digest) — expiry would delete the image under it.

### aws/lambda

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `main` | a container-image function `l-${env}-${tag}`, its role + log policy, a log group, optional VPC attachment (adds the VPC access policy), optional function URL (auth `NONE` also adds the public invoke permission) | `env`*, `tag`*, `image_uri`*, `env_vars`, `timeout` (30), `memory_size` (256), `architectures` (`x86_64`), `subnet_ids`, `security_group_ids`, `function_url` (false), `function_url_auth_type` (`AWS_IAM`), `log_retention_days` (30), `reg`, `shreg`, `tags` | `function_name`, `function_arn`, `function_url`, `role_arn` |
| `v1` | the chapi function: fixed image `prod-usw1-chapi:latest`, `GIN_MODE` + `APP_CH_LAMBDA` env | `env`, `tag`, `gin_mode`, `docker_tag`, `reg`, `shreg` | — |

`env_vars` merge over the standard set `env`, `tag`, `region`.

lambda `main` needs the aws provider **≥ 6.0**: a function URL with auth `NONE` requires two
resource-policy statements (since October 2025) — `lambda:InvokeFunctionUrl` with
`function_url_auth_type = "NONE"` and `lambda:InvokeFunction` with
`invoked_via_function_url = true` — and the second argument exists only in 6.x. Missing either
statement makes every request return `403 Forbidden` before reaching the function.

The image must keep a working directory any uid can enter: Lambda ignores the image's `USER` and
runs as its own uid, so e.g. distroless `:nonroot` (WORKDIR `/home/nonroot`, mode 0700) fails at
launch with `Runtime.InvalidEntrypoint` unless the Dockerfile sets `WORKDIR /`.

### aws/backend

`v1` sketches a shared S3 backend declaration; it is not valid as written (a backend block cannot
use locals) and no env uses it. Envs write their backend block directly.

## GCP

### gcp/cloudrun

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `v1` | a Cloud Run v2 service, its service account, an Artifact Registry repo with cleanup policies, invoker IAM | `project_id`*, `tag`*, `env`*, `port`*, `region` (`us-central1`), `labels`, `env_vars`, `ingress`, `allow_unauthenticated`, `invoker_principals` | `url`, `service_name`, `sa_email`, `repo_id` |

### gcp/bucket

| Version | Creates | Inputs | Outputs |
|---|---|---|---|
| `v1` | a storage bucket with versioning, archival lifecycle and labels | `company`, `group`, `project_id`, `env`, `region`, `storage_class`, `versioning`, `uniform_bucket_level_access`, `force_destroy`, `labels`, `archival_days`, `archival_storage_class` | `bucket_name`, `bucket_self_link`, `bucket_url` |

### gcp/iap

`v1` is an empty placeholder (all files are empty). `env/prod/hello_world/network` references it.
