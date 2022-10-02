# Contribution Guide

Thanks for your interest in contributing, all contributions are welcome and this section should help you get started.

## Local setup

- Clone this repository
- Make sure you have PSScriptAnalyzer and Pester as well as PowerShell 7+ installed. We recommend using VSCode.
- Check out a new branch for your contribution (`git checkout -b 'feature/fantastic-new-function'`)

## Commit convention

Before contributing, you should be familiar with the following concepts:

- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [gitmoji](https://gitmoji.dev/) - Usage of gitmoji is optional, but highly preferred. It's helping a lot with identifying the exact type of commit on first sight and has basically no overhead when using tools like `gacp`

To create valid commit messages, you have to use conventional commits. For the type, it's preferred to use emojis with optional text and to use scopes where possible. We use the following defined types with optional scopes to be able to comply with semver and make automatic CHANGELOG generation and tagging/versioning possible:

- build
- chore
- ci
- docs
- feat
- fix
- perf
- refactor
- revert
- style
- test

We recommend to use a tool like [gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli) or [gacp](https://github.com/vivaxy/gacp) to make following these requirements easier.

Note that `fix:` and `feat:` are for code changes. For typo or document changes, use `docs:` or `chore:` instead.

## Pull request

If you finished your change, you can create a pull request (PR) to get them merged. If you are not familiar with the process, GitHub has a [guide on PRs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

:warning: **Before creatign a PR, please make sure that no tests are failing (`Invoke-Pester`) and PSScriptAnalyzer (`Invoke-ScriptAnalyzer -Path .\ -Settings PSGallery -Recurse -Severity Error`) doesn't return any errors.**

Make sure, you have updated the wiki submodule in the `wiki` folder:

```PowerShell
Set-Location wiki
git pull
Set-Location ..
```

If you are closing issues with a PR, please reference the issues in the PR description (`fix/fixes #123` where 123 is the issue id).
