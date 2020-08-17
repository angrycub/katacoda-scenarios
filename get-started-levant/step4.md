You can provide the values for template variables as flags to the `levant`
command. Update the hello.levant file and change `World` to `[[ .name ]]`.

<pre class="file" data-filename="hello.levant" data-target="replace">
Hello [[.name]]! The current time is [[ timeNow ]].
Looks like your path is set to:
[[ env "PATH" ]]
</pre>

Now, render your template 

```
levant render -var name="awesome learner" hello.levant 2>/dev/null
```{{execute}}

The template will now greet awesome learners instead of just the "world".

## Use a file to provide variable values

Levant can read variables out of a file and 