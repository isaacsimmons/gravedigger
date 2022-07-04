# Gravedigger

This project contains a few shell scripts that I use to archive repositories that I no longer need immediate access to.
The archived repositories are placed in a sibling "graveyard" directory.
In particular, it has scripts to:
* Create git [bundle](https://git-scm.com/docs/git-bundle)s from a repository URL and place it in the graveyard
* Restore a git bundle
* Synchronize the contents of the graveyard to a S3 bucket

## Dependencies

[git](https://git-scm.com/) must (unsurprisingly) be installed.
[AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) must be installed (and configured with `aws configure`) if you want to use the `./sync-s3.sh` command.

## Graveyard

The graveyard directory must exist and be a sibling of this one (available at `../graveyard`).
While not strictly necessary, I also like to have the graveyard be a git repository itself configured to store the bundles using [git-lfs](https://git-lfs.github.com/).

Git LFS can be installed and configured with the following commands (run in the graveyard):
```
git lfs install
git lfs track "*.bundle"
```

This way I have two remote backups of the archived repositories: uploaded to S3 by the `./sync-sh.sh` script and pushed to GitHub with a good old-fashioned `git push`.

## Example Usage

`./bury.sh git@github.com:isaacsimmons/foo-bar.git`

`./raise-dead.sh ../graveyard/foo-bar.bundle`

`./sync-s3.sh`
