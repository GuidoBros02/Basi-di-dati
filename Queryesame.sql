/*Query 1	CORRETTA
Restituire l'elenco degli artisti (deceduti/viventi) che sono stati scelti nella creazioe di storie. 
Ordinare il risultato in ordine crescente per numero di volte in cui, un artista, compare nelle storie 
(perchè selezionato in opere che compongono una storia). 
Riportare la durata (AVG(TimeStampFine-TimeStampInizio)) in minuti media delle storie.*/
select IdStoria, storia.Titolo from Storia join utente on storia.utente=utente.email 
where 2022-extract (year from utente.datanascita) between 35 
and 50 and storia.opera3 is not null order by (storia.timestampfinale-storia.timestampiniziale) desc

/*Query 2	NON CORRETTA
Selezionare tutte le storie degli utenti di età compresa tra [35<=x<=50] anni (estremi inclusi) 
che contengono almeno 2 opere d'arte (>=2). Ordinare le storie in ordine decrescente di durata della storia 
(durata =TimeStampFine - TimeStampInizio)*/
Select storia.Idstoria, storia.Titolo, count(Opera3) as numeropere, AVG((timestampfinale-timestampfinale)/60) as durata
from Storia join Utente on (utente.email=storia.utente) 
join Opera on(Opera.codice=Storia.Opera1 or Opera.codice=Storia.Opera2 or Opera.codice=Storia.Opera3) 
where (2022-extract(year from utente.datanascita)between 30 and 60)
Group by Storia.IDstoria
Order by durata desc

/*Query 3 CORRETTA
Restituire CF, nome, cognome, età e data di nascita dell'utente che ha creato il maggior numero di storie 
che NON HANNO ricevuto commenti da altri utenti. Ordinare il risultato in 
ordine decrescente per numero storie create*/
select utente.email, utente.nome, 2023-extract(year from utente.datanascita)as eta, utente.datanascita,
count(idstoria)
from Utente join storia on(utente.email=storia.utente) 
group by Utente.email 
except select utente.email, utente.nome, 2023-extract(year from utente.datanascita)as eta, utente.datanascita,
count(storia.idstoria) from Utente join storia on(utente.email=storia.utente) 
join Commento on (commento.storia=storia.Idstoria)
group by Utente.email

/*Query 4	CORRETTA
Restituire l’elenco delle opere che sono state maggiormente selezionate dagli utenti nella creazione 
delle loro storie, che hanno età compresa [25<=x<=55] (estremi inclusi). 
Ordinare il risultato in ordine decrescente per TitoloOpera*/
select opera.titolo, autore.nome, autore.datanascita, count(Opera.codice) as numeroselezioni 
from Opera join Autore on(Autore.Nome=Opera.NomeAutore) 
join Storia on (Opera.Codice=Storia.Opera1 or Opera.Codice=Storia.Opera2 or Opera.Codice=Storia.Opera3)
join utente on (utente.email=storia.utente)
where (2022-extract (year from utente.datanascita) between 25 and 55) 
group by Opera.titolo, autore.nome
order by (opera.titolo)desc

/*Query 5	CORRETTA
Restituire l'elenco degli artisti (deceduti/viventi) che sono stati scelti nella creazione di storie. 
Ordinare il risultato in ordine crescente per numero di volte in cui, un artista, 
compare nelle storie (perchè selezionato in opere che compongono una storia). 
Riportare la durata (AVG(TimeStampFine-TimeStampInizio)) in minuti media delle storie.*/
select Autore.Nome, count(Idstoria) as numeroapparizioni, Autore.DataMorte, 
AVG((timestampfinale-timestampiniziale)/60) as DurataMediaStoria
from Autore join Opera on (Autore.nome=Opera.NomeAutore) 
join Storia on (Opera.Codice=Opera1 or Opera.Codice=Storia.Opera2 or Opera.Codice=Storia.Opera3)
group by Autore.Nome
order by numeroapparizioni asc

/*Query 6 CORRETTA
Per ogni utente che ha creato almeno 2 storie, si vuole conoscere la durata media delle sue storie 
(AVG(TimeStampFine-TimeStampInizio)) in minuti, numero di like e numero totale di commenti. 
Ordinare il risultato in ordine decrescente per età dell'utente.*/
select utente.nome, 2023-extract(year from utente.datanascita)as eta,
AVG((timestampfinale-timestampiniziale)/60) as DurataMediaStoria, count(distinct Commento.testo) as numerocommento, 
count(distinct valutazioni.likes)as numeroLike
from Utente join storia on (Utente.Email=Storia.Utente) left join Commento on (storia.idstoria=commento.storia) 
join Valutazioni on (storia.idstoria=valutazioni.storia)
Group by utente.nome, eta
having count (storia.idstoria)>=2
order by eta desc 


/*Query 7	COMPLETO
Per ogni curatore che lavora all'interno del museo che ha creato almeno 2 storie, si vuole conoscere l'età media 
degli utenti che hanno commentato le sue storie. Restituire il risultato in ordine decrescente per durata media 
(AVG(TimeStampFine-TimeStampInizio)) in minuti delle storie create da curatore museale.*/
select Curatore.Nome, 2023-extract(year from Curatore.DataNascita)as eta, (AVG(timestampfinale-timestampiniziale))
as duratamedia, count(distinct idstoria) as StorieCreate, avg(2023-extract(year from utente.datanascita))as etamediautente 
from Utente as Curatore join Storia on (Curatore.email=Storia.Utente) 
join Commento on (Storia.idstoria=Commento.Storia) join Utente on (Commento.Utente=Utente.Email) 
where curatore.curatore='true' 
Group by Curatore.nome, eta
having count(distinct idstoria)>=2
order by duratamedia desc


