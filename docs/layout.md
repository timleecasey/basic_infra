# Layout and conventions

## Tree

```
tf/
  modules/<provider>/<module>/<version>/   reusable building blocks
    aws/  ecr, lambda, vpc, vpc_endpoint, subnet, sg, rds, s3, schedule, backend
    gcp/  cloudrun, iap, bucket
  env/<env>/<unit>/                         one Terraform root per deployed unit
    prod/ecr, prod/chapi, prod/vpc, prod/process, prod/hello_world/{network,service}
```

- **Modules** are versioned by path: `main` is the development head, `v1`, `v2`, … are cut
  releases. See [versioning.md](versioning.md).
- **Envs** are Terraform roots. Each one composes modules by relative path, e.g.
  `source = "../../../modules/aws/lambda/main"`, and has its own state.

## Files inside a module version

| File | Holds |
|---|---|
| `variables.tf` | inputs, each with a `description`; `env` is validated to `dev`, `demo` or `prod` |
| `locals.tf` | the resource name and the merged tags/labels |
| `outputs.tf` | everything a composing env needs (ids, urls, sensitive secrets marked `sensitive`) |
| `<resource>.tf` | the resources, e.g. `lambda.tf`, `rds.tf`, `security_group.tf` |

Modules do **not** declare a `provider` block; the env configures the provider. A module that
needs a non-default provider (e.g. `random`) lists it in a `terraform { required_providers }`
block without configuring it. The AWS `v1` modules predate this and carry a
`provider "aws" { region = var.reg }` of their own — an env that mixes them with `main` modules
declares its own `provider "aws"` as well (see `tf/env/prod/ecr`).

## Files inside an env

| File | Holds |
|---|---|
| `terraform.tf` | `required_providers` with version constraints, the state `backend`, the `provider` blocks |
| `namespace.tf` | the env's input variables, declared without defaults |
| `terraform.tfvars` | the values for those variables — local, not committed; the values each env expects are listed in [envs.md](envs.md) |
| `<unit>.tf` (`network.tf`, `db.tf`, `service.tf`, …) | the module calls |
| `outputs.tf` | what an operator needs after apply (urls, keys) |

Older envs (`prod/chapi`, `prod/ecr`, `prod/vpc`) declare variables with defaults inside
`terraform.tf` instead of `namespace.tf` + tfvars.

## Naming

AWS resources are named `${env}-${shreg}-${tag}`:

- `env` — `prod`, `demo` or `dev`.
- `reg` — full region (`us-west-1`); `shreg` — its short form used in names (`usw1`).
- `tag` — the unit, e.g. `process`; sub-parts append to it (`process-a`, `process-db`).

Lambda keeps its v1 names: function `l-${env}-${tag}`, role `role-${env}-${shreg}-${tag}`,
policy `policy-${env}-${shreg}-${tag}`. GCP modules use `${env}-${region}-${tag}`.

## Tags

AWS `main` modules tag every resource with `env`, `reg` (= `shreg`), `unit` (= `tag`) and, where
the resource shows a name, `Name`. A module's `tags` input merges extra tags on top.

## State

| Provider | Backend | Key pattern |
|---|---|---|
| AWS | `s3`, bucket `ch-tlc-state`, region `us-west-1` | `terraform/<env>/<region>/<unit>` (e.g. `terraform/prod/us-west-1/process`) |
| GCP | `gcs` | `terraform/<env>/<region>/…` under the env's state bucket |

Backend blocks cannot use variables; the bucket and key are written literally in each env.
