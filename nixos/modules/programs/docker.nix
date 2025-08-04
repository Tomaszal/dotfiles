{config, ...}: {
  virtualisation.podman = {
    enable = true;

    # Create an alias mapping `docker` to `podman`
    dockerCompat = true;

    # Make the Podman socket available in place of the Docker socket, so Docker
    # tools can find the Podman socket
    dockerSocket.enable = true;

    # Required for containers under podman-compose to be able to talk to each other
    defaultNetwork.settings.dns_enabled = true;
  };

  # Allow main user to run podman without sudo
  users.groups.podman.members = [config.user.username];
}
