# Module versioning

Module versions live in the path: `tf/modules/<provider>/<module>/<version>/`.

| Version dir | Meaning | May change? |
|---|---|---|
| `main` | development head | yes — all module work happens here |
| `v1`, `v2`, … | cut releases | **never** — an env pinned to `vN` gets the same infrastructure forever |

A module starts life as `main`. The first cut copies `main` to `v1`; from then on the module has
`v1` and `main`, then `v1`, `v2` and `main`, and so on.

## Changing a module

1. Work in `main`. If the module has only cut versions, create `main` by copying the latest `vN`
   and change the copy.
2. Point an env at `main` to try it (`source = "../../../modules/aws/<module>/main"`), then
   `terraform plan` / `apply` that env. Envs on `main` see every later change to it — use `main`
   for the env you are developing, not as a long-term pin.
3. Keep inputs backward compatible where possible; a changed input, output or resource address is
   a reason to cut before other envs move.

## Cutting a version

1. Pick the next number: one above the highest existing `vN`.
2. Copy the directory: `cp -r tf/modules/aws/<module>/main tf/modules/aws/<module>/vN`.
3. Commit the copy on its own — the commit is the release.
4. Move envs from `main` to `vN` by editing their `source` path, run `terraform init` (module
   sources changed) and check that `terraform plan` shows no changes.

After the cut, `vN` is frozen; fixes go to `main` and ship in `vN+1`.

## Moving an env to a newer version

1. Change `source` from `…/vN` to `…/vN+1`.
2. `terraform init`, then `terraform plan`. Read the plan: a renamed resource inside the module
   shows as destroy + create. Use a `moved {}` block in the env, or `terraform state mv`, to keep
   the resource instead of replacing it.
3. Apply once the plan shows only the intended changes.

## Current state

| Module | Cut | Development head |
|---|---|---|
| aws/ecr, aws/lambda, aws/vpc, aws/subnet, aws/sg | `v1` | `main` (reworked to the variables/locals/outputs layout, no provider block) |
| aws/rds | — | `main` |
| aws/backend | `v1` | — (not used by any env) |
| gcp/cloudrun, gcp/iap, gcp/bucket | `v1` | — |
