Open the Countdash interface by clicking the "Countdash UI" tab above the
terminal. The Countdash interface may appear "Disconnected" on initial load.
Waiting a few seconds or refreshing your browser will update the status to
"Connected".

<div class="alert-info alert">
If the Countdash UI displays "Counting Service is Unreachaable",you should
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

