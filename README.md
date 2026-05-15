# nixconf

NixOS モジュール集。flake input として取り込み、`nixosModules` 経由で各機能を有効化する。

---

## 使い方

### 1. ローカルマシン側の flake.nix

```nix
{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url    = "github:NixOS/nixpkgs/nixos-unstable";
    nixconf.url    = "github:sashisashi569/nixconf";
  };

  outputs = { self, nixpkgs, nixconf, ... }: {
    nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixconf.nixosModules.default   # 全オプションを登録
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
```

### 2. configuration.nix（マシン固有設定）

全モジュールをまとめて有効化する場合：

```nix
{ pkgs, ... }: {
  # nixconf の全モジュールを一括有効化
  nixconf.enable = true;

  # boot モジュール固有の設定（必須）
  nixconf.boot.luks.device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";

  # 個別に上書きも可能
  nixconf.homed.enable             = false;  # homed は使わない
  nixconf.network.tailscale.enable = true;
  nixconf.packages.extra           = with pkgs; [ firefox mpv ];

  # ホスト基本設定
  networking.hostName = "mymachine";
  time.timeZone       = "Asia/Tokyo";
  i18n.defaultLocale  = "ja_JP.UTF-8";

  users.users.youruser = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "networkmanager" "video" "audio" ];
  };

  system.stateVersion = "25.05";
}
```

モジュールを個別に選んで有効化する場合：

```nix
{ pkgs, ... }: {
  nixconf.boot.enable              = true;
  nixconf.boot.luks.device         = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
  nixconf.desktop.enable           = true;
  nixconf.audio.enable             = true;
  nixconf.bluetooth.enable         = true;
  nixconf.fcitx5.enable            = true;
  nixconf.network.enable           = true;
  nixconf.network.tailscale.enable = true;
  nixconf.security.enable          = true;
  nixconf.yubikey.enable           = true;
  nixconf.fonts.enable             = true;
  nixconf.keychron.enable          = true;
  nixconf.generations.enable       = true;
  nixconf.packages.enable          = true;
  nixconf.packages.extra           = with pkgs; [ firefox ];

  networking.hostName = "mymachine";
  system.stateVersion = "25.05";
}
```

---

## 提供モジュール

`nixconf.nixosModules.default` をインポートすると以下のすべてのオプションが利用可能になる。

| モジュール | 説明 |
|---|---|
| `nixconf.boot` | lanzaboote (Secure Boot + UKI)、systemd-initrd、systemd-cryptenroll |
| `nixconf.desktop` | Hyprland、kitty、dolphin、gvfs、udisks2、greetd |
| `nixconf.fcitx5` | fcitx5 + Mozc（日本語入力） |
| `nixconf.network` | NetworkManager（乱数MAC）、systemd-resolved stub、Tailscale |
| `nixconf.audio` | PipeWire（ALSA / PulseAudio / JACK 互換） |
| `nixconf.bluetooth` | BlueZ + blueman |
| `nixconf.security` | FIDO2/U2F PAM、GPG エージェント、GNOME Keyring、seahorse |
| `nixconf.yubikey` | YubiKey Authenticator デーモン（pcscd + udev ルール） |
| `nixconf.homed` | systemd-homed（ポータブル暗号化ホームディレクトリ） |
| `nixconf.packages` | git、vim、pavucontrol、home-manager |
| `nixconf.fonts` | CJK フォント（Noto Sans/Serif CJK）と fontconfig 設定 |
| `nixconf.keychron` | Keychron キーボード udev 修正（ジョイスティック誤認識を抑制） |
| `nixconf.generations` | nixos-rebuild 時の古いシステム世代の自動削除 |

---

## 主要オプション一覧

```nix
nixconf.enable                       # bool  — 全モジュールを一括有効化

nixconf.boot.enable                  # bool
nixconf.boot.pkiBundle               # str   — default: "/var/lib/sbctl"
nixconf.boot.luks.device             # str   — LUKS デバイスパス (by-uuid 推奨)
nixconf.boot.fido2.enable            # bool  — default: true
nixconf.boot.tpm2.enable             # bool  — default: true

nixconf.desktop.enable               # bool
nixconf.desktop.xwayland.enable      # bool  — default: true

nixconf.fcitx5.enable                # bool

nixconf.network.enable               # bool
nixconf.network.randomMac            # bool  — default: true
nixconf.network.tailscale.enable     # bool

nixconf.audio.enable                 # bool
nixconf.audio.support32Bit           # bool  — default: true (Steam / Wine 向け)

nixconf.bluetooth.enable             # bool
nixconf.bluetooth.powerOnBoot        # bool  — default: true

nixconf.security.enable              # bool
nixconf.security.pam.u2f.enable      # bool  — default: true

nixconf.yubikey.enable               # bool

nixconf.homed.enable                 # bool

nixconf.packages.enable              # bool
nixconf.packages.extra               # listOf package — default: []

nixconf.fonts.enable                 # bool

nixconf.keychron.enable              # bool

nixconf.generations.enable           # bool
nixconf.generations.keep             # int   — default: 3 (保持する世代数)
```

---

## 初回セットアップ手順

### Secure Boot（lanzaboote）

```bash
# 1. Secure Boot キーを生成する
sbctl create-keys

# 2. キーを UEFI に登録する（Microsoft キーを残す場合は --microsoft を付ける）
sbctl enroll-keys --microsoft

# 3. nixos-rebuild 後、UKI に署名されているか確認する
sbctl verify
```

### systemd-cryptenroll（LUKS 解錠トークン登録）

```bash
# FIDO2（YubiKey）で解錠する場合
systemd-cryptenroll /dev/nvme0n1p2 --fido2-device=auto

# TPM2 で解錠する場合（PCR 0+2+7 が一般的）
systemd-cryptenroll /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7

# 登録済みトークンを確認する
systemd-cryptenroll /dev/nvme0n1p2
```

### PAM U2F（YubiKey 二要素認証）

```bash
mkdir -p ~/.config/Yubico
pamu2fcfg >> ~/.config/Yubico/u2f_keys
```

### home-manager（スタンドアロン）

```bash
# 初回
home-manager switch --flake /path/to/your/home-flake#youruser@mymachine

# 以降
home-manager switch --flake .
```

---

## ビルドと適用

```bash
# システム設定を適用する
sudo nixos-rebuild switch --flake .#mymachine

# 動作確認のみ（適用しない）
nixos-rebuild dry-activate --flake .#mymachine
```
