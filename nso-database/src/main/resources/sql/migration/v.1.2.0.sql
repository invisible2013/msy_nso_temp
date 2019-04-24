ALTER DATABASE edoc RENAME TO nso;
ALTER DATABASE nso OWNER TO nso;
ALTER TABLE public.application_type OWNER TO nso;
ALTER TABLE public.event OWNER TO nso;
ALTER TABLE public.event_decision OWNER TO nso;
ALTER TABLE public.event_document OWNER TO nso;
ALTER TABLE public.event_document_type OWNER TO nso;
ALTER TABLE public.event_history OWNER TO nso;
ALTER TABLE public.event_person OWNER TO nso;
ALTER TABLE public.event_status OWNER TO nso;
ALTER TABLE public.event_type OWNER TO nso;
ALTER TABLE public.id_generator OWNER TO nso;
ALTER TABLE public.person OWNER TO nso;
ALTER TABLE public.person_type OWNER TO nso;
ALTER TABLE public.users OWNER TO nso;
ALTER TABLE public.users_group OWNER TO nso;
ALTER TABLE public.users_status OWNER TO nso;


alter table event add column letter_number character varying;
update event set create_date = last_status_date;
alter table person add column type_id integer;
alter table person add column user_id integer;

update event_document_type set name ='განაცხადის დოკუმენტი' where id>=32 and id<=40;
update event_document_type set event_type_id = 0 where id<22 and id!=6;


