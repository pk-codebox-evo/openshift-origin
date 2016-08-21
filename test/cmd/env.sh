#!/bin/bash
source "$(dirname "${BASH_SOURCE}")/../../hack/lib/init.sh"
trap os::test::junit::reconcile_output EXIT

os::test::junit::declare_suite_start "cmd/set-env"
# This test validates the value of --image for oc run
os::cmd::expect_success 'oc new-app node'
os::cmd::expect_failure_and_text 'oc set env dc/node' 'error: at least one environment variable must be provided'
os::cmd::expect_success_and_text 'oc set env dc/node key=value' 'deploymentconfig "node" updated'
os::cmd::expect_success_and_text 'oc set env dc/node --list' 'deploymentconfigs node, container node'
os::cmd::expect_success_and_text 'oc set env dc --all --containers="node" key-' 'deploymentconfig "node" updated'
os::cmd::expect_failure_and_text 'oc set env dc --all --containers="node"' 'error: at least one environment variable must be provided'
os::cmd::expect_failure_and_not_text 'oc set env --from=secret/mysecret dc/node' 'error: at least one environment variable must be provided'
echo "oc set env: ok"
os::test::junit::declare_suite_end
