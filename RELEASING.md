# Releasing DecompKit

DecompKit releases are GitHub Releases created from semantic Git tags.

## Versioning

Use semantic versioning:

- `MAJOR` for breaking public API changes.
- `MINOR` for new components, new configuration options, or backward-compatible behavior.
- `PATCH` for bug fixes, documentation fixes, and small internal improvements.

Tags use the `vMAJOR.MINOR.PATCH` format:

```bash
v0.1.0
v0.2.0
v0.2.1
v0.3.0-beta.1
```

Swift Package consumers still reference versions without the `v` prefix:

```swift
.package(url: "https://github.com/deekayd/decompkit.git", from: "0.1.0")
```

## Release Checklist

1. Make sure `main` is green in GitHub Actions.
2. Move relevant notes from `CHANGELOG.md` > `Unreleased` into a new version section.
3. Open and merge a release prep PR if the changelog changed.
4. Run the `Release` workflow from GitHub Actions or create and push the tag locally.
5. Confirm that the `Release` workflow created a GitHub Release.

## GitHub UI

1. Open `Actions` > `Release`.
2. Click `Run workflow`.
3. Select `Branch: main`.
4. Enter a tag like `v0.1.0`.
5. Click `Run workflow`.

The workflow validates the tag, builds `DecompKitDemo` in Release configuration, creates the tag if needed, and creates a GitHub Release with generated notes.

If a tag ruleset restricts creation of `v*` tags, allow the GitHub Actions app to bypass that tag ruleset, or create the tag manually as an allowed maintainer.

## Local Commands

You can also create a release by pushing a tag from the command line:

```bash
git checkout main
git pull --ff-only origin main
git tag -a v0.1.0 -m "v0.1.0"
git push origin v0.1.0
```

For a prerelease:

```bash
git tag -a v0.2.0-beta.1 -m "v0.2.0-beta.1"
git push origin v0.2.0-beta.1
```

Prerelease tags are published as GitHub prereleases.
