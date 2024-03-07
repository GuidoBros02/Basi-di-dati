/*creazione di un dominio per il voto, che deve essere in scala Likert da 1 a 10*/
create domain voto as smallint default NULL check (value>=1 and value<=10);

/*creazione di sequenze per avere degli identificatori incrementali*/
create sequence id_opera_seq increment by 1 start with 1;
create sequence id_storia_seq increment by 1 start with 10000;
create sequence id_valutazioni_seq increment by 1 start with 20000;
create sequence id_annotazioni_seq increment by 1 start with 30000;
create sequence id_commento_seq increment by 1 start with 40000;


create table Utente
(
	Nome varchar(30) not null,
	Email varchar(30) primary key,
	DataNascita date not null,
	Genere char not null,
	Curatore boolean not null,
	UtenteFragile boolean not null,
	check(Genere='M' or Genere='F')
);

create table Gruppo 
(
	NomeGruppo varchar(30) not null, 
	Curatore varchar (30) default 'Curatore', 
	foreign key (Curatore) references Utente(Email)
	on update cascade
	on delete set default,
	Supervisore varchar (30) default 'Supervisore',
	foreign key (Supervisore)references Utente(Email)
	on update cascade
	on delete set default,
	Attivita varchar(20),
	primary key(NomeGruppo,Curatore)
);

create table PartecipazioneGruppo
(
	Utente varchar(30) default 'Utente',
	foreign key (Utente) references Utente(Email) 
	on update cascade
	on delete set default,
	Gruppo varchar(30) not null, 
	Curatore varchar (30) default 'Curatore', 
	foreign key(Gruppo, Curatore) references Gruppo(NomeGruppo,Curatore)
	on update cascade
	on delete cascade,
	primary key (Gruppo, Utente, Curatore) 
);

create table Autore
(
	Nome varchar (30) primary key,
	DataNascita date not null,
	DataMorte date, 
	Stile varchar (20),
	Movimento varchar (20),
	Curatore varchar (30) default 'Curatore',
	foreign key (Curatore) references Utente(Email)
	on update cascade
	on delete set default
);

create table Opera
(
	Codice int default nextval('id_opera_seq') primary key,
	Titolo varchar(20) not null,
	NomeAutore varchar(30) not null references Autore(Nome) 
	on update cascade
	on delete cascade,
	Tecnica varchar(20),
	Materiale varchar(20),
	Anno numeric(4) not null,
	Disponibilita  boolean not null, --true: online, false: in presenza
	Descrizione boolean not null,
	DescrizioneAudio boolean not null,
	Curatore varchar(30) default 'Utente',
	foreign key (Curatore) references Utente(Email)
	on update cascade
	on delete set default
);


create table Storia
(
	Utente varchar(30) default 'Utente',
	foreign key (Utente) references Utente(Email) 
	on update cascade
	on delete set default,
	Titolo varchar(30) not null,
	Opera1 int  not null references Opera(Codice)
	on update cascade
	on delete cascade,
	Opera2 int not null references Opera(Codice)
	on update cascade
	on delete cascade,
	Opera3 int references Opera(Codice)
	on update cascade
	on delete cascade,
	Commento varchar (30),
	Hashtag varchar (20),
	TimestampIniziale time not null, 
	TimestampFinale time not null,
	DataCreazione date not null,
	IdStoria int default nextval('id_storia_seq') primary key
);

create table StorieCorrelate
(
	StoriaRiferita int references Storia(IdStoria)
	on update cascade
	on delete cascade,
	StoriaOpposta int not null references Storia(IdStoria)
	on update cascade
	on delete cascade,
	StoriaSimile int not null references Storia(IdStoria)
	on update cascade
	on delete cascade,
	StoriaUguale int not null references Storia(IdStoria)
	on update cascade
	on delete cascade,
	primary key (StoriaRiferita)
);

