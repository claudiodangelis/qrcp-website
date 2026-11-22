---
title: "Meet qrcp doctor: find out why your phone can't connect"
description: "A new command in v0.12.0 checks your computer's network setup and tells you how to fix what's wrong."
date: 2026-11-22 10:00:00 +0100
---

The most common qrcp problem is easy to describe: the QR code scans, the browser opens, and then the page never loads. The cause is almost always on the computer: qrcp picked a Docker bridge instead of the Wi-Fi, a firewall blocks the port, a VPN is in the way. Until now, finding which one meant guessing.

[qrcp v0.12.0]({% post_url 2026-11-21-v0.12.0 %}) adds a command that does the guessing for you:

```sh
qrcp doctor
```

<!--more-->

## What it does

`doctor` looks at this computer's network setup the same way `send` and `receive` would, and reports every problem it finds with a suggested fix. It checks:

- **The network interfaces**: it lists them all and marks the one that looks connected to the local network.
- **The interface qrcp will use**: whether a phone can reach it, or whether it's a loopback, Docker/VM, VPN, mobile broadband or IPv6-only interface.
- **The URL and the port**: what the phone will be asked to open, and whether the port is free.
- **The firewall, VPNs and WSL 2 networking.**
- **The TLS certificate and key**, when you use `--secure`.
- **The configuration file**: whether it can be read at all.

Each check is reported as **ok**, **info** (couldn't be fully checked), **warn** (likely to cause problems) or **fail** (transfers won't work until it's fixed).

Here's a typical case, on a machine where qrcp was configured to use the Docker interface by mistake:

```text
$ qrcp doctor -i docker0
Network interfaces:
   docker0          172.17.0.1               virtual
   lo               127.0.0.1                loopback
 * wlan0            192.168.1.81             wifi
   (* looks connected to the local network)

[warn] interface using docker0 (172.17.0.1, virtual): it looks like a virtual interface (Docker, VM, bridge), which a phone usually can't reach
                 -> use --interface wlan0, or set it with `qrcp config`
[  ok] port      a random port is used for each transfer
                 -> if a firewall blocks incoming connections, set a fixed port with --port or `qrcp config`, and allow it once
```

The problem and the fix, in one line each.

## What you can use it for

**"The phone can't open the link."** This is the main use: run `qrcp doctor` before anything else, and follow the hints. It takes a second and doesn't touch anything.

**Checking a setup before you need it.** `doctor` takes the same flags as `send` and `receive`, so you can test an exact setup in advance: before a demo, on a new laptop, or on the hotel or conference network.

```sh
qrcp doctor -i wlan0 -p 8080 --secure --tls-cert cert.pem --tls-key key.pem
```

**Machines with many interfaces.** Docker, virtual machines and VPN clients add interfaces that a phone can't reach. `doctor` tells you which one is the real local network, so you can save it once with `qrcp config`.

**Firewalls.** By default qrcp uses a random port, which most firewalls block. `doctor` points this out and suggests a fixed port to allow once.

**WSL 2.** With the default NAT networking, qrcp inside WSL can't be reached from other devices. `doctor` detects WSL and explains how to switch to mirrored networking.

**HTTPS setups.** With `--secure`, it checks that the certificate and the key exist and can be loaded, before the phone sees an error page.

**Better bug reports.** If you still can't connect, paste the output of `qrcp doctor` in a [new issue](https://github.com/claudiodangelis/qrcp/issues). It answers most of the questions we would ask you anyway.

**Scripts and AI agents.** `qrcp doctor --json` prints the same report as JSON, and the command exits with code `1` when a check fails. A script can stop before starting a transfer that can't work, and an AI agent can read the report and fix the configuration for you:

```sh
qrcp doctor --json | jq -r '.checks[] | select(.status == "fail" or .status == "warn") | .hint'
```

## What it can't do

`doctor` only checks this computer. It can't test the phone, and it can't see whether the Wi-Fi network blocks devices from talking to each other, which many guest networks and public hotspots do. A clean report doesn't guarantee the phone can connect, but it rules out the most common causes. If the phone still can't connect, try another network or the phone's hotspot.

It also never prompts and never changes your configuration: it only reports.

## Try it

`qrcp doctor` is available from v0.12.0. Update with your [package manager]({{ '/packages/' | relative_url }}), then read the [troubleshooting guide]({{ '/docs/' | relative_url }}#troubleshooting) for the full list of options and common causes.
