# sanvir.net

Personal resume site for Sanvir Manilal — Senior Software Engineer based in the Netherlands.

## Updating the site

Edit `index.html` (or replace `profile.jpg`) and push to `main`. The **Deploy**
GitHub Action then builds a small Caddy image containing the site, pushes it to
GHCR and deploys it to the VPS, where the shared edge proxy serves
<https://sanvir.net> (and redirects `www.sanvir.net` to it). You can also run it
by hand from **Actions → Deploy → Run workflow**.

- `Containerfile`, `site.Caddyfile`: the image (static files served on :8080).
- `deploy/`: Compose file, edge-proxy site file and deploy script copied to
  `/opt/apps/sanvir-net` on the VPS.
- `.github/workflows/deploy.yml`: the pipeline. It needs the repository secrets
  `VPS_HOST`, `VPS_USER`, `VPS_SSH_KEY` and `VPS_KNOWN_HOSTS`.

The VPS setup (edge proxy, `apps` user, Cloudflare) is described in
`DEPLOY.md` in the HN-Reader repository. GitHub Pages cannot be switched off
for a `<user>.github.io` repository, so it still publishes the same files at
<https://sanvirmanilal.github.io>, but no longer claims the `sanvir.net`
domain. Don't add a `CNAME` file back.

Roll back to an earlier commit's image, as `apps` on the VPS:

```bash
cd /opt/apps/sanvir-net && echo IMAGE_TAG=<older-sha> > .env && docker compose up -d
```
