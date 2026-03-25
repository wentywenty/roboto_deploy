#!/bin/bash
# Build roboto-deploy Debian package (Architecture: all, no cmake build)
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${WORKSPACE}/build_deb/roboto-deploy"
OUTPUT_DIR="${WORKSPACE}/deb_output"

PACKAGE="roboto-deploy"
VERSION="1.0.0"
PREFIX="/opt/roboparty"

echo ">>> Building ${PACKAGE} ${VERSION}"
mkdir -p "${OUTPUT_DIR}"
rm -rf "${BUILD_DIR}"

PKG_STAGE="${BUILD_DIR}/${PACKAGE}_${VERSION}_all"
mkdir -p "${PKG_STAGE}/DEBIAN"
mkdir -p "${PKG_STAGE}${PREFIX}/bin"
mkdir -p "${PKG_STAGE}${PREFIX}/share/${PACKAGE}"

# Startup script
cp "${SCRIPT_DIR}/start_robot.sh" "${PKG_STAGE}${PREFIX}/bin/"
chmod 755 "${PKG_STAGE}${PREFIX}/bin/start_robot.sh"

# Fast DDS QoS profile
cp "${SCRIPT_DIR}/rt_fastdds_profile.xml" "${PKG_STAGE}${PREFIX}/share/${PACKAGE}/"

# linux-router
if [ -f "${SCRIPT_DIR}/linux-router/lnxrouter" ]; then
    cp "${SCRIPT_DIR}/linux-router/lnxrouter" "${PKG_STAGE}${PREFIX}/bin/"
    chmod 755 "${PKG_STAGE}${PREFIX}/bin/lnxrouter"
else
    echo "WARNING: linux-router/lnxrouter not found (submodule not initialized?)"
fi

cp "${SCRIPT_DIR}/debian/control"   "${PKG_STAGE}/DEBIAN/"
cp "${SCRIPT_DIR}/debian/postinst"  "${PKG_STAGE}/DEBIAN/"
cp "${SCRIPT_DIR}/debian/postrm"    "${PKG_STAGE}/DEBIAN/"
[ -f "${SCRIPT_DIR}/debian/conffiles" ] && cp "${SCRIPT_DIR}/debian/conffiles" "${PKG_STAGE}/DEBIAN/"
chmod 755 "${PKG_STAGE}/DEBIAN/postinst" "${PKG_STAGE}/DEBIAN/postrm"

dpkg-deb --root-owner-group --build "${PKG_STAGE}" "${OUTPUT_DIR}/"
echo ">>> Done: ${OUTPUT_DIR}/${PACKAGE}_${VERSION}_all.deb"
