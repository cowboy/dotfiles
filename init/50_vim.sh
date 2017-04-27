TMP_FILE="/tmp/install-${RANDOM}"
BUNDLE_DIR=$(realpath ~/.config/nvim/bundles/)

if [ ! -d ${BUNDLE_DIR} ]; then
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${TMP_FILE}
  bash ${TMP_FILE} ${BUNDLE_DIR}
  rm ${TMP_FILE}
fi
