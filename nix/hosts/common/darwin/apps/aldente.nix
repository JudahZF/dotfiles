{ ... }: {
  system.defaults.CustomUserPreferences = {
    "com.apphousekitchen.aldente-pro.plist" = {
      automaticDischarge = false;
      chargeVal = 80;
      clamshellDischargeMessage = false;
      continueCalibrationBehavior = 1;
      dataShareConsent = false;
      exitInhibitCharge = false;
      heatProtectMode = true;
      launchAtLogin = true;
      magsafeBlinkDischarge = true;
      magsafeControl = true;
      maxTemperature = 40;
      menuBarIconStyle = -1;
      menubarRightClickAction = 2;
      noMenubarIcon = false;
      popoverAnimation = false;
      popoverBatteryInfoList = [
        "temperature"
        "designCapacity"
        "adapterPower"
        "maxCapacity"
        "timeToFull"
        "batteryCurrent"
        "adapterVoltage"
        "adapterManufacturer"
        "macosCondition"
        "batteryVoltage"
        "lowPowerMode"
        "macosCapacity"
        "systemLoad"
        "cycleCount"
        "batteryPower"
        "adapterCurrent"
        "adapterName"
      ];
      popoverWidgets = [ "highAppUsage" "powerflow" "stats" ];
      sailingMode = true;
      sailingLevel = 5;
      showDockIcon = false;
      showGUIonStartup = false;
      showPercentage = true;
      showPercentagePopover = true;
      sleepInhibitCharge = true;
      useRealPercentage = false;
    };
  };
}
