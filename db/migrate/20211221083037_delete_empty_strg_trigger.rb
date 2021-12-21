class DeleteEmptyStrgTrigger < ActiveRecord::Migration[6.1]
  def change
    execute <<-SQL
 create or replace function aus_function()
    returns trigger
    language plpgsql
as
$$
begin
    if (new.amount = 0) then
        Delete from storages where id = new.id;
    end if;
    return new;
end;
$$;

DROP TRIGGER IF EXISTS  AU_Storage on storages;
create trigger AU_Storage
    after update on storages
    for each row
execute procedure aus_function();
    SQL
  end
end
