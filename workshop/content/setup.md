---
Sort: 2
Title: Lab Setup
PrevPage: index
NextPage: exercises/lab1.md
ExitSign: Start Workshop
---

To verify you can run the commands as a user copy and paste the text below in the terminal window or click on the <span class="glyphicon glyphicon-play-circle"></span> icon shown to the right of it, and it will be copied to the interactive terminal and it will be run.

```execute
oc auth can-i create pods
```

If the output from the `oc auth can-i` command is `yes`, you are all good to go, and you can scroll to the bottom of the page and click on "Start Workshop".

If instead of the output `yes`, you see:

```
no - no RBAC policy matched
```

or any other errors, please contact the workshop facilitator.  