create table Valutazioni
(
	IdValutazione int default nextval('id_valutazioni_seq') primary key,
	Storia int not null references Storia(IdStoria)
	on update cascade
	on delete cascade,
	Utente varchar(30) default 'Utente',
	foreign key (Utente) references Utente(Email)
	on update cascade
	on delete set default,
	Valutazione voto,
	Likes boolean
);

create table Annotazioni
(
	IdAnnotazione int default nextval('id_annotazioni_seq') primary key,
	Emoji varchar(10),
	Utente varchar(30) default 'Utente',
	foreign key (Utente) references Utente(Email)
	on update cascade
	on delete set default,
	Opera int not null references Opera(Codice)
	on update cascade
	on delete cascade, 
	Risposte varchar(50),
	Hashtag varchar(20)
);
	  
create table Commento
(
	IdCommento int default nextval('id_commento_seq') primary key,
	Utente varchar(30) default 'Utente',
	foreign key (Utente) references Utente(Email)
	on update cascade
	on delete set default,
	Storia int references Storia(IdStoria)
	on update cascade
	on delete cascade, 
	Testo varchar (50) not null
);


insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Guido Broglio', 'GB@gmail.com', '03/12/1998' , 'M', 'True', 'False');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Matteo Cartieri', 'AGG@gmail.com', '21/09/1992' , 'M', 'True', 'False');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Giulia Rossi', 'Rossi@libero.it', '04/08/97' , 'F', 'False', 'False');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Giorgio Rossetti', 'Rossetti@libero.it', '01/02/85' , 'M', 'False', 'True');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Alessia Bianchi', 'AleBia90@gmail.com', '06/04/90' , 'F', 'False', 'False');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Lorena Verdi','Lore13@gmail.com', '15/11/01', 'F', 'False', 'True');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Maria Bronzata','Mariabronz@gmail.com', '10/09/71', 'F', 'False', 'False');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Federica Marino','Marino.Fede@gmail,com', '10/07/94', 'F', 'False', 'False');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Antonino Moretti','AM95@libero.it', '03/11/95', 'M', 'True', 'True');
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) values ('Marco Silvestri','Silvestri.Marco@gmail.com', '15/07/82', 'M', 'False', 'False');

insert into Gruppo(NomeGruppo, Curatore, Supervisore, Attivita) values ('Arte Contemporanea', 'AGG@gmail.com', 'Lore13@gmail.com', 'Museali');
insert into Gruppo(NomeGruppo, Curatore, Supervisore, Attivita) values ('Scultura', 'AM95@libero.it', 'Rossi@libero.it', 'Ricerca');
insert into Gruppo(NomeGruppo, Curatore, Supervisore, Attivita) values ('Accademia di Brera', 'GB@gmail.com', 'GB@gmail.com', 'Ricerca');
insert into Gruppo(NomeGruppo, Curatore, Supervisore, Attivita) values ('Michelangelo', 'AM95@libero.it', 'Silvestri.Marco@gmail.com', 'Museali');

insert into PartecipazioneGruppo(Utente, Gruppo, Curatore) values('Rossetti@libero.it', 'Arte Contemporanea', 'AGG@gmail.com');
insert into PartecipazioneGruppo(Utente, Gruppo, Curatore) values('Mariabronz@gmail.com', 'Scultura', 'AM95@libero.it');
insert into PartecipazioneGruppo(Utente, Gruppo, Curatore) values('Lore13@gmail.com', 'Accademia di Brera', 'GB@gmail.com');
insert into PartecipazioneGruppo(Utente, Gruppo, Curatore) values('AM95@libero.it', 'Accademia di Brera', 'GB@gmail.com');
insert into PartecipazioneGruppo(Utente, Gruppo, Curatore) values('AleBia90@gmail.com', 'Michelangelo', 'AM95@libero.it');
insert into PartecipazioneGruppo(Utente, Gruppo, Curatore) values('AleBia90@gmail.com', 'Arte Contemporanea', 'AGG@gmail.com');

insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Michelangelo Buonarroti', '06/03/1475', '18/02/1564', 'Arte Rinascimentale', 'Rinascimento', 'AGG@gmail.com');
insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Leonardo Da Vinci', '15/04/1452', '02/05/1519', 'Arte Rinascimentale', 'Rinascimento', 'AGG@gmail.com');
insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Pablo Picasso', '25/10/1881', '08/04/1973', 'Cubismo', 'Cubismo', 'GB@gmail.com');
insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Francesco Hayez', '10/02/1791', '12/02/1882', 'Romanticismo', 'Romanticismo', 'AGG@gmail.com');
insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Vincent Van Gogh', '30/03/1853', '29/07/1890', 'Postimpressionismo', 'Postimpressionismo', 'GB@gmail.com');
insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Gian Lorenzo Bernini', '07/12/1598', '28/011/1680', 'Barocco', 'Barocco', 'AM95@libero.it');

insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'David', 'Michelangelo Buonarroti', 'Scultura', 'Marmo', '1504', 'false', 'true', 'true', 'AGG@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Guernica', 'Pablo Picasso', 'Dipinto', 'Olio su tela', '1937', 'true', 'true', 'false', 'GB@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Il bacio', 'Francesco Hayez', 'Dipinto', 'Olio su tela', '1859', 'true', 'true', 'true', 'AGG@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Notte stellata', 'Vincent Van Gogh', 'Dipinto', 'Olio su tela', '1889', 'false', 'true', 'true', 'GB@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Apollo e Dafne', 'Gian Lorenzo Bernini', 'Scultura', 'Marmo', '1625', 'true', 'true', 'true', 'AM95@libero.it');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'La Pietà', 'Michelangelo Buonarroti', 'Scultura', 'Marmo', '1499', 'true', 'true', 'false', 'AGG@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'La Gioconda', 'Leonardo Da Vinci', 'Dipinto', 'Olio su tavola', '1506', 'false', 'true', 'true', 'AGG@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Bacco', 'Michelangelo Buonarroti', 'Scultura', 'Marmo', '1497', 'false', 'true ', 'true', 'AGG@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Il sogno', 'Pablo Picasso', 'Dipinto', 'Olio Su tela', '1932', 'True', 'true ', 'true', 'GB@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Ratto di Proserpina', 'Gian Lorenzo Bernini', 'Scultura', 'Marmo', '1625', 'true', 'true', 'true', 'AM95@libero.it');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Girasoli', 'Vincent Van Gogh', 'Dipinto', 'Olio su tela', '1889', 'false', 'true', 'true', 'GB@gmail.com');
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (Default, 'Autoritratto', 'Vincent Van Gogh', 'Dipinto', 'Olio su tela', '1889', 'true', 'true', 'true', 'GB@gmail.com');

insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('Rossi@libero.it', 'Giornata al Museo', 0007, 0002, 0004, '🥰', '#arte', '17:25:36', '17:27:00', '10/10/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('Mariabronz@gmail.com', 'Il grande Michelangelo' , 0001, 0006, 0008, NULL, '#michelangelo', '15:49:11', '15:48:55', '09/09/2022', Default); 
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AGG@gmail.com', 'Arte allo stato solido', 0005, 0006, 0008, '🤩', NULL, '11:22:33', '11:23:53', '15/10/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AleBia90@gmail.com', 'Passione pittura', 0004, 0011, NULL, '🖌', '#painting', '13:59:01', '13:59:52', '30/09/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('Lore13@gmail.com', 'Arte: bellezza da cui imparare', 0003, 0009, 0002, NULL, '#culture', '14:39:05', '14:40:30', '03/10/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AleBia90@gmail.com', 'Amore su tela', 0003, 0005, NULL, '😍', '#love', '17:30:08', '17:30:29', '21/09/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AM95@libero.it', 'Il colore è espressività', 0004, 0011, NULL, '💫', '#vangogh', '18:11:09', '18:12:49', '03/10/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AleBia90@gmail.com', 'Cubismo arte stravagante', 0002, 0008, NULL, NULL, '#ppicasso', '13:45:50', '14:00:50', '30/09/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AGG@gmail.com', 'A Normal Work Day', 0003, 0005, 0001, '💪', '#museum', '18:12:36', '18:13:59', '15/10/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AleBia90@gmail.com', 'Tutti in posa!', 0007, 0008, 0012, NULL, '#selfie', '14:20:15', '14:21:58', '21/09/2022', Default);
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('AM95@libero.it', 'Il Genio di Michelangelo', 0001, 0006, 0008, NULL, '#michelangelo', '18:21:10', '18:21:35', '03/10/2022', Default);

insert into StorieCorrelate(StoriaRiferita, StoriaOpposta, StoriaSimile, StoriaUguale) values(10001, 10003, 10005, 10009);
insert into StorieCorrelate(StoriaRiferita, StoriaOpposta, StoriaSimile, StoriaUguale) values(10002, 10007, 10003, 10005);
insert into StorieCorrelate(StoriaRiferita, StoriaOpposta, StoriaSimile, StoriaUguale) values(10006, 10007, 10003, 10005);
insert into StorieCorrelate(StoriaRiferita, StoriaOpposta, StoriaSimile, StoriaUguale) values(10007, 10002, 10001, 10010);
insert into StorieCorrelate(StoriaRiferita, StoriaOpposta, StoriaSimile, StoriaUguale) values(10009, 10008, 10004, 10001);

insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10002, 'AGG@gmail.com', '3', 'False');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10004, 'GB@gmail.com', '9', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10005, 'Mariabronz@gmail.com', '7', 'False');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10006, 'Lore13@gmail.com', '8', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10002, 'Rossi@libero.it', '2', 'False');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10003, 'Lore13@gmail.com', '8', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10001, 'GB@gmail.com', '8', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10003, 'GB@gmail.com', '10', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10010, 'AGG@gmail.com', '7', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10007, 'AGG@gmail.com', '5', 'False');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10003, 'Silvestri.Marco@gmail.com', '10', 'True');
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10005, 'AM95@libero.it', '8', 'True');

insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, '📕', 'AleBia90@gmail.com', 0001, 'Libro di arte, Scuola, Bene', '#memory');
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, '🤔', 'Rossetti@libero.it' , 0002, NULL, '#picasso');
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, NULL, 'Lore13@gmail.com', 0004, 'una notte stellata, alla notte, tranquilla', '#vangogh');
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, NULL, 'GB@gmail.com', 0005, 'Epica greca, alla scuola, felice', '#michelangelo');
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, '🌻', 'AGG@gmail.com', 0011, 'la mia infanzia, casa dei nonni, nostalgico', NULL);
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, NULL, 'GB@gmail.com', 0011, 'Estate, Estate, rilassato', '#vangogh');
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, '💪', 'Silvestri.Marco@gmail.com', 0001, 'Firenze, Forza Umana, potente', '#David&Golia');

insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'Lore13@gmail.com', 10003, 'Che meraviglia');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'AGG@gmail.com', 10008, 'Ottima scelta');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'Mariabronz@gmail.com', 10003, 'Questa storia è simile alla mia!');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'Marino.Fede@gmail,com', 10001, 'Scelta azzeccata');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'AGG@gmail.com', 10007, 'Adoro van Gogh');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'GB@gmail.com', 10003, 'Mi piace la disposizione che hai scelto');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'Rossetti@libero.it', 10005, 'Approvo la scelta');
insert into Commento(IdCommento, Utente, Storia, Testo) values(Default, 'Rossi@libero.it', 10002, 'Non mi piace la tua storia');
