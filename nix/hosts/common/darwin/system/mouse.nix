{ ... }: {
  system.defaults = {
    magicmouse.MouseButtonMode = "TwoButton";
    NSGlobalDomain = {
      "com.apple.mouse.tapBehavior" = 1;
    };
    trackpad = {
      ActuationStrength = 1;
      Clicking = false;
      Dragging = false;
      FirstClickThreshold = 1;
      SecondClickThreshold = 2;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 0;
    };
  };
}
