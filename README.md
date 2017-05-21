[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/tsurupin/job_search/blob/master/LICENSE)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/tsurupin/job_search.svg)](https://beta.hexfaktor.org/github/tsurupin/job_search)

# [Startup Job](http://demo.job-search.tsurupin.com/)


**Startup Job** is a sample project to search startup jobs scraped from various websites written in [Elixir](http://elixir-lang.org/)/[Phoenix](http://www.phoenixframework.org/)(Backend) and [React](https://facebook.github.io/react/)/[Redux](http://redux.js.org/)(Frontend).
 
This project is an umbrella project.
 - Customer app is for processing data and rendering contents. 
 - Scraper app is for scraping data from websites.
 

Demo
-------
[http://demo.job-search.tsurupin.com/](ttp://demo.job-search.tsurupin.com/)

![](https://cloud.githubusercontent.com/assets/1782169/26284819/c05013f8-3df8-11e7-908b-3907c284aa92.gif)

Motivation
-------
I created this app to understand Elixir/OTP and get more familliar with React.

Main Technology Stack
-------
* React
* Redux
* Elixir
* Phoenix
* Elasticsearch
* [styled-components](https://styled-components.com/)


Requirements
-------
- Elixir 1.4+
- Phoenix 1.3+
- Node 7.0+
- PostgreSQL 9.4+
- Elasticsearch


Development
--------

### Setup
1. Get the repo.

        % git clone git@github.com:tsurupin/job_search.git
        
2. Install Elasticsearch in local environment.

   [Mac OS](https://chartio.com/resources/tutorials/how-to-install-elasticsearch-on-mac-os-x/)

3. Change username and password of PostgreSQL 

       % vi apps/customer/config/dev.exs
        
3. Setup your environment.

        % cd apps/customer
        % mix deps.get
        % mix ecto.setup
        % cd assets
        % npm install 
        
        
4. Scrape data 

        % cd ../../scraper         
        % mix deps.get 
        % iex -S mix
        % Scraper.Site.Accel.Show.perform("http://google/com", "Test", "Software engineer", "San Francisco, CA, US", :test)
        % Scraper.Site.A16z.Show.perform("http://google/com", "Sample", "Senior software engineer", "Seattle, WA, US", :test)
        % Scraper.Site.Sequoia.Show.perform("http://google/com", :test)
        % Customer.Builder.EsReindex.perform  
        
5. Create a new OAuth account([URL](https://console.developers.google.com/apis/credentials)) (Optional. Google OAuth account is needed to login and logout)

        1. Click `Create credentials` and Choose OAuth client ID
        2. Select Web Application and Set Authorizedredirect URIs as `http://localhost:4000/auth/google/callback`
        3. Set Client ID, Client secret and Authorized redirect URI of your OAuth account in apps/customer/config/dev.exs
        
        
6. Run customer application.

        % cd ../customer
        % mix phx.server

7. Verify that the app is up and running.

        % open http://localhost:4000

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