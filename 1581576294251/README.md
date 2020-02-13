# GitHub Action for GitHub Push

The GitHub Actions for pushing to GitHub repository local changes authorizing using GitHub token.

With ease:
- update new code placed in the repository, e.g. by running a linter on it,
- track changes in script results using Git as archive,
- publish page using GitHub-Pages,
- mirror changes to a separate repository.

## Usage

### Example Workflow file

An example workflow to authenticate with GitHub Platform:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Push changes
      uses: 1005789164/push-action@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| name | value | default | description |
| ---- | ----- | ------- | ----------- |
| github_token | string | | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`. |
| user_email | string | 'action@github.com' | git config --local user.email "action@github.com" |
| user_name | string | 'GitHub Action' | git config --local user.name "GitHub Action" |
| directory | string | '.' | Directory to change to before pushing. |
| folder | boolean | false | Include a folder. |
| commit_msg | string | 'Add changes' | git commit -m "Add changes" -a |
| branch | string | 'master' | Destination branch to push changes. |
| force | boolean | false | Determines if force push is used. |
| tags | boolean | false | Determines if `--tags` is used. |

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

## No affiliation with GitHub Inc.

GitHub are registered trademarks of GitHub, Inc. GitHub name used in this project are for identification purposes only. The project is not associated in any way with GitHub Inc. and is not an official solution of GitHub Inc. It was made available in order to facilitate the use of the site GitHub.
