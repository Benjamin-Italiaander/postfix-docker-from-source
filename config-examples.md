## Loging 
Create a log file con be done two ways.

```bash
#run the command
postconf maillog_file= /var/log/postfix.log
```
or it can be done by adding a line to mail.cf
```bash
echo "postconf maillog_file= /var/log/postfix.log"
```



