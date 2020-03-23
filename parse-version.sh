# parse SNELL_VERSION
# example
# 1. SNELL_VERSION=1.1.1 -> MAIN_VERSION=1.1.1, BETA_VERSION is empty
# 2. SNELL_VERSION=2.0.0-b3 -> MAIN_VERSION=2.0.0, BETA_VERSION=b3
if [[ "${SNELL_VERSION}" =~ ^([0-9]\.[0-9]\.[0-9])(-(.*))?$ ]]; then
  MAIN_VERSION=${BASH_REMATCH[1]};
  if [[ -z ${BASH_REMATCH[2]} ]]; then
    echo "[INFO] BETA_VERSION is matched from ${SNELL_VERSION}"
  else
    BETA_VERSION=${BASH_REMATCH[2]};
    if [[ "${BETA_VERSION}" =~ ^-(.*)$ ]]; then
      BETA_VERSION=${BASH_REMATCH[1]}
      echo "MAIN_VERSION: ${MAIN_VERSION}, BETA_VERSION: ${BETA_VERSION}"
    fi
  fi
else
  echo "[ERROR] No MAIN_VERSION is matched from ${SNELL_VERSION}"
fi

# create SNELL_URL
# example
# 1. MAIN_VERSION=1.1.1 -> "https://github.com/surge-networks/snell/releases/download/v${MAIN_VERSION}/snell-server-v${MAIN_VERSION}-linux-amd64.zip"
# 2. MAIN_VERSION=2.0.0, BETA_VERSION=b3 -> "https://github.com/surge-networks/snell/releases/download/${MAIN_VERSION}${BETA_VERSION}/snell-server-v${MAIN_VERSION}-${BETA_VERSION}-linux-amd64.zip"
if [[ "${MAIN_VERSION}" =~ ^(1.*)$ ]]; then
  echo "[INFO] Snell 1.x.x is matched: main version(${MAIN_VERSION})"
  SNELL_URL="https://github.com/surge-networks/snell/releases/download/v${MAIN_VERSION}/snell-server-v${MAIN_VERSION}-linux-amd64.zip"
elif [[ "${MAIN_VERSION}" == "2.0.0" ]] && [[ ! -z "${BETA_VERSION}" ]]; then
  echo "[INFO] Snell 2.0.0 beta is matched: main version(${MAIN_VERSION}, beta version: ${BETA_VERSION})"
  SNELL_URL="https://github.com/surge-networks/snell/releases/download/${MAIN_VERSION}${BETA_VERSION}/snell-server-v${MAIN_VERSION}-${BETA_VERSION}-linux-amd64.zip"
else
  echo "[ERROR] No Snell version is matched."
  SNELL_URL=""
fi

echo ${SNELL_URL} > /snell-version
