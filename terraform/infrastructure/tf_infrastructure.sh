#!/bin/bash
TF_BIN=$(which terraform)

function print_shell_command {
  echo
  echo "    [ executing ... ${SHELL_CMD} ]"
  echo
}

function set_tf_cmd_args {
  CONFIG_VARS="./${ENVIRONMENT}/config.tfvars"
  OUT_ARGS="-out=./terraform.plan"
  VARS_ARGS="-var-file=${CONFIG_VARS}"
  TF_CMD_OPTS="--force"
}

function tf_init {
  SHELL_CMD="${TF_BIN} init"
  print_shell_command
  ${SHELL_CMD}
  unset SHELL_CMD
}

function tf_get_modules {
  SHELL_CMD="${TF_BIN} get -update=true"
  print_shell_command
  ${SHELL_CMD}
  unset SHELL_CMD
}

function tf_validate {
  tf_get_modules
  set_tf_cmd_args
  SHELL_CMD="${TF_BIN} validate ${VARS_ARGS}"
  print_shell_command
  ${SHELL_CMD} && echo "terraform config syntax VALID"
  unset SHELL_CMD
}

function tf_plan {
  tf_validate
  SHELL_CMD="${TF_BIN} plan ${VARS_ARGS} ${OUT_ARGS}"
  print_shell_command
  ${SHELL_CMD}
  unset SHELL_CMD
}

function tf_apply {
  tf_plan
  SHELL_CMD="${TF_BIN} apply ${VARS_ARGS}"
  print_shell_command
  ${SHELL_CMD}
  unset SHELL_CMD
}

function tf_destroy {
  tf_validate
  SHELL_CMD="${TF_BIN} destroy ${TF_CMD_OPTS} ${VARS_ARGS}"
  print_shell_command
  ${SHELL_CMD}
  unset SHELL_CMD
}
