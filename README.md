# Personal blog

- Built with [Zola](https://www.getzola.org) v0.15.3
- Deployed on Vercel
  - I didn't use the Zola preset because it is hardcoded to use Zola 0.13.0
    - Attempting to set `ZOLA_VERSION` only helped partially, but failed because Vercel's environment is missing required glib libraries.
    - Attempting to download, untar, and run a Zola release binary also failed, again because of the missing libraries.
  - Instead, I just run `zola build` locally and check in the generated `public` directory.
