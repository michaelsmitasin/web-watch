# web-watch

web-watch is a tool for uploading website screenshots to a Vision Language model for analysis to determine whether they are hijacked or vulnerable to subdomain hijacking.

Setup and Installation:
(These assume an Ubuntu 24 OS)

1) Install go: https://go.dev/doc/install
2) Install google-chrome
3) Install gowitness: https://github.com/sensepost/gowitness
4) Get a Vision Language Model (VLM) API key. For example, you could purchase credits for the OpenAI API: https://openai.com/api/
5) git clone git@github.com:michaelsmitasin/web-watch.git
6) Ensure you have all the dependencies listed in dependencies_list (the scripts will fail and tell you what you're missing if not).
7) copy settings.conf.example to settings.conf and modify the relevant variables, especially the GOWITNESSCMD, VLMAPIURL, and VLMAPIKEY.

# Example Test Usage

1) Fetch screenshots from URLs in `testurls` file and store in `~/web-watch/SCREENSHOTS` directory:
```
./fetch-screenshots.sh -u testurls -S ~/web-watch/SCREENSHOTS -v
```
2) Analyze screenshots in ~/web-watch
```
./api-single-test-query.sh -m gpt-4o -S https---www.smitasin.com-443.jpeg -P prompt.conf -v
```
