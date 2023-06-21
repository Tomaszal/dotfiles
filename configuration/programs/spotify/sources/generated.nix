# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  autoVolumeSrc = {
    pname = "autoVolumeSrc";
    version = "d7f7962724b567a8409ef2898602f2c57abddf5a";
    src = fetchgit {
      url = "https://github.com/amanharwara/spicetify-autoVolume";
      rev = "d7f7962724b567a8409ef2898602f2c57abddf5a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-WquDmeaj+7M8DzGuHYOJgF6ifcs3vj3gIciZMaRQ3t4=";
    };
    date = "2020-02-16";
  };
  bloomSrc = {
    pname = "bloomSrc";
    version = "645446250a59ce1fb596f4cf802836b93a442784";
    src = fetchgit {
      url = "https://github.com/nimsandu/spicetify-bloom";
      rev = "645446250a59ce1fb596f4cf802836b93a442784";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-xauPurxLtUaDfnc+AcK4JiNQId8A5KSCL4nigorVa9o=";
    };
    date = "2023-06-21";
  };
  catppuccinSrc = {
    pname = "catppuccinSrc";
    version = "0b602142da4a436f7012c07137e846034aea82cb";
    src = fetchgit {
      url = "https://github.com/catppuccin/spicetify";
      rev = "0b602142da4a436f7012c07137e846034aea82cb";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-dBJ0vLvCdzpZZNHrsY6V8JQ2t4RB2L5OF/MdHGmIk4Y=";
    };
    date = "2023-05-26";
  };
  charlieS1103Src = {
    pname = "charlieS1103Src";
    version = "cd832c84f3d6ec8ff9190ae3012fbe8baa8f1797";
    src = fetchgit {
      url = "https://github.com/CharlieS1103/spicetify-extensions";
      rev = "cd832c84f3d6ec8ff9190ae3012fbe8baa8f1797";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-44vl2KjBAZILalHXOB24/h4fMYLcb1CHgEOP52m5xxE=";
    };
    date = "2023-06-18";
  };
  comfySrc = {
    pname = "comfySrc";
    version = "3c5681d432554063f765d3c5d355b24d3fc80499";
    src = fetchgit {
      url = "https://github.com/Comfy-Themes/Spicetify";
      rev = "3c5681d432554063f765d3c5d355b24d3fc80499";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-RqeLaEI/ghJ8aVgPSZmiQLIQJs0cfRQKhJ1347W4j8w=";
    };
    date = "2023-06-20";
  };
  customAppsExtensionsSrc = {
    pname = "customAppsExtensionsSrc";
    version = "0f5e79fe43abf57f714d7d00bd288870d5b6f718";
    src = fetchgit {
      url = "https://github.com/3raxton/spicetify-custom-apps-and-extensions";
      rev = "0f5e79fe43abf57f714d7d00bd288870d5b6f718";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-4zL/z8dCafy5V95ASR3c6TffMh9wdpnclAjddD9TX84=";
    };
    date = "2022-05-02";
  };
  dakshExtensions = {
    pname = "dakshExtensions";
    version = "1ba98f88076d7c95ea4a10c59e1238504d5e2cc8";
    src = fetchgit {
      url = "https://github.com/daksh2k/Spicetify-stuff";
      rev = "1ba98f88076d7c95ea4a10c59e1238504d5e2cc8";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-6qXryMKxgVQbLFYWA2LnsX+ooUmtTFs5crnwKpcJlQQ=";
    };
    date = "2023-06-07";
  };
  defaultDynamicSrc = {
    pname = "defaultDynamicSrc";
    version = "c9b70479a5445c09fadb575d2d5cf940b871ff4d";
    src = fetchgit {
      url = "https://github.com/JulienMaille/spicetify-dynamic-theme";
      rev = "c9b70479a5445c09fadb575d2d5cf940b871ff4d";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-cj6Se4lJFTg1j+4vclnfp1qWF5FkHzBZqUldrj70Akw=";
    };
    date = "2022-09-17";
  };
  draculaSrc = {
    pname = "draculaSrc";
    version = "97bf149e7afbe408509862591a57f1d8e2dfc5d7";
    src = fetchgit {
      url = "https://github.com/Darkempire78/Dracula-Spicetify";
      rev = "97bf149e7afbe408509862591a57f1d8e2dfc5d7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-IS0A/5zTZou9yQJ0zpqAwiW2COt/TGoscN99WGFR9FA=";
    };
    date = "2022-02-14";
  };
  fluentSrc = {
    pname = "fluentSrc";
    version = "772cd8491105d679c7d3d1ff3f927b4a3dbb0e62";
    src = fetchgit {
      url = "https://github.com/williamckha/spicetify-fluent";
      rev = "772cd8491105d679c7d3d1ff3f927b4a3dbb0e62";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-IrSIW0tVLvu9k2QMzkT8yFhmghOhIT7PfdTie8D7tL8=";
    };
    date = "2022-12-11";
  };
  genreSrc = {
    pname = "genreSrc";
    version = "f2cb950a7e27cce3bfd4168141b5c5e55552df5a";
    src = fetchgit {
      url = "https://github.com/Shinyhero36/Spicetify-Genre";
      rev = "f2cb950a7e27cce3bfd4168141b5c5e55552df5a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-R7D6oiSZviZQiMo6GSe4phQKfUmLNToXkyv6F4JXf3M=";
    };
    date = "2023-03-04";
  };
  groupSessionSrc = {
    pname = "groupSessionSrc";
    version = "a9fa45da69495137b2f7272f61ff8d1a457aef5b";
    src = fetchgit {
      url = "https://github.com/timll/spotify-group-session";
      rev = "a9fa45da69495137b2f7272f61ff8d1a457aef5b";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-YTbnNLzPc0iMJZfH3QwSEX/gpAqIlchmbsULjM8musA=";
    };
    date = "2022-09-15";
  };
  hidePodcastsSrc = {
    pname = "hidePodcastsSrc";
    version = "26db2194dabfdb3a2af17c357201cac97ebe72d8";
    src = fetchgit {
      url = "https://github.com/theRealPadster/spicetify-hide-podcasts";
      rev = "26db2194dabfdb3a2af17c357201cac97ebe72d8";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-AJm67P+HHrT52GsUQK6alEEjclLQJhafyiBaW9QJ4N4=";
    };
    date = "2023-06-13";
  };
  historySrc = {
    pname = "historySrc";
    version = "577e34f364127f18d917d2fe2e8c8f2a1af9f6ae";
    src = fetchgit {
      url = "https://github.com/einzigartigerName/spicetify-history";
      rev = "577e34f364127f18d917d2fe2e8c8f2a1af9f6ae";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-ORG1oNvMTJxrI3spfAuN+pCKTKvQfhqUIYT9NM1yZTs=";
    };
    date = "2021-05-20";
  };
  huhExtensionsSrc = {
    pname = "huhExtensionsSrc";
    version = "8cca264223e99e9f416182c00ccd182746a18ac6";
    src = fetchgit {
      url = "https://github.com/huhridge/huh-spicetify-extensions";
      rev = "8cca264223e99e9f416182c00ccd182746a18ac6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-6tX4z5TzFKLGQmPXyBz2sns0YgIkBCt3pMn0jSWTGCA=";
    };
    date = "2023-01-29";
  };
  lastfmSrc = {
    pname = "lastfmSrc";
    version = "d2f1d3c1e286d789ddfa002f162405782d822c55";
    src = fetchgit {
      url = "https://github.com/LucasBares/spicetify-last-fm";
      rev = "d2f1d3c1e286d789ddfa002f162405782d822c55";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-/C4Y3zuSAEwhMXCRG2/4b5oWfGz/ij6wu0B+CpuJKXs=";
    };
    date = "2022-11-20";
  };
  localFilesSrc = {
    pname = "localFilesSrc";
    version = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
    src = fetchgit {
      url = "https://github.com/hroland/spicetify-show-local-files";
      rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-neKR2WaZ1K10dZZ0nAKJJEHNS56o8vCpYpi+ZJYJ/gU=";
    };
    date = "2022-04-12";
  };
  marketplaceSrc = {
    pname = "marketplaceSrc";
    version = "e56660dea35590c387302e945b209c20622ebd95";
    src = fetchgit {
      url = "https://github.com/spicetify/spicetify-marketplace";
      rev = "e56660dea35590c387302e945b209c20622ebd95";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-w7lgCHRb1jC0mZHbWHcwbFbsll+X06ATnz/qfUFgxZk=";
    };
    date = "2023-06-14";
  };
  nameThatTuneSrc = {
    pname = "nameThatTuneSrc";
    version = "2d95c3b5230597d6142b7e9c060cde15760cfb75";
    src = fetchgit {
      url = "https://github.com/theRealPadster/name-that-tune";
      rev = "2d95c3b5230597d6142b7e9c060cde15760cfb75";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-UFUTW7wX1PHDLEePXnipYAaDdv5DeqZLwbEWF9vyK8w=";
    };
    date = "2023-04-12";
  };
  nordSrc = {
    pname = "nordSrc";
    version = "caab9e0afaa6d228b4d73ae6c4c40dd56d3888c7";
    src = fetchgit {
      url = "https://github.com/Tetrax-10/Nord-Spotify";
      rev = "caab9e0afaa6d228b4d73ae6c4c40dd56d3888c7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-HlywN6a6nQ9Z1Rsg3crkFQuY+npXaN4Qo9cjPLfeqmw=";
    };
    date = "2023-06-06";
  };
  officialSrc = {
    pname = "officialSrc";
    version = "53b7f1f304376f5bde5a7b6b505c27c3fd216d84";
    src = fetchgit {
      url = "https://github.com/spicetify/spicetify-cli";
      rev = "53b7f1f304376f5bde5a7b6b505c27c3fd216d84";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-48pRQ0BPtgGE2Wxvjb90rxI1L2NGB/Gy5bOVEGzgjuw=";
    };
    date = "2023-06-20";
  };
  officialThemes = {
    pname = "officialThemes";
    version = "1eb8d413945d542825e08faec087d931e4e73fa8";
    src = fetchgit {
      url = "https://github.com/spicetify/spicetify-themes";
      rev = "1eb8d413945d542825e08faec087d931e4e73fa8";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-Uytrb3qw/Qer7GAIdYFV0JWR2qT5BiiKm7+gfAwdokw=";
    };
    date = "2023-06-21";
  };
  omniSrc = {
    pname = "omniSrc";
    version = "253ae45d2cac2dc3d92a43193ea8f6d9e7e1d3aa";
    src = fetchgit {
      url = "https://github.com/getomni/spicetify";
      rev = "253ae45d2cac2dc3d92a43193ea8f6d9e7e1d3aa";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-5II+4096fOcCA7J4XZfIHSse+3/YJ+EY5KW3GXl+dn8=";
    };
    date = "2023-01-20";
  };
  orchisSrc = {
    pname = "orchisSrc";
    version = "5bf3fcf0696514dcf3e95f4ae3fd00261ccc5dcc";
    src = fetchgit {
      url = "https://github.com/canbeardig/Spicetify-Orchis-Colours-v2";
      rev = "5bf3fcf0696514dcf3e95f4ae3fd00261ccc5dcc";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-9cU2Wlg5W57JpBfzIOXvpRYI8Q3CsH+UsdjQseTr9bs=";
    };
    date = "2022-05-20";
  };
  playlistIconsSrc = {
    pname = "playlistIconsSrc";
    version = "4e2fdda5079b441eca8d4d9f7479db82f6cc20b8";
    src = fetchgit {
      url = "https://github.com/jeroentvb/spicetify-playlist-icons";
      rev = "4e2fdda5079b441eca8d4d9f7479db82f6cc20b8";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-ocDsR4+AAfycWcs1H3JV1h7WgIONlu3BQ148cnAMOPI=";
    };
    date = "2023-03-31";
  };
  powerBarSrc = {
    pname = "powerBarSrc";
    version = "3b7e0559e91e76975cca41bafdb4ea2990dd468a";
    src = fetchgit {
      url = "https://github.com/jeroentvb/spicetify-power-bar";
      rev = "3b7e0559e91e76975cca41bafdb4ea2990dd468a";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-4sZnfnwwhMSrwbS1tFV6bUlifz9g4MUl0fDlZDzolRU=";
    };
    date = "2023-05-04";
  };
  retroBlurSrc = {
    pname = "retroBlurSrc";
    version = "fd682396ed98a5ccfa68438a42bb26ce934e3cbd";
    src = fetchgit {
      url = "https://github.com/Motschen/Retroblur";
      rev = "fd682396ed98a5ccfa68438a42bb26ce934e3cbd";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-UEy/80uQics2xn7ISqIGBqLkeJuOq9BBP7tWoa4s+lw=";
    };
    date = "2023-05-30";
  };
  spotifyCanvasSrc = {
    pname = "spotifyCanvasSrc";
    version = "ee7a441503e9fb763be81d868d9e1dd8d748a924";
    src = fetchgit {
      url = "https://github.com/itsmeow/Spicetify-Canvas";
      rev = "ee7a441503e9fb763be81d868d9e1dd8d748a924";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-OKovKLBwsiNWo3rux5waDefI5qFu2pou21WmRsN4h4Y=";
    };
    date = "2023-05-11";
  };
  spotifyNoPremiumSrc = {
    pname = "spotifyNoPremiumSrc";
    version = "f6efff59ee7ecf25ebdf4efba4b3ffdcdd8d5b45";
    src = fetchgit {
      url = "https://github.com/Daksh777/SpotifyNoPremium";
      rev = "f6efff59ee7ecf25ebdf4efba4b3ffdcdd8d5b45";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-8Ic410OYURUCnZ+ke+/MI2WHnt7peIWe2czomWmodZM=";
    };
    date = "2023-04-16";
  };
  spotifywmSrc = {
    pname = "spotifywmSrc";
    version = "8624f539549973c124ed18753881045968881745";
    src = fetchgit {
      url = "https://github.com/dasJ/spotifywm";
      rev = "8624f539549973c124ed18753881045968881745";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
    };
    date = "2022-10-25";
  };
  startPageSrc = {
    pname = "startPageSrc";
    version = "d8764bcf7c5009318b489a66491c1b15e5d8bdf7";
    src = fetchgit {
      url = "https://github.com/Resxt/startup-page";
      rev = "d8764bcf7c5009318b489a66491c1b15e5d8bdf7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-mA+S5f1tZ+/K4G+iKm/9Ze7rCmLXhhOwUfwM/WsdDHs=";
    };
    date = "2023-04-16";
  };
  tetraxSrc = {
    pname = "tetraxSrc";
    version = "996f0c6eab8b55701ab40718565541dd049b1e52";
    src = fetchgit {
      url = "https://github.com/Tetrax-10/Spicetify-Extensions";
      rev = "996f0c6eab8b55701ab40718565541dd049b1e52";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-7M/NRRD9NUP06U58hBq3EH5jjmCAHTuFMYxUNBKaOGY=";
    };
    date = "2023-06-04";
  };
}
