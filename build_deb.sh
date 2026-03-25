#!/bin/bash
# Build roboto-deploy Debian package (Architecture: all, no cmake build)
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

PACKAGE="roboto-deploy"
VERSION="1.0.1"
PREFIX="/opt/roboparty"
DEB_DIR="${PACKAGE}_${VERSION}_all"

echo ">>> Building ${PACKAGE} ${VERSION}"

# Clean previous artifacts
rm -rf "${DEB_DIR}" "${DEB_DIR}.deb"
mkdir -p "${DEB_DIR}/DEBIAN"
mkdir -p "${DEB_DIR}${PREFIX}/bin"
mkdir -p "${DEB_DIR}${PREFIX}/share/${PACKAGE}"

# Startup script
cp "start_robot.sh" "${DEB_DIR}${PREFIX}/bin/"
chmod 755 "${DEB_DIR}${PREFIX}/bin/start_robot.sh"

# Fast DDS QoS profile
cp "rt_fastdds_profile.xml" "${DEB_DIR}${PREFIX}/share/${PACKAGE}/"

# linux-router
if [ -f "linux-router/lnxrouter" ]; then
    cp "linux-router/lnxrouter" "${DEB_DIR}${PREFIX}/bin/"
    chmod 755 "${DEB_DIR}${PREFIX}/bin/lnxrouter"
else
    echo "WARNING: linux-router/lnxrouter not found (submodule not initialized?)"
fi

# Debian control files
cp "debian/control"   "${DEB_DIR}/DEBIAN/"
cp "debian/postinst"  "${DEB_DIR}/DEBIAN/"
cp "debian/postrm"    "${DEB_DIR}/DEBIAN/"

# Replace VERSION_PLACEHOLDER
sed -i "s/VERSION_PLACEHOLDER/${VERSION}/" "${DEB_DIR}/DEBIAN/control"

if [ -f "debian/conffiles" ]; then
    # Only copy if not empty (to avoid dpkg error)
    if [ -s "debian/conffiles" ]; then
        cp "debian/conffiles" "${DEB_DIR}/DEBIAN/"
    fi
fi

chmod 755 "${DEB_DIR}/DEBIAN/postinst" "${DEB_DIR}/DEBIAN/postrm"

echo ">>> Executing dpkg-deb build..."
dpkg-deb --root-owner-group --build "${DEB_DIR}"

echo ">>> Success! Generated ${DEB_DIR}.deb"
