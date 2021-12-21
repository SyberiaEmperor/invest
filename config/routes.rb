Rails.application.routes.draw do
  #Руты, отвечающие за механизм авторизации

  #Регистрация пользователя. Отдаёт JWT-токен.
  post '/auth/sign_up', to: 'auth#sign_up'
  #Получение пользователя (JWT-токена). В теле передаётся логин + пароль
  post '/auth/sign_in', to: 'auth#sign_in'


  #Secure zone. Для корректного выполнения требуется JWT-токен в заголовке запроса.

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
