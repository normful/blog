# Personal blog

- Built with [Zola](https://www.getzola.org) in [GitHub Actions](https://github.com/normful/blog/actions).
- Deployed on Vercel at normful.com

# How-To: Deploy

1. `make` (or use local `makeblog` alias from any folder)
2. `git push`

# Caveats

- Don't forget to update `.gitattributes` if using a new image format.
- You might need to run `git lfs fetch` and `git lfs checkout` if you previously cloned this repo without installing `git-lfs` first.
