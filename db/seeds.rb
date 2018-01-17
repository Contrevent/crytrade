# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.exists? email: 'admin@example.com'
  User.create(email: 'admin@example.com', password: 'Welcome@123')
end

unless Fiat.exists? symbol: 'USD'
  Fiat.create(name: 'US Dollar', symbol: 'USD', price_usd: 1)
end

unless Fiat.exists? symbol: 'EUR'
  Fiat.create(name: 'Euro', symbol: 'EUR', price_usd: 0.81947)
end

FiatTickerJob.perform_now

CmcTickerJob.perform_now