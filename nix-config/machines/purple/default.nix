extra:
{ config, lib, pkgs, ... }: { 
  imports = [
    ./hardware
    ./networking
    #(import ./nginx extra)
    #(import ./sheetzen extra)
    #(import ./vidstats extra)
  ];

  users.extraUsers.purple =  {
      name = "purple";
      isNormalUser = true;
      group = "users";
      uid = 1001;
      extraGroups = [ "wheel" "dialout" ];
      home = "/home/purple";
      createHome = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNLTLt7dwKwq7guDG5GYJBG+5x8SFTi06upWvxE7Cyy danielnogueira@Daniels-MacBook-Pro.local"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKMkKFzVDAXG+0sz1UjXgJHmh1+EE7dJ9WUJF14uAfFRv1SGUsohddvguxjrfbo1isen6sptDioJkeffcBCnYC88xvVWt/DRL4L8QV2NUUgv0SFCDCYOAaQ92pAv1J0WbSbI5hD0MZG5GQAA9dX8lLaxBX6nnByvrUFbvXusMrrywSNbm0nHXZD/y49WiZn5Hh9bMbviNLVNXMlUxzjQmY6rf+cxunAEQrXv3kD8aHb4p4+qGYCTpI17+tKogYet5Rg/VW4yg6LonpEfOlwTG50uIYoBE/peCs5xKUShQCs8UQGE/NEYjqaR9wt+tM74xoKECLLweyP8jxhrK+VTHn jb55@quiver"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdB7XdA4MupSTIRsv1y4OMiXPBZn+DasePrA57k4EVigAfB0Lv5vW7Y2QHvqGKP9vBtIVEMhsgMuIQxXaS7JzibzXvjuC82jZVsd6BuS+Msz5WbZREVzGSEM8RMDCS19gR3s8nwW6Y6FkFmhmqgNqLVM8ular+3ThPEAW56s9tJ9LyWJ/mymNQ5XuNBajx3rOmy0j+uBbrkaZHs33P6R367lhspywtKK9uzfOaIAWlcFHgx/D7ahR1vq+jALniADU0cNqJNWlD4hshM2+03WtmIHIMIvmST1iKIs/uvitBqeY/h2fuxfRfcDXtByR6t1MqJOvUI3Z2sBi1PZsCNMenPWXN3W50HoKwRLOeoN3e/LKUX2LaNS7KqAczx7Nf6eJf1I1quq5FLN3pabfU/ulkYG8IK29FfLwW0ljEUOBO412AG9e1dhvnxRICHqBuHHJHUEqXsE1pg8G3NXCqrJ/rg8Kig81dmRlMlc06uOeRLWfX4/N0zP0DP7qOeY69zTc= jb55@nostrich"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgRmgFPb8TA9NAeh9zBg6xZLniaML3ZNI9IMTNX8SIEux4MIhvyzJOCQOGj3P7lTJQRDBL0Hv8s24Krr55EZQQwRk+glNC3/B4JI8W9wmNzhm3d1UnEPgsCZ4M8ryc+5CIEMEuqmlqiqaU1EsLIf7fMO9AmNzV+hrnBc/Vsg8ko+5cKsgb/XX7awbGbR88F2FbpSYrmYQLG6/PnjqA0lORPNl2FcOfvc5VUPxoeiqASJF++awqPUeWGHKgAhi7vATWxqNL3N91Xsn2qWLgtYar4HTzp0LpzrybLikaed2f/dTM4utoeygcGnzU4zKeT7rc7S7gtY8irOl09VRpM66h jb55@monad"
      ];
  };
}
