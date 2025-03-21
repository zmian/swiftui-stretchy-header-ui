#!/bin/zsh

# 1. Run this script.
#    sh ./BuildTools/Scripts/build-docs.sh
# 2. Move the `docs` directory elsewhere.
# 3. Create a `gh-pages` branch and remove everything in it:
#    git checkout --orphan gh-pages && git rm -rf .
# 4. Push to the origin:
#    git push origin gh-pages
# 5. For future deployments, replace step 3 with:
#    git checkout gh-pages
swift package \
  --allow-writing-to-directory ./docs \
  generate-documentation \
  --target StretchyHeaderUI \
  --disable-indexing \
  --transform-for-static-hosting \
  --hosting-base-path /swiftui-stretchy-header-ui/main \
  --output-path ./docs
