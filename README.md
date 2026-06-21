# BESIII coupled-channel public results

Public, sanitized presentation site generated with Quarto. It contains selected
plots and scientific summaries only. Internal EOS paths, Condor logs, fit
parameter snapshots, YAML configurations and environments are intentionally
excluded.

## Preview locally

```bash
quarto preview
```

## Build

```bash
quarto render
```

Pushing `main` to GitHub triggers the Pages deployment workflow.

## Refresh public plot assets

Pass the corresponding experiment directory from the private analysis log:

```bash
./scripts/update_assets.sh /path/to/private/experiment public-experiment-id
quarto render
git add .
git commit -m "update public result plots"
git push
```

If `public-experiment-id` is omitted, the private experiment directory name is
used. The script copies only PNG figures and generated plot diagnostics. It
does not copy parameter snapshots, configurations, logs or internal paths.
