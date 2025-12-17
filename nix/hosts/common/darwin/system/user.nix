{ username, ... }: {
  system = {
    stateVersion = 6;
    primaryUser = username;
  };

  users.users.${username}.home = "/Users/${username}";
}
