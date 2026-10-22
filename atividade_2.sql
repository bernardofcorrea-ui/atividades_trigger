-- exec 1
create table contas (
    id serial primary key,
    cliente varchar(100) not null,
    saldo numeric(10, 2) not null default 0.00
);

-- exec 2

create table movimentacoes (
id serial primary key,
conta_id int references contas(id),
tipo varchar(1) check (tipo in ('C', 'D')),
valor numeric(10,2) not null,
data_movimentacao timestamp default current_timestamp
);

-- exec 3

CREATE OR REPLACE FUNCTION fn_atualiza_saldo_conta()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo = 'C' THEN
        UPDATE contas SET saldo = saldo + NEW.valor WHERE id = NEW.conta_id;
    ELSIF NEW.tipo = 'D' THEN
        UPDATE contas SET saldo = saldo - NEW.valor WHERE id = NEW.conta_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- exec 4

CREATE TRIGGER trg_atualiza_saldo
AFTER INSERT ON movimentacoes
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_saldo_conta();

-- exec 5

insert into contas (cliente, saldo) values ('João silva', 5.00)

-- exec 6

select * from contas where id = 1;

-- exec 7

insert into movimentacoes (conta_id, tipo, valor) values (1, 'D', 150.00)

-- exec 8

select * from contas where id = 1
