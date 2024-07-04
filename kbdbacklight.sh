#!/usr/bin/env bash

description() {
  echo "Script for managing keyboard backlight."
}

usage() {
  echo "usage: kbdbacklight.sh <option> <value>"
  echo "options:"
  echo "        -help         : display usage instuction"
  echo "        -get          : display current backlight value"
  echo "        -get-max      : display maximum backlight value"
  echo "        -inc <value>  : increase backlight by provided value"
  echo "        -dec <value>  : decrease backlight by provided value"
  echo "        -set <value>  : set backlight to provided value"
}

validate_arg_value() {
  value="$1"
  regex="^[0-9]+$"

  if ! [[ $value =~ $regex ]]; then
    echo "error: bad value"
    echo
    usage
    exit 1
  fi
}

exec_cmd() {
  curr_brt_value="$1"
  operator="$2"
  value="$3"

  expr "$curr_brt_value" "$operator" "$value" > "$brt_file"
}

brt_file="/sys/class/leds/smc::kbd_backlight/brightness"
max_brt_file="/sys/class/leds/smc::kbd_backlight/max_brightness"

curr_brt_value=$(cat $brt_file)

operator=""
value=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -help)
      description
      echo
      usage
      exit 0
      ;;
    -get)
      cat "$brt_file"
      exit 0
      ;;
    -get-max)
      cat "$max_brt_file"
      exit 0
      ;;
    -set)
      operator="+"
      value="$2"
      curr_brt_value=0
      ;;
    -inc)
      operator="+"
      value="$2"
      ;;
    -dec)
      operator="-"
      value="$2"
      ;;
    *)
      echo "error: unknown option"
      echo
      usage
      exit 1
  esac

  shift
  shift
done

validate_arg_value "$value"

exec_cmd "$curr_brt_value" "$operator" "$value"
