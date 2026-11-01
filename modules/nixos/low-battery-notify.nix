{ pkgs, ... }:

{
  systemd.user.services.low-battery-notify = {
    serviceConfig.Type = "oneshot";
    script = ''
      notified_marker=/tmp/low-battery-notification-sent

      battery=/sys/class/power_supply/BAT1
      battery_state=$(< $battery/status)
      charge_now=$(< $battery/charge_now)
      charge_full=$(< $battery/charge_full)
      charge_percentage=$(($charge_now * 100 / $charge_full))

      if [ "$battery_state" = "Discharging" ]; then
        if [ $charge_percentage -le 15 -a ! -f $notified_marker ]; then
          ${pkgs.libnotify}/bin/notify-send --urgency=critical "Low battery" \
            "Battery level is $charge_percentage%"
          touch $notified_marker
        fi
      else
        rm -f $notified_marker
      fi
    '';
  };

  systemd.user.timers.low-battery-notify = {
    wantedBy = [ "default.target" ];

    # start low-battery-notify.service every five minutes
    timerConfig.OnCalendar = "*:5/5";
  };
}
