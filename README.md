# Crytrade

* Purpose:
   * Providing a proper trade journal while dealing with crypto-currencies
   * Help out in finding trade opportunities
* [A live instance is available on heroku](https://crytrade.herokuapp.com/)

### Prerequisites

- ruby 2.3
- *sql server (deployed production instance is postgresql based, dev currently on mysql)
- node and yarn

### Development setup

- Check _config/database.yml_ for the proper password and configuration
- Execute
> bin/rake db:create db:migrate db:seed

### Backend Architecture

   * /api/xxx: Unprotected apis (user not auth)
   
### Used technologies

   * Backend: Ruby, Rails, *Sql
   * Frontend: Html, Css, Sass, Bootstrap 4, Javascript, JQuery, React
