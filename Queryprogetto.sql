/*Inserisce nuove Opere*/
insert into Opera(Codice, Titolo, NomeAutore, Tecnica, Materiale, Anno, Disponibilita, Descrizione, DescrizioneAudio, Curatore) values (default, 'Autoritratto', 'Pablo Picasso', 'Olio su tela', 'Tela', '1910', 'false', 'true', 'true', 'AGG@gmail.com');

/*Modifica la disponibilità di un’Opera*/
Update Opera set Disponibilita= 'true' where Codice=0001

/*Inserisce un Autore*/
insert into Autore(Nome, DataNascita, DataMorte, Stile, Movimento, Curatore) values ('Raffaello Sanzio', '10/10/1483', '06/04/1520', 'Rinascimento', 'Rinascimento', 'AGG@gmail.com');

/*Inserisci una Storia*/
insert into Storia(Utente, Titolo, Opera1, Opera2, Opera3, Commento, Hashtag, TimestampIniziale, TimestampFinale, DataCreazione, IdStoria) values ('Silvestri.Marco@gmail.com', 'Giornata al Museo', 0007, 0002, 0004, '🥰', '#arte', '17:17:17', '17:18:19', '10/10/2022', Default)

/*Visualizza una Storia*/
select * from storia where IdStoria=10001;

/*Elimina una Storia*/
delete from Storia where IdStoria=10010;

/*Elimina un Utente*/
delete from Utente where Email='Lore13@gmail.com';

/*Elimina una Annotazione*/ 
delete from Annotazioni where Utente='Lore13@gmail.com';

/*Elimina un Commento*/
delete from Commento where Utente='Lore13@gmail.com';

/*Assegna a un Utente la supervisione di un gruppo*/
update Gruppo set Supervisore='Lore13@gmail.com' 
where Gruppo.NomeGruppo='Scultura';

/*Crea un gruppo*/
insert into Gruppo(NomeGruppo, Curatore, Supervisore, Attivita) values ('Arte Moderna', 'GB@gmail.com', 'Silvestri.Marco@gmail.com', 'Museali');

/*Crea un’Annotazione*/
insert into Annotazioni(IdAnnotazione, Emoji, Utente, Opera, Risposte, Hashtag) values (Default, NULL, 'GB@gmail.com', 0005, 'Epica greca, alla scuola, felice', '#michelangelo');

/*Crea un Commento*/
insert into Commento(IdAnnotazione, Utente, Storia, Testo) values(Default, 'Rossetti@libero.it', 10004, 'Approvo la scelta');

/*Crea una Valutazione*/
insert into Valutazioni(IdValutazione, Storia, Utente, Valutazione, Likes) values (default, 10007, 'Silvestri.Marco@gmail.com', '6', 'True');

/*Calcola l’eta' media degli utenti*/
select avg(2023-extract (year from DataNascita)) as EtaMedia 
from Utente;

/*Trova le Storie in ordine crescente/decrescente per Valutazione */
select IdStoria, Titolo, Valutazione 
from Storia join Valutazioni on Storia.IdStoria=Valutazioni.Storia  
order by Valutazione desc;

/*Trova le Storie in ordine crescente/decrescente per Eta' dell’Utente */
select IdStoria, Titolo, (2023-extract (year from DataNascita)) as EtaUtente
from Storia join Utente on Storia.Utente=Utente.Email 
order by EtaUtente asc;

/*Trova le Storie in ordine crescente/decrescente per Durata */
select IdStoria, Titolo, (TimestampFinale-TimestampIniziale) as Durata
from Storia 
order by Durata desc;

/*Trova le Storie con piu' Valutazioni su Utenti maschi/femmine */
select IdStoria, Titolo, Genere, count(IdValutazione) as NumValutazioni 
from Storia join Valutazioni on Storia.IdStoria=Valutazioni.Storia join Utente on Storia.Utente=Utente.Email
where Utente.Genere='F' 
group by (IdStoria,Titolo,Genere)
order by NumValutazioni desc;

/*Inserisce un nuovo Utente */
insert into Utente(Nome, Email, DataNascita, Genere, Curatore, UtenteFragile) 
values ('Flavio Broglio', 'FB@gmail.com', '03/12/2002' , 'M', 'false', 'false');

/*Visualizza un’Opera */
select * 
from Opera;

/*Visualizza tutte le Storie create da un Utente*/
select Storia.* 
from Storia join Utente on Storia.Utente=Utente.Email
where Email='AGG@gmail.com';

/*Visualizza tutte le Storie commentate da un Utente*/
select Storia.IdStoria, Storia.Titolo, Storia.Opera1, Storia.Opera2, Storia.Opera3, Commento.Utente, Commento.Testo
from Commento join Utente on Commento.Utente=Utente.Email join Storia on Commento.Storia=Storia.IdStoria
where Utente.Email='AGG@gmail.com';

/*Visualizza tutte le Annotazioni create da un Utente*/
select Annotazioni.* 
from Annotazioni join Utente on Annotazioni.Utente=Utente.Email
where Email='AGG@gmail.com';

/*Visualizza la descrizione audio di un’Opera*/
select DescrizioneAudio 
from Opera 
where Codice=3;

/*Per gli Utenti Fragili, crea un’Annotazione ma senza il campo “Risposte”*/
insert into Annotazioni(Emoji, Utente, Opera, Risposte, Hashtag) 
values ('🤩', 'Lore13@gmail.com', 3, null, '#david');

/*Promuovi utente a Curatore*/
update Utente set Curatore='True'
where Email='Silvestri.Marco@gmail.com'

/*Aggiornare dataMorte di un autore*/
Update Autore set DataMorte='09/09/2022'
where Nome='Pablo Picasso'

/*Elimina un utente*/
Delete from utente where email='Silvestri.Marco@gmail.com'

/*Modifica disponibilità descrizione audio in Opera*/
Update Opera set DescrizioneAudio= 'true' where Codice=0006

