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
# after creating or changing the generic file run postmap
postmap /etc/postfix/generic

# restart postfix
systemctl restart postfix
```

Dont forget to postmap an restart after changing the files

## Domain rewriting with canonical maps 
In some cases you want to rewrite all email for a specific domain to another domains. For example all incoming email for example.org should be rewritten to example.com. Postfix uses canonical maps to rewrite domains or mail addresses. 
Insert the following line to the /etc/postfix/main.cf:
```bash
# /etc/postfix/main.cf
canonical_maps = hash:/etc/postfix/canonical
```

create a new file /etc/postfix/cononical and define in this file the domain rewrites
```bash
@example.org   @example.com
```

```bash
# after creating or changing the generic file run postmap
postmap /etc/postfix/canonical

# restart postfix
systemctl restart postfix
```

Dont forget to postmap an restart after changing the files



