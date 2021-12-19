class AddStorageTrigger < ActiveRecord::Migration[6.1]
  def change
    execute <<-SQL
    create or replace function ait_function()
    returns trigger
    language plpgsql
as
    $$
    declare
        sid int;
    begin
        sid := (Select id from storage where portfolio_id = new.portfolio_id and ticker = new.ticker);
        if (sid is null) then
            Insert into storage(portfolio_id, ticker, amount) values(new.portfolio_id, new.ticker, new.amount);
    else
            Update storage set amount = amount + new.amount where storage.id = sid;
        end if;
return new;
    end;
$$;


create trigger AI_Transaction
    after insert on transactions
    for each row
    execute procedure ait_function();

$$
    SQL
  end
end
