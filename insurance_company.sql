create database insurance_company;
\c insurance_company;

CREATE SCHEMA employee;
CREATE SCHEMA admin_;

CREATE USER employee;
create user administrator createdb createrole;

CREATE DOMAIN telephone as text
	CHECK (value ~'^((\+7|7|8)+([0-9]){10})$');

CREATE TYPE mounth_ AS ENUM('January', 'February', 'March', 'April', 'May', 'June', 'Jule', 'August', 'September', 'November', 'December');

CREATE TABLE branch( --select
	branchID SERIAL PRIMARY KEY,
	Name text NOT NULL,
	Adress text NOT NULL,
	Phone telephone NOT NULL
);
CREATE TABLE agent( --select, update
	agentID serial PRIMARY KEY,
	branchID int REFERENCES branch ON UPDATE CASCADE ON DELETE RESTRICT,
	FirstName text NOT NULL,
	LastName text NOT NULL,
	Patronymic text NULL,
	Adress text NOT NULL,
	Phone telephone NOT NULL
);

CREATE TABLE client(--select, update, delete
	clientID serial PRIMARY KEY,
	branchID int REFERENCES branch ON UPDATE CASCADE ON DELETE RESTRICT,
	FirstName text NOT NULL,
	LastName text NOT NULL,
	Patronymic text NULL,
	Adress text NOT NULL,
	Phone telephone NOT NULL
);

CREATE TABLE CONTRACT( --select, update, delete
	contractID serial PRIMARY KEY,
	branchID int REFERENCES branch ON UPDATE CASCADE ON DELETE RESTRICT,
	insuranceType text NOT NULL,
	insuranceAmount int NOT NULL CHECK (insuranceAmount>0),
	tariffRate double NOT NULL CHECK (tariffRate>=0),
	insuranceDate date NOT NULL,
	clientID int REFERENCES client ON UPDATE CASCADE ON DELETE RESTRICT,
	agentID int REFERENCES agent ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE payment(--select
	paymentID serial PRIMARY KEY,
	Date mounth_ NOT NULL,
	agentID int REFERENCES agent ON UPDATE CASCADE ON DELETE RESTRICT,
	pay decimal(20,2) NOT NULL 
);

CREATE TABLE insuranceTypes( --
    insuranceID serial PRIMARY KEY,
    name text not null,
    tariffRate float not null
);

grant select on branch to employee;
grant select, update, delete on client to employee;
grant select, update on agent to employee;
grant select, update, delete on contract to employee;
grant select on payment to employee;

INSERT INTO branch VALUES
(1, 'asddaw','ul.Lenina.44','+79229473676');
INSERT INTO branch VALUES(
2, 'aasdw3ddaw','ul.Lenina.44','+79229473676');

INSERT INTO agent VALUES(
1,1,'rafw','wqdasd','a2ed','ul.Lenina.44', '+79229473676');
INSERT INTO agent VALUES(
2,2,'Fatr','w2r','regs','ul.Lenina.44', '+79229473676'
);

INSERT INTO client VALUES(
1,1,'raefw','weqdasd','ae2ed','ul.Lenina.44', '+79229473676'
);
INSERT INTO client VALUES(
2,2,'Fater','w2er','reges','ul.Lenina.44', '+79229473676'
);

INSERT INTO contract VALUES(
1,1,'agaad',1000,0.1,'2020-12-2',1,1
);
INSERT INTO contract VALUES(
2,2,'qwrras',9999,0.2,'2020-12-2',2,2
);
INSERT INTO contract VALUES(
3,1,'adidas',9999,0.2,'2021-01-2',2,2
);
INSERT INTO contract VALUES(
4,1,'adidasaa',9999,0.2,'2021-01-2',2,2
);
INSERT INTO contract VALUES(
5,1,'adidasaaws',9999,0.2,'2020-12-2',2,2
);
CREATE PROCEDURE employee.paymentCalculation(int agent, mounth_ cMonth)
language PLPGSQL
AS $$
    select sum(contract.insuranceamount*contract.tariffrate) from contract where(agent = contract.agentID and extract(month from current_date) = extract(month from contract.insuranceDate));
    select agent from contract having(agentID = contract.agentID and extract(month from current_date) = extract(month from contract.insuranceDate));
$$

INSERT 