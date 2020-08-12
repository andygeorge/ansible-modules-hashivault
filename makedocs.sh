#!/usr/bin/env bash
CHANGES=$(git diff-index --name-only HEAD --)
export PLUGINS=''
rm -rf ansible-repo
mkdir -p ansible-repo
cd ansible-repo
git clone --branch 'v2.9.6' https://github.com/ansible/ansible.git
pip install -r ansible/requirements.txt
pip install sphinx sphinx_rtd_theme
pip install straight.plugin
pip install sphinx-notfound-page==0.4
rm -rf ansible/lib/ansible/modules/ && mkdir -p ansible/lib/ansible/modules/hashivault
cp -r ../ansible/modules/hashivault/hashivault*.py ansible/lib/ansible/modules/hashivault/
rm -f ansible/lib/ansible/plugins/doc_fragments/hashivault.py
cp {..,ansible/lib}/ansible/plugins/doc_fragments/hashivault.py
ls ansible/lib/ansible/modules/hashivault
export MODULES=$(ls -m ansible/lib/ansible/modules/hashivault/ | grep -v '^_' | tr -d '[:space:]' | sed 's/.py//g')
cd ansible/docs/docsite/
rm -f $(find . -name developing_modules_general_windows.rst)
make webdocs || true
touch _build/html/.nojekyll
