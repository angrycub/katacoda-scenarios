<style type="text/css">
  .lang-screenshot { -webkit-touch-callout: none; -webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; }
  .alert { position: relative; padding: .75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: .25rem; }
  .alert-info    { color: #0c5460; background-color: #d1ecf1; border-color: #bee5eb; }
</style>
Open the Countdash interface by clicking the "Countdash UI" tab above the
terminal. The Countdash interface may appear "Disconnected" on initial load.
Waiting a few seconds or refreshing your browser will update the status to
"Connected".

You can also use this link to open the UI.

https://[[HOST_SUBDOMAIN]]-9002-[[KATACODA_HOST]].environments.katacoda.com

<div class="alert-info alert">
If the Countdash UI displays "Counting Service is Unreachable",you should
go back and verify your configuration, and ensure that you have executed all
the guide commands—specifically the **consul intention create...** command.
</div>

Once you are done, run `nomad stop countdash`{{execute}} to prepare for the next
step.

**Example Output**

```screenshot
$ nomad stop countdash
==> Monitoring evaluation "d4796df1"
    Evaluation triggered by job "countdash"
    Evaluation within deployment: "18b25bb6"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "d4796df1" finished with status "complete"
```

