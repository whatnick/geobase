#!/bin/bash

set -eu
set -x

env_dir="${PYENV:-/env}"
pip="${env_dir}/bin/pip"
jupyter="${env_dir}/bin/jupyter"
cc="/conf"

env-build-tool new "${cc}/requirements.txt" "${env_dir}" /wheels
env-build-tool extend "${cc}/requirements-odc.txt" "${env_dir}" /wheels

while read line; do
    $jupyter labextension install --no-build $line
done < "${cc}/lab-extensions.txt"
$jupyter lab build

while read line; do
    $jupyter serverextension enable --py $line
done < "${cc}/lab-server-extensions.txt"
