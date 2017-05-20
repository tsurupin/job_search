[![Deps Status](https://beta.hexfaktor.org/badge/all/github/tsurupin/job_search.svg)](https://beta.hexfaktor.org/github/tsurupin/job_search)

# [Startup Job](http://demo.job-search.tsurupin.com/)


**Startup Job** is a sample project about job search written in [Elixir](http://elixir-lang.org/) / [Phoenix](http://www.phoenixframework.org/)(Backend) and [React](https://facebook.github.io/react/)/[Redux](http://redux.js.org/)(Frontend).
 
This project is an umbrella project.
 - Customer app is for processing data and rendering contents. 
 - Scraper app is for scraping data from websites.
 

Demo
-------
[http://demo.job-search.tsurupin.com/](ttp://demo.job-search.tsurupin.com/)



Motivation
-------
I created this app to understand Elixir / OTP and get more familliar with React.

Main Technology Stack
-------
* React
* Redux
* Elixir
* Phoenix
* Elasticsearch
* [styled-components](https://styled-components.com/)

Development
--------

### Setup
1. Get the code.

        % git clone git@github.com:tsurupin/job_search.git

2. Install Elasticsearch in local environment.

   [Mac OS](https://chartio.com/resources/tutorials/how-to-install-elasticsearch-on-mac-os-x/)

3. Setup your environment.

        % bin/setup

4. Start Foreman.

        % mix phx.server

5. Verify that the app is up and running.

        % open http://localhost:8080

Todo
-------
 1. Make Selenium work in background in server.
 2. Enable users to download their favorite jobs in csv.
 3. Synchronize favorite jobs with Google Sheets.


License
-------
 The project is available as open source under the terms of the MIT License.


Troubleshooting
-------
 Please create an [issue](https://github.com/tsurupin/job_search/issues).