Variables enable the templates to be dynamic and to create interesting
content. Levant uses double square brackets to delimit dynamic content
from static content.

You can use the `timeNow` template function to emit the current time.

Update the hello.levant template to emit the time as part of the
"Hello World!" line.

<pre class="file" data-filename="hello.levant" data-target="replace">
Hello World!
The current time is "[[ timeNow ]]".
</pre>

Render it with `levant render hello.levant 2>/dev/null`{{execute}}. Your
message will now have the current date in it.

```
Hello World!
The current time is "2020-08-17T18:49:59Z".
```

You can also include environment variables using the `env` function.

Update your template to contain the following text.

<pre class="file" data-filename="hello.levant" data-target="replace">
Hello World!
The current time is "[[ timeNow ]]".
Looks like your path is set to:
[[ env "PATH" ]]
</pre>

Render it with `levant render hello.levant 2>/dev/null`{{execute}}. The template
output will print out the welcome and the value of the PATH environment 
variable.

```plaintext
Hello World!
The current time is "2020-08-17T21:35:13Z".
Looks like your path is set to:
/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```
