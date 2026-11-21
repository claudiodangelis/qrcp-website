---
layout: default
title: Documentation
permalink: /docs/
---

# Documentation

qrcp starts a small web server on your computer and prints a QR code with its address. Scan the code with your phone and the transfer happens in the phone's browser: no app, no cloud, no account. When the transfer is done, qrcp exits.

Install qrcp from the [packages page]({{ '/packages/' | relative_url }}), then read on.

**Contents:**
[Quick start](#quick-start) ·
[Send files](#send-files-to-your-phone) ·
[Receive files](#receive-files-from-your-phone) ·
[Network](#choose-the-network) ·
[HTTPS](#secure-transfers-with-https) ·
[Troubleshooting](#troubleshooting) ·
[Configuration](#configuration) ·
[Command reference](#command-reference) ·
[Shell completion](#shell-completion)

---

## Quick start

```sh
qrcp MyDocument.pdf   # send a file to your phone
qrcp receive          # receive files from your phone
```

1. Run one of the commands above. qrcp prints a URL and a QR code.
2. Scan the QR code with your phone's camera (or any QR reader) and open the link.
3. The file downloads on the phone, or an upload page opens. When the transfer is complete, qrcp exits.

The phone and the computer must be on the **same network**. The first time, qrcp may ask which network interface to use: pick the one connected to your Wi-Fi (see [Choose the network](#choose-the-network)).

Press **`q`** or **`Ctrl+C`** at any time to stop qrcp.

---

## Send files to your phone

Sending is the default action, so these are equivalent:

```sh
qrcp MyDocument.pdf
qrcp send MyDocument.pdf
qrcp s MyDocument.pdf
```

### What gets sent

| You pass                     | Example                           | The phone receives                        |
|------------------------------|-----------------------------------|-------------------------------------------|
| One file                     | `qrcp MyDocument.pdf`             | The file itself                           |
| Several files                | `qrcp MyDocument.pdf IMG0001.jpg` | A `.zip` archive with all of them         |
| A folder                     | `qrcp Documents/`                 | A `.zip` archive of the folder            |
| One file, zipped             | `qrcp --zip LongVideo.avi`        | A `.zip` archive with the file            |

The archive is created in a temporary directory and deleted after the transfer.

### When does qrcp exit?

By default qrcp stops as soon as the first browser has finished downloading, so the link works only once. To send the same file to several devices, or to download it more than once, keep the server running:

```sh
qrcp --keep-alive MyDocument.pdf    # or -k; stop it with q or Ctrl+C
```

### Show the QR code differently

| Situation                                                        | Command                          |
|------------------------------------------------------------------|----------------------------------|
| The QR code doesn't scan well in your terminal's colors          | `qrcp --reversed MyDocument.pdf` |
| You'd rather scan it from a browser window (bigger, sharper)     | `qrcp --browser MyDocument.pdf`  |
| Hide the messages (the QR code is still printed)                 | `qrcp --quiet MyDocument.pdf`    |

`--reversed` (`-r`) prints black on white, `--browser` (`-b`) opens the QR code as an image in your default browser, `--quiet` (`-q`) hides the messages, including the URL, and prints only errors and the QR code.

---

## Receive files from your phone

```sh
qrcp receive                          # save to the current directory
qrcp receive --output ~/Downloads     # or -o: save to a specific directory
qrcp r -o ~/Downloads                 # same, with the short alias
```

Scanning the QR code opens an upload page on the phone, where you can:

- **Pick one or more files** (photos, videos, documents…) and tap *Transfer*.
- **Send text:** tick *Show text and paste options*, write or paste the text, and optionally give it a title. It's saved as `<title>.txt`, or `qrcp-text-file-<date>.txt` without a title. Handy for links, notes and passwords.
- **Paste files** from the phone's clipboard into the same text box.

Good to know:

- The destination must be an existing directory you can read and write. Without `--output`, qrcp uses the `output` directory from the [configuration](#configuration), or else the current directory.
- Existing files are never overwritten: if `photo.jpg` already exists, the new one is saved as `photo(1).jpg`, then `photo(2).jpg`, and so on.
- The computer shows a progress bar while each file arrives.
- qrcp exits after the first upload. With `--keep-alive` (`-k`) the upload page stays available, so you can send several batches.

---

## Choose the network

The phone must reach the computer, so qrcp has to listen on the right **network interface**: usually your Wi-Fi or Ethernet one.

- If only one interface is available, qrcp uses it.
- Otherwise it asks you to choose, and **saves your choice** in the configuration file, so it asks only once. Run `qrcp config` to choose again.
- Interfaces that a phone usually can't reach (loopback, Docker, bridges, VPN tunnels…) are hidden from the list. Show them all with `--list-all-interfaces` (`-l`).

### Network options

| Goal                                                       | Option                          | Example                                  |
|------------------------------------------------------------|---------------------------------|------------------------------------------|
| Use a specific interface                                   | `--interface`, `-i`             | `qrcp -i wlan0 MyDocument.pdf`           |
| Listen on all interfaces (`0.0.0.0`)                       | `--interface any`               | `qrcp -i any MyDocument.pdf`             |
| Listen on a specific address (overrides the interface)     | `--bind`                        | `qrcp --bind 192.168.1.10 MyDocument.pdf`|
| Use a fixed port, e.g. to open it in the firewall          | `--port`, `-p`                  | `qrcp -p 8080 MyDocument.pdf`            |
| Use a fixed URL path instead of a random one               | `--path`                        | `qrcp --path photos MyDocument.pdf`      |
| Put a host name in the URL instead of the IP address       | `--fqdn`, `-d`                  | `qrcp -d mypc.local MyDocument.pdf`      |

Notes:

- The **port** is random by default; a fixed port makes firewall rules possible.
- The **path** is random by default, which makes the URL hard to guess. The URL looks like `http://<address>:<port>/send/<path>` (or `/receive/<path>`).
- With `--interface any`, qrcp puts your **public IP address** in the URL (it looks it up online), which is useful when the phone connects from outside your network, e.g. through port forwarding. Combine it with `--fqdn` to use a host name instead.
- `--fqdn` is also how you use qrcp behind a reverse proxy or with a local DNS name (`mypc.local`).

---

## Secure transfers with HTTPS

By default the transfer uses plain HTTP inside your local network. To encrypt it, give qrcp a TLS certificate and key:

```sh
qrcp --secure --tls-cert ~/certs/cert.pem --tls-key ~/certs/key.pem MyDocument.pdf
```

`--secure` (`-s`) switches the URL to `https://`. The phone must trust the certificate, otherwise it shows a warning. The [mkcert tutorial]({{ '/tutorials/secure-transfers-with-mkcert/' | relative_url }}) shows how to create a local certificate authority and a trusted certificate in a few minutes. Save the three settings with `qrcp config` to use HTTPS every time.

---

## Troubleshooting

If the phone can't open the URL, run:

```sh
qrcp doctor
```

> **Coming in the next release.** `qrcp doctor` is not in v0.11.7 or earlier. To try it now, install the development version with `go install github.com/claudiodangelis/qrcp@main`. With a released version, go straight to the [common causes](#common-causes) below.

It lists the network interfaces, marks the one that looks connected to the local network, and checks the port, the firewall, VPNs, WSL networking and, with `--secure`, the TLS certificate and key. Every problem comes with a suggested fix. Each check is reported as **ok**, **info** (couldn't be fully checked), **warn** (likely to cause problems) or **fail** (transfers won't work until it's fixed).

```sh
qrcp doctor -i wlan0 -p 8080    # check a specific setup: it takes the same flags as send/receive
qrcp doctor --json              # machine-readable report, for scripts and AI agents
```

`doctor` only checks this computer: it can't test the phone or the Wi-Fi network, so a clean report doesn't guarantee the phone can connect. It never prompts and never changes the configuration. It exits with code `1` if a check fails. On Windows and macOS it only tries the port on `127.0.0.1`, so the firewall doesn't ask whether to allow qrcp.

The `--json` report has this shape:

```json
{
  "failed": false,
  "checks": [{ "name": "…", "status": "ok|info|warn|fail", "message": "…", "hint": "…" }],
  "interfaces": [{ "name": "…", "ip": "…", "kind": "…" }],
  "suggested_interface": "…",
  "help_url": "…"
}
```

### Common causes

- **Wrong interface.** The phone and the computer must be on the same network, and qrcp must use the interface connected to it. Docker, virtual machine and VPN interfaces usually can't be reached from the phone. Choose one with `-i`, or save it with `qrcp config`.
- **Firewall.** qrcp uses a random port by default. Set a fixed one with `--port` (or `port` in the configuration), and allow incoming TCP connections on it.
- **Guest or public Wi-Fi.** Many of these networks block devices from reaching each other. Use another network, or connect the computer to the phone's hotspot.
- **WSL 2.** With the default NAT networking, WSL can't be reached from other devices. On Windows 11 22H2 or later, add `networkingMode=mirrored` under `[wsl2]` in `%UserProfile%\.wslconfig`, run `wsl --shutdown`, and allow inbound connections in the Hyper-V firewall, as described in [Microsoft's WSL networking guide](https://learn.microsoft.com/windows/wsl/networking). Or use the Windows build of qrcp.
- **The QR code doesn't scan.** Try `--reversed`, make the terminal font smaller or the window bigger, or use `--browser` to show it as an image.

---

## Configuration

qrcp works without any configuration. Settings come from three places; the first one that sets a value wins:

1. **Command-line flags**, e.g. `--port 8080`
2. **Environment variables**, e.g. `QRCP_PORT=8080`
3. **The configuration file**

### Configuration file

The file is created automatically on the first run, in the qrcp folder of your user configuration directory:

| System  | Default location                                     |
|---------|------------------------------------------------------|
| Linux   | `$XDG_CONFIG_HOME/qrcp/config.yml` (usually `~/.config/qrcp/config.yml`) |
| macOS   | `~/Library/Application Support/qrcp/config.yml`      |
| Windows | `%LOCALAPPDATA%\qrcp\config.yml`                     |

Use another file with `--config` (`-c`). Its extension (`.yml`, `.json`…) tells qrcp the format:

```sh
qrcp --config ~/qrcp-work.yml MyDocument.pdf
```

### Configuration wizard

```sh
qrcp config      # aliases: qrcp c, qrcp cfg
```

An interactive wizard that asks, in order, for: the network interface, the bind address, the port, the domain name, the URL path, keep-alive, HTTPS (and then the certificate and key), the default output directory for received files, and whether to reverse the QR code. It saves the answers in the configuration file.

### Migrating from the old JSON format

Versions before 0.10 stored the configuration in `config.json`. qrcp still reads it, but you can convert it to YAML (and delete the old file) with:

```sh
qrcp config migrate
```

### Options

Every option can be set in the file, as an environment variable, or as a flag:

| Key in `config.yml` | Environment variable | Flag                | Type    | Description                                                                 |
|---------------------|----------------------|---------------------|---------|-----------------------------------------------------------------------------|
| `interface`         | `QRCP_INTERFACE`     | `-i`, `--interface` | string  | Network interface to use. `any` listens on all interfaces (`0.0.0.0`).      |
| `bind`              | `QRCP_BIND`          | `--bind`            | string  | Address to listen on. Overrides `interface`.                                |
| `port`              | `QRCP_PORT`          | `-p`, `--port`      | integer | Port to use. `0` or unset means random.                                     |
| `path`              | `QRCP_PATH`          | `--path`            | string  | URL path. Random by default.                                                |
| `fqdn`              | `QRCP_FQDN`          | `-d`, `--fqdn`      | string  | Host name to put in the URL instead of the IP address.                      |
| `keepAlive`         | `QRCP_KEEPALIVE`     | `-k`, `--keep-alive`| boolean | Keep the server running after a transfer. Default `false`.                  |
| `secure`            | `QRCP_SECURE`        | `-s`, `--secure`    | boolean | Use HTTPS. Requires `tls-cert` and `tls-key`.                               |
| `tls-cert`          | `QRCP_TLS_CERT`      | `--tls-cert`        | string  | Path to the TLS certificate.                                                |
| `tls-key`           | `QRCP_TLS_KEY`       | `--tls-key`         | string  | Path to the TLS private key.                                                |
| `output`            | `QRCP_OUTPUT`        | `-o`, `--output`    | string  | Default directory for received files.                                       |
| `reversed`          | `QRCP_REVERSED`      | `-r`, `--reversed`  | boolean | Print the QR code black on white.                                           |

Example `config.yml`:

```yaml
interface: wlan0
port: 8080
keepAlive: false
output: /home/me/Downloads
secure: true
tls-cert: /home/me/certs/cert.pem
tls-key: /home/me/certs/key.pem
```

---

## Command reference

| Command                          | Aliases       | Description                                                       |
|----------------------------------|---------------|-------------------------------------------------------------------|
| `qrcp <file>...`                 |               | Send files or folders (same as `qrcp send`).                      |
| `qrcp send <file>...`            | `s`           | Send files or folders.                                            |
| `qrcp receive`                   | `r`           | Receive files (and text) from the phone.                          |
| `qrcp config`                    | `c`, `cfg`    | Run the configuration wizard.                                     |
| `qrcp config migrate`            |               | Convert the legacy `config.json` to `config.yml`.                 |
| `qrcp doctor`                    |               | Check why the phone can't connect (next release).                 |
| `qrcp completion <shell>`        |               | Print a completion script for `bash`, `zsh`, `fish` or `powershell`. |
| `qrcp version`                   |               | Print the version and build information.                          |
| `qrcp help [command]`            |               | Show help for any command. `-h`/`--help` works too.               |

### Flags

These flags work with `send`, `receive` and `doctor` (and with every other command):

| Flag                          | Description                                                        |
|-------------------------------|--------------------------------------------------------------------|
| `-i`, `--interface <name>`    | Network interface to use (`any` for all interfaces).               |
| `-l`, `--list-all-interfaces` | Show all interfaces when choosing one, including virtual ones.     |
| `--bind <address>`            | Address to listen on. Overrides `--interface`.                     |
| `-p`, `--port <number>`       | Port to use. Random by default.                                    |
| `--path <path>`               | URL path. Random by default.                                       |
| `-d`, `--fqdn <name>`         | Host name to use in the URL instead of the IP address.             |
| `-k`, `--keep-alive`          | Keep the server running after a transfer.                          |
| `-z`, `--zip`                 | Zip the content before sending, even a single file.                |
| `-s`, `--secure`              | Use HTTPS.                                                         |
| `--tls-cert <file>`           | TLS certificate for HTTPS.                                         |
| `--tls-key <file>`            | TLS private key for HTTPS.                                         |
| `-b`, `--browser`             | Also show the QR code in a browser window.                         |
| `-r`, `--reversed`            | Print the QR code black on white.                                  |
| `-q`, `--quiet`               | Hide messages; print only errors (and the QR code).                |
| `-c`, `--config <file>`       | Use this configuration file.                                       |
| `-h`, `--help`                | Show help.                                                         |

Command-specific flags:

| Command   | Flag                       | Description                                  |
|-----------|----------------------------|----------------------------------------------|
| `receive` | `-o`, `--output <dir>`     | Directory where received files are saved.    |
| `doctor`  | `--json`                   | Print the report as JSON (next release).     |

---

## Shell completion

qrcp can generate completion scripts for Bash, Zsh, Fish and PowerShell.

| Shell          | Current session                          | Every session (run once)                                                     |
|----------------|------------------------------------------|------------------------------------------------------------------------------|
| **Bash**       | `source <(qrcp completion bash)`         | Linux: `qrcp completion bash > /etc/bash_completion.d/qrcp`<br>macOS: `qrcp completion bash > /usr/local/etc/bash_completion.d/qrcp` |
| **Zsh**        | n/a                                      | `qrcp completion zsh > "${fpath[1]}/_qrcp"`, then start a new shell          |
| **Fish**       | `qrcp completion fish | source`          | `qrcp completion fish > ~/.config/fish/completions/qrcp.fish`                |
| **PowerShell** | `qrcp completion powershell | Out-String | Invoke-Expression` | Add the same line to your PowerShell profile (`$PROFILE`)                    |

For Zsh, completion must be enabled; if it isn't, run `echo "autoload -U compinit; compinit" >> ~/.zshrc` once.

---

## Credits

- **Author**: [Claudio d'Angelis](https://t.me/claudiodangelis), with [many contributors](https://github.com/claudiodangelis/qrcp/graphs/contributors).
- **Logo**: provided by [@arasatasaygin](https://github.com/arasatasaygin) as part of the [openlogos](https://github.com/arasatasaygin/openlogos) initiative.
- **Releases**: managed with [goreleaser](https://goreleaser.com).

## Similar projects

| Project                                                                                      | Description                                                                        |
|----------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| [qr-fileshare](https://github.com/shivensinha4/qr-fileshare)                                 | A similar idea executed in NodeJS with a React interface.                          |
| [instant-file-transfer](https://github.com/maximumdata/instant-file-transfer) _(Uncredited)_ | Node.js project similar to this.                                                   |
| [qr-filetransfer](https://github.com/sdushantha/qr-filetransfer)                             | Python clone of this project.                                                      |
| [qr-filetransfer](https://github.com/svenkatreddy/qr-filetransfer)                           | Another Node.js clone of this project.                                             |
| [qr-transfer-node](https://github.com/codezoned/qr-transfer-node)                            | Another Node.js clone of this project.                                             |
| [QRDELIVER](https://github.com/realdennis/qrdeliver)                                         | Node.js project similar to this.                                                   |
| [qrfile](https://github.com/sgbj/qrfile)                                                     | Transfer files by scanning a QR code.                                              |
| [quick-transfer](https://github.com/CodeMan99/quick-transfer)                                | Node.js clone of this project.                                                     |
| [share-file-qr](https://github.com/pwalch/share-file-qr)                                     | Python re-implementation of this project.                                          |
| [share-files](https://github.com/antoaravinth/share-files) _(Uncredited)_                    | Yet another Node.js clone of this project.                                         |
| [ezshare](https://github.com/mifi/ezshare)                                                   | Another Node.js two-way file sharing tool supporting folders and multiple files.   |
| [local_file_share](https://github.com/woshimanong1990/local_file_share)                      | _"Share local file to other people, OR smartphone download files which is in PC."_ |
| [qrcp](https://github.com/pearl2201/qrcp)                                                    | A desktop app clone of `qrcp`, written with C# and .NET Core, works for Windows.   |
| [swift_file](https://github.com/mateoradman/swift_file)                                      | Rust project inspired by `qrcp`.                                                   |
| [qrcp-android](https://github.com/ianfixes/qrcp-android)                                     | Android app inspired by `qrcp`.                                                    |

## License

qrcp is free and open-source software, released under the [MIT license](https://github.com/claudiodangelis/qrcp/blob/main/LICENSE).
