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

## Rewrite or forward emails
re-write can be handled via a /etc/postfix/generic file.

In the postfix/main.cf add the following
```bash
#/etc/postfix/main.cf
smtp_generic_maps = hash:/etc/postfix/generic
```

Then create a /etc/postfix/generic file as below and add additional users if needed.
```bash
root@localdomain myaccount@myoffice356domain.com
@localdomain myaccount@myoffice356domain.com
root@myserver  myaccount@myoffice356domain.com
userA@myserver myaccount@myoffice356domain.com
```
After creating this file you need to update thew postfix lookup table management by using the postmap command

```bash
# arter creating or changing the generic file run postmap
postmap /etc/postfix/generic

# restart postfix
systemctl restart postfix
```

Dont forget to postmap an restart after changing the files
