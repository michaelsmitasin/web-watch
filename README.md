# web-watch

web-watch is a tool for uploading website screenshots to a Vision Language model for analysis to determine whether they are hijacked or vulnerable to subdomain hijacking.

Setup and Installation:

1) Get a Vision Language Model (VLM) API key. For example, you could purchase credits for the OpenAI API: https://openai.com/api/
2) git clone git@github.com:michaelsmitasin/web-watch.git
3) Ensure you have all the dependencies listed in dependencies_list (the scripts will fail and tell you what you're missing if not).
4) copy settings.conf.example to settings.conf and modify the relevant variables, especially the GOWITNESSCMD, VLMAPIURL, and VLMAPIKEY.
