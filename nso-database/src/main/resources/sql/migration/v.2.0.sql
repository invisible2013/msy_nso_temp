ALTER TABLE person ADD COLUMN gender_id integer;

CREATE TABLE public.gender
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT gender_pkey PRIMARY KEY (id)
);
ALTER TABLE public.gender
  OWNER TO nso;

INSERT INTO public.gender(id, name) VALUES (1, 'მდედრობითი');
INSERT INTO public.gender(id, name) VALUES (2, 'მამრობითი');


INSERT INTO public.event_type(id, name,application_type_id) VALUES (20, 'მასობრივი სპორტი',2);

ALTER TABLE person ADD COLUMN create_date date;

UPDATE public.person SET create_date='2017-01-01';

INSERT INTO public.users_group(id, name,description) VALUES (7,'manager', 'მენეჯერი');

ALTER TABLE public.users ADD COLUMN manager_id integer;
ALTER TABLE public.users ADD COLUMN supervisor_id integer;


CREATE TABLE public.message
(
  id integer NOT NULL,
  name character varying,
  description character varying,
  number character varying,
  sender_user_id integer,
  receiver_user_id integer,
  status_id integer,
  create_date date,
  due_date date,
  url character varying,
  CONSTRAINT message_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.message
  OWNER TO nso;


CREATE TABLE public.message_document
(
  id integer NOT NULL,
  message_id integer,
  type_id integer,
  name character varying,
  url character varying,
  CONSTRAINT message_document_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.message_document
  OWNER TO nso;


CREATE TABLE public.message_status
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT message_status_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.message_status
  OWNER TO nso;


INSERT INTO public.message_status(id, name) VALUES (1, 'მიმდინარე');
INSERT INTO public.message_status(id, name) VALUES (2, 'დასრულებული');
INSERT INTO public.message_status(id, name) VALUES (3, 'დაბრუნებული');


CREATE TABLE public.message_history
(
  id integer NOT NULL,
  message_id integer,
  sender_id integer,
  recipient_id integer,
  status_id integer,
  create_date date,
  note character varying,
  url character varying,
  CONSTRAINT message_history_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.message_history
  OWNER TO nso;


INSERT INTO public.event_status(id, name,description,stage) VALUES (14,'reject', 'დახარვეზებული',14);
INSERT INTO public.event_status(id, name,description,stage) VALUES (15,'manager_reject', 'მენეჯერის უარი',15);


ALTER TABLE users ADD COLUMN phone2 character varying;

UPDATE public.event_type SET name='საქართველო / შეჯიბრი / ჩემპიონატი' where id=1;
UPDATE public.event_type SET name='უცხოეთი / შეჯიბრი / ჩემპიონატი' where id=5;
delete from public.event_type where id=2;
delete from public.event_type where id=6;
update public.event set event_type=1 where event_type=2;
update public.event set event_type=5 where event_type=6;
UPDATE public.event_type SET name='საქართველო / სასწავლო საწვრთნელი შეკრება/ტესტმატჩები' where id=3;
UPDATE public.event_type SET name='უცხოეთი / სასწავლო საწვრთნელი შეკრება/ტესტმატჩები' where id=7;


ALTER TABLE public.users ADD COLUMN url character varying;


CREATE TABLE public.calendar
(
  id integer NOT NULL,
  name character varying,
  location character varying,
  sender_user_id integer,
  create_date date,
  event_date date,
  calendar_type_id integer,
  first double precision,
  second double precision,
  third double precision,
  fourth double precision,
  status_id integer,
  CONSTRAINT calendar_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.calendar
  OWNER TO nso;

CREATE TABLE public.calendar_type
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT calendar_type_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.calendar_type
  OWNER TO nso;

INSERT INTO public.calendar_type(id, name) VALUES (1, 'ღონისძიებები (შეჯიბრებები, შეკრებები, სემინარები, კონგრესები, კონფერენციები) და მათთან დაკავშირებული ხარჯები');
INSERT INTO public.calendar_type(id, name) VALUES (2, 'სპორტული ორგანიზაციის მართვასთან დაკავშირებული ხარჯები ');
INSERT INTO public.calendar_type(id, name) VALUES (3, 'საერთაშორისო სპორტული ორგანიზაციების საწევროები');

CREATE TABLE public.calendar_status
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT calendar_status_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.calendar_status
  OWNER TO nso;

INSERT INTO public.calendar_status(id, name) VALUES (1, 'ახალი');
INSERT INTO public.calendar_status(id, name) VALUES (2, 'დაბლოკილი');
INSERT INTO public.calendar_status(id, name) VALUES (3, 'გაგზავნილი');
INSERT INTO public.calendar_status(id, name) VALUES (4, 'შესწორებული');






CREATE TABLE public.annual_report
(
  id integer NOT NULL,
  year integer,
  sender_user_id integer,
  introduction character varying,
  result character varying,
  governance character varying,
  qualification character varying,
  popularisation character varying,
  fight character varying,
  gender_issue character varying,
  alternative character varying,
  mass character varying,
  conclusion character varying,
  create_date date,
  CONSTRAINT annual_report_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.annual_report
  OWNER TO nso;

CREATE TABLE public.annual_report_document
(
  id integer NOT NULL,
  annual_report_id integer,
  type_id integer,
  name character varying,
  CONSTRAINT annual_report_document_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.annual_report_document
  OWNER TO nso;


CREATE TABLE public.annual_report_document_type
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT annual_report_document_type_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.annual_report_document_type
  OWNER TO nso;

INSERT INTO public.annual_report_document_type(id, name) VALUES (1, 'მოკლევადიანი სტრატეგია/სამოქმედო გეგმა');
INSERT INTO public.annual_report_document_type(id, name) VALUES (2, 'გრძელვადიანი სტრატეგია/სამოქმედო გეგმა');


ALTER TABLE calendar ADD COLUMN participant character varying;
ALTER TABLE calendar ADD COLUMN note character varying;


CREATE TABLE public.document
(
  id integer NOT NULL,
  name character varying,
  url character varying,
  CONSTRAINT document_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.document
  OWNER TO nso;



CREATE TABLE public.competition
(
  id integer NOT NULL,
  name character varying,
  category character varying,
  sender_user_id integer,
  federation_id integer,
  create_date date,
  competition_date date,
  location character varying,
  group_quantity character varying,
  professional character varying,
  discipline character varying,
  CONSTRAINT competition_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.competition
  OWNER TO nso;


CREATE TABLE public.competition_person
(
  id integer NOT NULL,
  competition_id integer,
  person_id integer,
  CONSTRAINT competition_person_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.competition_person
  OWNER TO nso;

=================
ALTER TABLE calendar ADD COLUMN end_date date;

CREATE TABLE public.annual_report_status
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT annual_report_status_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.annual_report_status
  OWNER TO nso;

INSERT INTO public.annual_report_status(id, name) VALUES (1, 'ახალი');
INSERT INTO public.annual_report_status(id, name) VALUES (2, 'დაბლოკილი');
INSERT INTO public.annual_report_status(id, name) VALUES (3, 'გაგზავნილი');
INSERT INTO public.annual_report_status(id, name) VALUES (4, 'შესწორებული');

ALTER TABLE annual_report ADD COLUMN status_id integer;
ALTER TABLE annual_report ADD COLUMN note character varying;


==============
/*version temporary */
CREATE TABLE public.championship
(
  id integer not null,
  user_id integer,
  name character varying,
  description character varying,
  location character varying,
  start_date DATE,
  end_date DATE,
  create_date DATE,
  championship_type_id integer,
  championship_sub_type_id integer,
  CONSTRAINT championship_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.championship
  OWNER TO nso;


CREATE TABLE public.result
(
  id integer not null,
  championship_id integer,
  user_id INTEGER,
  sportsman_id integer,
  award_id integer,
  discipline character varying,
  category character varying,
  note character varying,
  score character varying,
  create_date DATE,
  CONSTRAINT result_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.result
  OWNER TO nso;


  CREATE TABLE public.championship_type
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT championship_type_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.championship_type
  OWNER TO nso;


  CREATE TABLE public.championship_sub_type
(
  id integer NOT NULL,
  name character varying,
  championship_type_id integer,
  CONSTRAINT championship_sub_type_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.championship_sub_type
  OWNER TO nso;


  INSERT INTO public.championship_type(id, name) VALUES (1, 'ადგილობრივი');
  INSERT INTO public.championship_type(id, name) VALUES (2, 'საერთაშორისო');
  INSERT INTO public.championship_type(id, name) VALUES (3, 'ახალგაზრდული');


   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (1, 'ეროვნული ჩემპიონატი',1);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (2, 'ოლიმპიური თამაშები',2);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (3, 'მსოფლიო ჩემპიონატი',2);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (4, 'ევროპის ჩემპიონატი',2);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (5, 'საერთაშორისო შეჯიბრი',2);
      INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (6, 'ოლიმპიური თამაშები',3);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (7, 'მსოფლიო ჩემპიონატი',3);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (8, 'ევროპის ჩემპიონატი',3);
   INSERT INTO public.championship_sub_type(id, name, championship_type_id) VALUES (9, 'საერთაშორისო შეჯიბრი',3);


CREATE TABLE public.award
(
  id integer NOT NULL,
  name character varying,
  CONSTRAINT award_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.award
  OWNER TO nso;


 INSERT INTO public.award(id, name) VALUES (1, 'პირველი ადგილი');
 INSERT INTO public.award(id, name) VALUES (2, 'მეორე ადგილი');
 INSERT INTO public.award(id, name) VALUES (3, 'მესამე ადგილი');
 INSERT INTO public.award(id, name) VALUES (4, 'სხვა');


