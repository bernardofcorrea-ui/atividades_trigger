-- exec 1
create table estoque(
id serial primary key,
nome_item varchar(100) not null,
quantidade int not null default 0
);

-- exec 2

create or replace function fn_valida_estoque_minimo()
returns trigger as $$
begin
	if NEW.quantidade < 0 then
		raise exception 'Operação cancelada! O item "%" não pode ter estoque negativo (Tentativa: % unidades(s)).',
			NEW.nome_item, NEW.quantidade;
	end if;
	return new;
end;

$$ language plpgsql;

-- exec 3 

create trigger trg_valida_estoque
before insert or update on estoque
for each row
execute function fn_valida_estoque_minimo();

-- exec 4

insert into estoque (nome_item,quantidade) values ('Tecladinho mecha-nikko', 10)

-- exec 5

select * from estoque
