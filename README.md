# web-watch

web-watch is a tool for analyzing websites with a Vision Language Model (VLM) to determine whether they are hijacked, vulnerable to subdomain hijacking, or broken in some other way (for example: under construction).

# Setup and Installation
(These assume an Ubuntu 24 OS)

Watch an install demo: https://www.youtube.com/watch?v=FCEJn_16D20

1) Install all the dependencies listed in dependency_list (the scripts will fail and tell you what you're missing). For example, I used a vanilla Ubuntu 24 AMI on AWS, and had to do the following (there are almost certainly better ways of doing this):
```
sudo bash

add-apt-repository ppa:longsleep/golang-backports
apt-get update
apt-get upgrade
apt-get install golang-go
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt --fix-broken install
apt-get install sendmail

exit

cd ~

go install github.com/sensepost/gowitness@latest
sudo ln -s ~/go/bin/gowitness /usr/bin/gowitness
```
2) Get a Vision Language Model (VLM) API key. For example, you could purchase credits for the OpenAI API: https://platform.openai.com/settings/organization/billing/overview
3) `git clone https://www.github.com/michaelsmitasin/web-watch.git`
4) copy `settings.conf.example` to `settings.conf` and modify the relevant variables, especially the GOWITNESSCMD, VLMAPIURL, VLMAPIKEY, FROMADDR, RCPTS. And MAILTO if you want to get error emails.
5) Populate your list of websites/URLs that you want to analyze (in the below examples, we save them to the file named `testurls`)
6) Adjust `prompt.conf` to suit your needs.

# Example Run

1) This calls fetch-screenshots.sh and analyze-screenshots.sh

```
./web-watch.sh -u testurls -p prompt.conf
```

# Example Test Usage
If you're encountering issues with `web-watch.sh`, you can try running the individual scripts it calls separately:

1) Fetch screenshots from URLs in `testurls` file and store in `web-watch/SCREENSHOTS` directory:
```
./fetch-screenshots.sh -u testurls -S web-watch/SCREENSHOTS -v
```
2) Analyze one screenshot in web-watch/SCREENSHOTS
```
./analyze-screenshot.sh -m gpt-4o -S SCREENSHOTS/2025-09-19T21:30_ikFd4TZB/https---www.smitasin.com-443.jpeg -P prompt.conf -v
```
3) Generate email reports
```
./gen-report.sh -s "HIJACKED|VULNERABLE" -r "SCREENSHOTS/2025-09-19T21:30_ikFd4TZB" -R RESULTS/2025-09-19T21\:30_ikFd4TZB.csv -t security@example.com
```

---

This research used the CBorg AI platform and resources provided by the IT Division at the Lawrence Berkeley National Laboratory (Supported by the Director, Office of Science, Office of Basic Energy Sciences, of the U.S. Department of Energy under Contract No. DE-AC02-05CH11231)
