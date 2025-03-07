# Generate the node-gyp formatted filename from the node environment
npm install --global detect-libc

FILENAME=$(
  node -e "
    var p = process, v = p.versions, libc = require('detect-libc').familySync() || 'unknown';
    const tagName = p.env.UPLOAD_TO || p.env.CANVAS_VERSION_TO_BUILD;
    const arch = p.env.CANVAS_ARCH_TO_BUILD || p.arch;
    console.log(['canvas', tagName, 'node-v' + v.modules, p.platform, libc, arch].join('-'));
  "
).tar.gz;

# Zip up the release
tar -C build -czvf $FILENAME Release

if [ $? -ne 0 ]; then
  echo "failed to make tarball $FILENAME from node-canvas/build"
  exit 1;
else
  echo "::set-output name=asset_name::$FILENAME"
fi
