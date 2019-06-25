Title: Configuring offlineimap + dovecot + thunderbird
Date: 2017-05-18 08:01
Author: Cole Robinson
Tags: fedora
Slug: configuring-offlineimap-dovecot
Status: published

Recently some internal discussions at Red Hat motivated me to look into using [offlineimap](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi9uomL7_fTAhXFqlQKHaGNCn0QFggnMAA&url=http%3A%2F%2Fwww.offlineimap.org%2F&usg=AFQjCNEWRAYFBP6Wj-bMnmtNno_ht0YKBQ&sig2=N58DcSwDbMJOKjNqKK_Ieg). I had thought about doing this for some time as a step towards giving [mutt](http://www.mutt.org/) a try, but for now I decided to keep my original thunderbird setup. This turned out to be a bit more work than I anticipated, so I'm documenting it here.

The primary difficulty is that offlineimap stores mail locally in Maildir format, but thunderbird only reads mbox format. The common solution to this is to serve the offlineimap mail via a local mail server, and have thunderbird connect to that. For the mail server I'm using [dovecot](https://www.dovecot.org/). Getting offlineimap output and dovecot to play nicely together in a format that thunderbird can consume was a bit tricky...

Here's the ~/.offlineimaprc I settled on:


```ini
[general]
accounts = work 

[Account work]
localrepository = local-work
remoterepository = remote-work

# Do a full check every 2 minutes
# autorefresh = 2
# Do 5 quick checks between every full check
# quick = 5


[Repository local-work]
type = Maildir
localfolders = ~/.maildir

# Translate your maildir folder names to the format the remote server expects
# So this reverses the change we make with the remote nametrans setting
nametrans = lambda name: re.sub('^\.', '', name)


[Repository remote-work]
type = IMAP
keepalive = 300
ssl = yes
sslcacertfile = /etc/ssl/certs/ca-bundle.crt
remotehost = $YOUR-WORK-MAIL-SERVER
remoteuser = $YOUR-USERNAME
# You can specify remotepass= , but my work setup implicitly uses kerberos

# Turn this on if you are manually messing with your maildir at all
# I lost some mail in my experiments :(
#readonly = yes

# Need to exclude '' otherwise it complains about infinite naming loop?
folderfilter = lambda foldername: foldername not in ['']
# For Dovecot to see the folders right I want them starting with a dot,
# and dovecot set to look for .INBOX as the toplevel Maildir
nametrans = lambda name: '.' + name
```


A few notes here:

-   autorefresh/quick are commented out because I'm not using them: I'm invoking 'offlineimap -o' with cron ever 2 minutes, with a small wrapper that ensures offlineimap isn't already running (not sure if that will have nasty side effects), and also checks that I'm on my work VPN (checking for a /sys/net/class/ path). I went with this setup because running offlineimap persistently will exit if it can't resolve the remote server after a few attempts, which will trigger if I leave the VPN. Maybe there's a setting to keep it running persistently but I couldn't find it.
-   Enable the 'readonly' option and 'offlineimap --dry-run' when initially configuring things or messing with maildir layout: I lost a few hours of mail somehow during the setup process :/
-   My setup implicitly depends on having authenticated with my companies kerberos. Still haven't figured out a good way of keeping the kerberos ticket fresh on a machine that moves on and off the VPN regularly. I know [SSSD can kinda handle](https://jhrozek.wordpress.com/2015/07/17/get-rid-of-calling-manually-calling-kinit-with-sssds-help/) it but it seems to tie local login to work infrastructure which I'm not sure I want.


For dovecot, I just needed to drop this into /etc/dovecot/local.conf and start/enable the service:


```ini
protocols = imap imaps
listen = 127.0.0.1
mail_location = maildir:~/.maildir:INBOX=~/.maildir/.INBOX
```


Then configure thunderbird to connect to 127.0.0.1. User and password are the same as your local machine user account.

The tricky part seems to be formatting the maildir directory names in a way that dovecot will understand and properly advertise as folders/subfolders. I played with dovecot LAYOUT=fs, various sep/separator values and offlineimap renamings, but the above config is the only thing I found that gave expected results (and I can't take credit for that setup, I eventually found it on an internal wiki page :) )

Here's some (trimmed) directories in my ~/.maildir:


```console
$ ls -1da .maildir/
.Drafts
.INBOX
.INBOX.fedora
.INBOX.libvirt
.INBOX.qemu
.INBOX.virt-tools
.Junk
```


So .Drafts, .INBOX, .Junk are all top level folders, and things like .INBOX.fedora is a 'fedora' subfolder of my inbox. That's the naming scheme the default dovecot config seems to expect.
