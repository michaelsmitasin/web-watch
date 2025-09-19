# web-watch

web-watch is a tool for analyzing websites with a Vision Language Model (VLM) to determine whether they are hijacked, vulnerable to subdomain hijacking, or broken in some other way (for example: under construction).

# Setup and Installation
(These assume an Ubuntu 24 OS)

1) Install all the dependencies listed in dependency_list (the scripts will fail and tell you what you're missing if not).
2) Get a Vision Language Model (VLM) API key. For example, you could purchase credits for the OpenAI API: https://openai.com/api/
3) git clone git@github.com:michaelsmitasin/web-watch.git
4) copy settings.conf.example to settings.conf and modify the relevant variables, especially the GOWITNESSCMD, VLMAPIURL, VLMAPIKEY, FROMADDR, RCPTS. And MAILTO if you want to get error emails.
5) Populate your list of websites/URLs that you want to analyze (in the below examples, we save them to the file named `testurls`)
6) Adjust the prompt to suit your needs.

# Example Run

1) This calls fetch-screenshots.sh and analyze-screenshots.sh

```
./web-watch.sh -u testurls -p prompt.conf
```

# Example Test Usage

1) Fetch screenshots from URLs in `testurls` file and store in `~/web-watch/SCREENSHOTS` directory:
```
./fetch-screenshots.sh -u testurls -S ~/web-watch/SCREENSHOTS -v
```
2) Analyze screenshots in ~/web-watch
```
./analyze-screenshot.sh -m gpt-4o -S SCREENSHOTS/https---www.smitasin.com-443.jpeg -P prompt.conf -v
```

This research used the CBorg AI platform and resources provided by the IT Division at the Lawrence Berkeley National Laboratory (Supported by the Director, Office of Science, Office of Basic Energy Sciences, of the U.S. Department of Energy under Contract No. DE-AC02-05CH11231)
