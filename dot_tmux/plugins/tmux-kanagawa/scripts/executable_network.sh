#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

HOSTS="google.com github.com example.com"
network_interface=$(get_tmux_option "@kanagawa-network-bandwidth" "en0")
wifi_label=$(get_tmux_option "@kanagawa-network-wifi-label" "")
ethernet_label=$(get_tmux_option "@kanagawa-network-ethernet-label" "Ethernet")

get_ssid() {
  # Check OS
  case $(uname -s) in
  Linux)
    SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
    if [ -n "$SSID" ]; then
      printf '%s' "$SSID"
    else
      echo 'Ethernet'
    fi
    ;;

  Darwin)
    local wifi_network
    local airport

    wifi_network=$(ipconfig getsummary $network_interface | awk -F ' SSID : ' '/ SSID : / {print $2}')
    airport=$(networksetup -getairportnetwork $network_interface | cut -d ':' -f 2)

    if [[ $airport != "You are not associated with an AirPort network." ]]; then
      echo "$wifi_label$airport" | sed 's/^[[:blank:]]*//g'
    elif [[ $wifi_network != "" ]]; then
      echo "$wifi_label$wifi_network" | sed 's/^[[:blank:]]*//g'
    else
      echo "$ethernet_label"
    fi
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # leaving empty - TODO - windows compatability
    ;;

  *) ;;
  esac

}

main() {
  network="Offline"
  for host in $HOSTS; do
    if ping -q -c 1 -W 1 $host &>/dev/null; then
      network="$(get_ssid)"
      break
    fi
  done

  echo "$network"
}

#run main driver function
main