/*Query 8	 COMPLETO
Restituire le storie che sono state create da utenti di età compresa tra [25<=x<=50] anni (estremi inclusi) 
CHE NON SONO curatori ma che hanno ricevuto commenti solo da curatori. Ordinare il risultato in ordine decrescente per 
durata della storia (AVG(TimeStampFine-TimeStampInizio))*/
select storia.idstoria, storia.titolo, storia.datacreazione, avg(storia.timestampfinale-storia.timestampiniziale) as durata, 
count(distinct Commento.testo) as numerocommenti, avg(2023-extract(year from Curatore.datanascita))as etamediautente 
from utente join storia on(utente.email=storia.utente)
join Commento on(Commento.storia=storia.idstoria) join Utente as Curatore on (Commento.utente=Curatore.email)
right join valutazioni on (Valutazioni.utente=curatore.email)  
where (2023-extract (year from utente.datanascita) between 25 and 50) and utente.curatore='false' and curatore.curatore='true'
group by storia.idstoria
order by durata desc

/*Query 9
Restituire nome, cognome e età (in anni) dei curatori che hanno commentato almeno 2 storie di utenti di età compresa 
tra [20<=x<=45] anni (estremi inclusi). Ordinare il risultato per numero decrescente di commenti.*/
select Curatore.nome, (2023-extract (year from curatore.datanascita)) as etaCuratore, 
avg(storia.timestampfinale-storia.timestampiniziale), count(distinct commento.testo) as numerocommenti, 
(avg(2023-extract (year from utente.datanascita))) as etamediautenti
from Utente as Curatore join Commento on(Curatore.email=Commento.utente) join storia on(Commento.storia=storia.idStoria)
Join utente on(storia.utente=utente.email)
where (2023-extract (year from utente.datanascita)between 20 and 60) and curatore.curatore='true'
group by Curatore.nome, etaCuratore
having count(distinct commento.testo)<=2
Order by (numerocommenti) desc

select *from Stpria

/*Query 10
Restituire nome, cognome e età (in anni) dei curatori che NON hanno commentato almeno 2 storie di utenti di età compresa
tra [20<=x<=35] anni (estremi inclusi). Ordinare il risultato per numero decrescente di commenti.*/
select Curatore.nome, (2023-extract (year from Curatore.datanascita)) as etacuratore, 
avg(storia.timestampfinale-storia.timestampiniziale) as duratamedia,
count(distinct commento.testo) as numerocommenti, avg(2023-extract (year from Utente.datanascita)) as etautenti
from Utente as Curatore join Commento on (Commento.utente=Curatore.Email) join Storia on (Storia.IdStoria=Commento.Storia) join 
Utente on (Utente.email=Storia.Utente)
where Curatore.Curatore='True'
group by Curatore.nome, etacuratore
Except select Curatore.nome, (2023-extract (year from Curatore.datanascita)) as etacuratore, 
avg(storia.timestampfinale-storia.timestampiniziale) as duratamedia,
count(distinct commento.testo) as numerocommenti, avg(2023-extract (year from utente.datanascita)) as etautenti
from Utente as Curatore join Commento on (Commento.utente=Curatore.Email) join Storia on (Storia.IdStoria=Commento.Storia) join 
Utente on (Utente.email=Storia.Utente)
where Curatore.Curatore='True' and (2023-extract (year from utente.datanascita)) between 20 and 35
Group by Curatore.nome, etacuratore
having count(distinct commento.testo)>=2
Order by (numerocommenti) desc


/*Query 11
Restituire nome, cognome e età (in anni) dei curatori che hanno commentato almeno 2 storie di utenti fragili che hanno 
ricevuto almeno 2 like. Ordinare il risultato per numero decrescente di like.*/
select Curatore.nome, (2022-extract (year from Curatore.datanascita)) as etacuratore, count(Distinct idstoria) as storiefragili, 
count(Commento.testo) as numerocommenti, count(Valutazioni.likes) as NumeroLike
from  Storia join Utente on (Storia.Utente=Utente.email) join Commento on(Commento.storia=Storia.idstoria)
join Valutazioni on (Storia.idstoria=Valutazioni.storia) join Utente as Curatore on (Commento.utente=Curatore.email)
where Curatore.curatore='true' and Utente.utentefragile='true' and valutazioni.likes='True'
group by Curatore.nome, EtaCuratore
having count (distinct idstoria)>=1 and count (distinct valutazioni.likes)>=1
order by (numerolike) desc


/*Query 12 CORRETTO
Restituire, per ogni utente, id, titolo della storia e numero delle opere contenute (nella storia) di tutte le storie 
suggerite dal sistema che hanno emozioni opposte*/

Select Utente.email, utente.nome, storiecorrelate.storiaopposta, storia2.titolo
from storia join Storiecorrelate on (Storia.idstoria=storiecorrelate.storiariferita) 
join Storia as Storia2 on (Storiecorrelate.storiaopposta=storia2.idstoria) join Utente on (Storia.utente=utente.email)
