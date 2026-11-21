---
layout: default
title: Documentation
permalink: /docs/
---

# Documentation

Install qrcp from the [packages page]({{ '/packages/' | relative_url }}), then:

## Usage

### Send files

| Action                      | Command example                   |
|-----------------------------|-----------------------------------|
| **Send a file**             | `qrcp MyDocument.pdf`             |
| **Send multiple files**     | `qrcp MyDocument.pdf IMG0001.jpg` |
| **Send a folder**           | `qrcp Documents/`                 |
| **Zip before transferring** | `qrcp --zip LongVideo.avi`        |

### Receive files

| Action                              | Command example                  |
|-------------------------------------|----------------------------------|
| **Receive to current directory**    | `qrcp receive`                   |
| **Receive to a specific directory** | `qrcp receive --output=/tmp/dir` |

---

## Configuration

`qrcp` works without prior configuration, but you can customize it using a configuration file or environment variables.

### Configuration file

The default configuration file is stored in `$XDG_CONFIG_HOME/qrcp/config.yml`. You can specify a custom location using the `--config` flag:

```sh
qrcp --config /tmp/qrcp.yml MyDocument.pdf
```

### Configuration options

| Key          | Type    | Description                                                                    |
|--------------|---------|--------------------------------------------------------------------------------|
| `interface`  | String  | Network interface to bind the web server to. Use `any` to bind to `0.0.0.0`.   |
| `bind`       | String  | Address to bind the web server to. Overrides `interface`.                      |
| `port`       | Integer | Port to use. Defaults to a random port.                                        |
| `path`       | String  | Path to use in the URL. Defaults to a random string.                           |
| `output`     | String  | Default directory to receive files. Defaults to the current working directory. |
| `fqdn`       | String  | Fully qualified domain name to use in the URL instead of the IP address.       |
| `keep-alive` | Bool    | Keep the server alive after transferring files. Defaults to `false`.           |
| `secure`     | Bool    | Use HTTPS instead of HTTP. Defaults to `false`.                                |
| `tls-cert`   | String  | Path to the TLS certificate. Used only when `secure: true`.                    |
| `tls-key`    | String  | Path to the TLS key. Used only when `secure: true`.                            |

### Environment variables

All configuration parameters can also be set via environment variables prefixed with `QRCP_`:

- `$QRCP_INTERFACE`
- `$QRCP_PORT`
- `$QRCP_KEEPALIVE`

---

## Advanced usage

### Network interface

To use a specific network interface:

```sh
qrcp -i tun0 MyDocument.pdf
```

To bind the web server to all interfaces:

```sh
qrcp -i any MyDocument.pdf
```

### HTTPS

Enable secure transfers with HTTPS by providing a TLS certificate and key:

```sh
qrcp --tls-cert /path/to/cert.pem --tls-key /path/to/cert.key MyDocument.pdf
```

See the [mkcert tutorial]({{ '/tutorials/secure-transfers-with-mkcert/' | relative_url }}) for a step-by-step guide.

### Shell completion

| Shell    | Command example                             |
|----------|---------------------------------------------|
| **Bash** | `source <(qrcp completion bash)`            |
| **Zsh**  | `qrcp completion zsh > "${fpath[1]}/_qrcp"` |
| **Fish** | `qrcp completion fish | source`             |

---

## Authors and credits

- **Author**: [Claudio d'Angelis](https://t.me/claudiodangelis)
- **Logo**: provided by [@arasatasaygin](https://github.com/arasatasaygin) as part of the [openlogos](https://github.com/arasatasaygin/openlogos) initiative.
- **Releases**: managed with [goreleaser](https://goreleaser.com).

---

## Clones and similar projects

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

---

## License

MIT. See [LICENSE]({{ '/LICENSE' | relative_url }}).
