#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

set -euo pipefail
source "config/settings.conf"

#notify-send "$1" # Linux desktop notification

notificationSound() {
  if [ "$SOUNDS" = true ]; then
    if command -v paplay &>/dev/null; then
      paplay "$SCRIPT_DIR/sounds/$1" & # Linux (PulseAudio) -> Fixed Blocking of script
    elif command -v afplay &>/dev/null; then
      afplay "$SCRIPT_DIR/sounds/$1" & # macOS (Built-in)
      #elif command -v powershell.exe &>/dev/null; then
      #powershell.exe -c (New-Object Media.SoundPlayer 'sounds\"$1"').PlaySync()  # Windows
    else
      echo "No supported audio player found."
    fi
  fi
}

sendNotification() {
  if [ "$NOTIFICATIONS" = true ]; then
    message="${1:-Task Completed!}" # Use first argument or default message

    if command -v notify-send &>/dev/null; then
      notify-send -i "$SCRIPT_DIR/logo.png" \
        -t 1000 \
        -a "Bashodoro" \
        "Bashodoro" "$message"

    elif command -v osascript &>/dev/null; then
      osascript -e "display notification \"$message\" with title \"BASHodoro\""

    elif command -v powershell.exe &>/dev/null; then
      powershell.exe -Command "[System.Windows.Forms.MessageBox]::Show('$message')"

    else
      echo "No notification tool found. Message: $message"
    fi
  fi
}

case "$1" in
start)
  sendNotification "Timer Started!"
  notificationSound "joyous.wav"
  ;;
pause)
  sendNotification "Timer Paused!"
  notificationSound "slick.wav"
  ;;
resume)
  sendNotification "Timer Resumed!"
  notificationSound "jokingly.wav"
  ;;
stop)
  sendNotification "Timer Stopped!"
  notificationSound "joyous.wav"
  ;;
complete)
  sendNotification "Time's up!"
  notificationSound "jokingly.wav"
  ;;
*) echo "Usage: $0 {start|pause|resume|stop}" ;;
esac
