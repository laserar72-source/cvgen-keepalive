# supabase-keepalive

Stops a Supabase **Free** project from being auto-paused after a week of
inactivity, by having GitHub Actions run a real query against it once a day.

Supabase's docs say a Free project is flagged inactive if it doesn't get
enough database queries over the trailing 7 days — roughly a few requests
per day, not just one. This workflow errs on the safe side with a daily ping
instead of a weekly one.

## Setup

### 1. Create the repo
Create a new **empty** repository on GitHub (no README/.gitignore), e.g.
`supabase-keepalive`. Then, from this folder:

```bash
git init
git add .
git commit -m "Add Supabase keepalive workflow"
git branch -M main
git remote add origin https://github.com/<your-username>/supabase-keepalive.git
git push -u origin main
```

### 2. Create a table the anon key can read
In the Supabase Dashboard → SQL Editor, run the contents of `sql/setup.sql`.
This creates a `keepalive` table with a row-level security policy that lets
the public anon key `SELECT` from it (nothing else).

### 3. Add repo secrets
In your GitHub repo: **Settings → Secrets and variables → Actions → New
repository secret**, add:

| Secret name          | Value                                      |
|----------------------|---------------------------------------------|
| `SUPABASE_URL`       | Your project URL, e.g. `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY`  | Your project's `anon` public API key        |

(Both are in Supabase Dashboard → Project Settings → API.)

Optional: add `SUPABASE_TABLE` if you want to point at a different table
than `keepalive` (must already be readable by the anon key).

### 4. Done
The workflow (`.github/workflows/keepalive.yml`) runs automatically every
day at 08:00 UTC. You can also trigger it manually anytime from the repo's
**Actions** tab → "Supabase Keepalive" → "Run workflow", which is a good way
to confirm it's wired up correctly right after setup.

## Notes
- This only prevents the *inactivity pause*. It won't help if you hit the
  free tier's storage, bandwidth, or MAU caps.
- Never put your Supabase keys directly in the workflow file — always use
  GitHub Secrets, as set up above, so they aren't exposed in the repo.
- If Supabase changes their inactivity threshold or detection logic in the
  future, this workflow may need adjusting — the daily cadence gives some
  buffer, but it's not a guarantee.
