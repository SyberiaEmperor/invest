# MMCS Invest API

This is a project made by students of SFEDU MMCS. 
Provides an API for holding an info about invest portfolio.

## Routes:



###Регистрация пользователя. Отдаёт JWT-токен.
post '/auth/sign_up', to: 'auth#sign_up'
###Получение пользователя (JWT-токена). В теле передаётся логин + пароль
```ruby
post '/auth/sign_in'
```
    example:
    get server.com/auth/sign_in
    body:
    {
    login:
    pass
    }
    {
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDAxNTg3NTB9.QRbxnvNK-W7Sxg2Ez5xUg9KXI3h5B6CDzFDXx8DF7sQ"
    }

###Secure zone. Для корректного выполнения требуется JWT-токен в заголовке запроса.

get '/user', to: 'user#info' #Выдаёт общую информацию по пользователю. Например: Логин, кол-во портфелей

#Даёт информацию о портфелях пользователя. Если id пустой - возвращает краткую сводку по всем портфелям пользователя.
#Если id не пустой - возвращает информацию о конкретном портфеле
#Параметр currency отвечает за то, в какой валюте будет отображен портфель.
get '/portfolios/:id', to: 'portfolios#show'#, defaults: { currency: 'RUB' }

get '/portfolios', to: 'portfolios#index'#, defaults: { :currency => 'RUB' }

#Создаёт портфель. Возвращает id созданного портфеля в случае успеха.
post '/portfolios', to: 'portfolios#create'
#Создаёт транзакцию в потрфеле. Возвращает id созданной транзакции в случае успеха.
# Принимает в себя: Ticker, количество, изменение баланса, id портфеля
post '/portfolios/:portfolio_id/transaction', to: 'transaction#create'


#Удаляет портфель по заданному id. Если id = nil - ничего не происходит.
delete '/portfolios/:id', to: 'portfolios#delete'

end

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
