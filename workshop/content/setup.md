---
Sort: 2
Title: Lab Setup
PrevPage: index
NextPage: exercises/lab1.md
ExitSign: Start Workshop
---

To verify you can run the commands as a user, copy and paste the text below in the terminal window or click on the <span class="glyphicon glyphicon-play-circle"></span> icon shown to the right of the command.

```execute
oc auth can-i create pods
```

If the output from the `oc auth can-i` command is `yes`, you can click on the "Start Workshop" button below.

If you see:

```
no - no RBAC policy matched
```

or any other errors, please contact the workshop facilitator as you do not have the required permissions to run this lab.  
