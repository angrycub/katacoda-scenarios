Create a file named `hello.levant`{{open}} in your text editor with
the following content.

<pre class="file" data-filename="hello.levant" data-target="replace">
Hello World!
</pre>

## Render the template

Now that your template is created, you can render it using the
`levant render` command. To render your hello.levant template
run this command.

```bash
levant render hello.levant
```{{execute}}

Levant will emit some log lines to stderr and output the rendered
template to stdout.  You should receive output similar to the following:

```plaintext
{"level":"debug","time":"2020-08-17T18:06:59Z","message":"template/render: no variable file passed, trying defaults"}
{"level":"debug","time":"2020-08-17T18:06:59Z","message":"helper/files: no default var-file found"}
{"level":"debug","time":"2020-08-17T18:06:59Z","message":"template/render: no commandline variables passed"}
Hello World!
```

To see the template content without the logging, you can run the
`levant render` command again and redirect stderr to /dev/null.

```bash
levant render hello.levant 2>/dev/null
```{{execute}}

Now you will only see the template content.

```plaintext
Hello World!
```
