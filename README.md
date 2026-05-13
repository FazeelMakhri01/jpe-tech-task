# Release Status Dashboard - Technical Task Submission

## How I Ran the Application

Forked the repo into my personal GitHub, created a local working directory for the task, and cloned it down. Opened the whole folder in VSCode first to get a feel for the structure before touching anything — understanding what you're working with before making changes saves time later.

Cloned the repo, ran `npm install` and `npm start` to confirm the app came up on `http://localhost:3000` as expected.

From there I moved straight to Docker, since that's where the application would actually run in any real environment. Built the image with `docker build` and ran it with `docker run -p 3000:3000` to verify it behaved the same way containerised. Once I was happy with that, I added a `docker-compose.yml` so I wasn't retyping build and run commands every time I made a change.

---

## Issues and Improvements Identified

### Dockerfile

- The base image was `node:20`. Swapped it for `node:20-slim`. Smaller image, fewer unnecessary packages, still fully functional for what this app needs.
- Added a dedicated user and group so the container runs as a non-root user. Running as root inside a container is a security risk.
- No `.dockerignore` file existed. Without it, `node_modules`, `.git`, and other local artefacts get copied into the build context, bloating the image and potentially leaking local state.
- The Dockerfile had no health check. Docker's default behaviour is to check whether the process is running — it has no idea if the app inside is actually healthy. The repo already had a `/health` endpoint (or equivalent script), so I wired that into a `HEALTHCHECK` instruction. This means `docker logs` and `docker ps` will now surface whether the container is genuinely healthy rather than just alive.

### CI/CD Pipeline (`deploy.yml`)

- There was no clear separation of stages. A CI pipeline should follow `build → test → deploy` in that order, and the existing workflow didn't enforce this.
- `npm install` was being used for dependency installation. Swapped to `npm ci`, which is faster, reproducible, and the correct choice for CI environments — it installs from `package-lock.json` exactly rather than resolving.
- Node.js wasn't being set up in the workflow before installing packages. Added a `setup-node` step.
- The deploy script didn't have executable permissions set. Added `chmod +x` before running it.
- There was no smoke test stage. Building an image with no validation means you could ship a broken container. Added a smoke test step that runs the container and verifies the app responds before anything gets anywhere near a deployment target.

### Terraform (`infra/`)

- No remote state backend configured. Using local state in a team or CI context means state can go out of sync or get lost entirely. This should be backed by S3 with DynamoDB locking at minimum.
- No explicit variable definitions for things like instance type or AMI ID — these were hardcoded. For anything meant to be shared or reused, those belong in `variables.tf`.
- No tagging strategy. AWS resources without consistent tags make cost attribution and access control harder down the line.
- Depending on the setup, the security group may be too permissive. Worth reviewing ingress rules to ensure only required ports are open.

---

## Changes Made and Why

| Change | Why |
|--------|-----|
| `node:20` → `node:20-slim` + `npm ci --only=production` | Reduced image size from 1.64GB down to 328MB — slimmer base image combined with stripping devDependencies out of the production build |
| Added non-root user and group | Containers shouldn't run as root — if something is exploited or goes wrong, the blast radius is contained to that user rather than the whole system |
| Added `.dockerignore` | Keeps `node_modules`, `.git`, and local config out of the build context |
| Added `HEALTHCHECK` to Dockerfile | Docker now checks if the app is actually healthy, not just if the process is alive |
| Added `docker-compose.yml` | Removes the need to re-run `docker build` + `docker run` manually during development |
| `npm install` → `npm ci` | Reproducible installs in CI — installs from lockfile exactly |
| Added `setup-node` step | Node wasn't being set up before package installation — the pipeline would fail without it |
| Added `chmod +x` on deploy script | Script wasn't executable; CI would error trying to run it |
| Added `build → test → deploy` stage order | No point running deploy if the build or tests haven't passed |
| Added smoke test stage | Spins up the built image and checks the app responds before treating the build as deployable |

---

## What I'd Do With More Time

- **Multi-stage Docker build** — separate the build and runtime stages so dev dependencies don't end up in the final image.
- **Image scanning** — add Sonarqube or similar into the pipeline to catch known CVEs in dependencies before anything ships.
- **Terraform improvements** — remote state backend (S3 + DynamoDB locking), extract hardcoded values into variables, add a consistent tagging strategy across resources.
