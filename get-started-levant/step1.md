There are a few ways to install Levant to your machine:

- Download a release.
- Use `go install`.
- Build from source.

For this tutorial, download the Levant as a release and install
it into the path using the following commands.

```bash
wget https://github.com/hashicorp/levant/releases/download/0.2.9/linux-amd64-levant
chmod +x linux-amd64-levant
mv linux-amd64-levant /usr/local/bin/levant
```{{execute}}


Verify that you have the `levant` executable in your path
by running 

```bash
levant version
```{{execute}}

You should receive information about your current version
of Levant.

```plaintext
Levant v0.2.9
Date: 2019-12-27T09:43:30Z
Commit: 0f1913ea3d77584ddd0696da429dcf05572a73a0
Branch: 0.2.9
State: 0.2.9
Summary: 0f1913ea3d77584ddd0696da429dcf05572a73a0
```
