# basic_infra docs — index

Load only the doc for the job at hand. Each entry says when it applies.

| Working on | Read |
|---|---|
| Finding your way around: where modules and envs live, the file set inside a module, naming (`${env}-${shreg}-${tag}`), standard variables, tags, where providers and state are declared | [layout.md](layout.md) |
| Changing a module, cutting a release (`main` → `vN`), moving an env to a new module version | [versioning.md](versioning.md) |
| Picking a module to compose: what each module and version creates, its inputs and outputs | [modules.md](modules.md) |
| Running an env (init / plan / apply), credentials, `terraform.tfvars`, apply order between envs, per-env notes and outputs | [envs.md](envs.md) |

## Rules that hold everywhere

- A cut module version (`v1`, `v2`, …) is never modified. All module changes land in `main`.
- Envs compose modules; modules never reference envs.
- `terraform.tfvars`, `*.tfstate` and `.terraform.lock.hcl` are not committed (see `.gitignore`).
- State lives in S3 (`ch-tlc-state`, us-west-1) for AWS envs and GCS for GCP envs, one key per env.
