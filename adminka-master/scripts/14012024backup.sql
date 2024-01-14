PGDMP     *    +                 |            Pottery    15.4    15.4 ~    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    24829    Pottery    DATABASE     }   CREATE DATABASE "Pottery" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "Pottery";
                postgres    false            �           0    0    SCHEMA "public"    COMMENT     8   COMMENT ON SCHEMA "public" IS 'standard public schema';
                   pg_database_owner    false    4            �           1247    25084    fio    TYPE     c   CREATE TYPE "public"."fio" AS (
	"first_name" "text",
	"last_name" "text",
	"patronymic" "text"
);
    DROP TYPE "public"."fio";
       public          postgres    false            �           1247    25097    product_info    TYPE     ]   CREATE TYPE "public"."product_info" AS (
	"type" "text",
	"name" "text",
	"price" integer
);
 #   DROP TYPE "public"."product_info";
       public          postgres    false            �           1247    25087    program_full    TYPE     e   CREATE TYPE "public"."program_full" AS (
	"title" "text",
	"description" "text",
	"price" integer
);
 #   DROP TYPE "public"."program_full";
       public          postgres    false            �           1247    25090    program_info    TYPE     e   CREATE TYPE "public"."program_info" AS (
	"title" "text",
	"description" "text",
	"price" integer
);
 #   DROP TYPE "public"."program_info";
       public          postgres    false            �            1255    25077     change_members(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE "public"."change_members"(IN "rec_id" integer, IN "memb" integer)
    LANGUAGE "plpgsql"
    AS $$
begin
	if memb <= 0 then
		raise exception 'memers must be positive';
	end if;

	if not exists(select * from record where record.id = rec_id) then
		raise exception 'an record with such an ID was not found';
	end if;
	
	update record
	set members = memb
	where record.id = rec_id;
end; $$;
 R   DROP PROCEDURE "public"."change_members"(IN "rec_id" integer, IN "memb" integer);
       public          postgres    false            �            1255    25080    check_orders_customer()    FUNCTION     0  CREATE FUNCTION "public"."check_orders_customer"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
	if (select status from account where account.id = new.customer) != 'действителен' then
		raise exception 'аккаунт не действителен';
	end if;
	return new;
end;$$;
 2   DROP FUNCTION "public"."check_orders_customer"();
       public          postgres    false            �            1255    25075    delete_records("date", "date") 	   PROCEDURE       CREATE PROCEDURE "public"."delete_records"(IN "date1" "date", IN "date2" "date")
    LANGUAGE "plpgsql"
    AS $$
begin
	if date1 > date2 then
		raise exception 'date2 must be bigger than date1' ;
	end if;
						
	delete from record where
	date <= date2 and date >= date1;
end; $$;
 P   DROP PROCEDURE "public"."delete_records"(IN "date1" "date", IN "date2" "date");
       public          postgres    false            �            1255    25094 *   get_program_title("public"."program_info")    FUNCTION     �   CREATE FUNCTION "public"."get_program_title"("p" "public"."program_info") RETURNS "text"
    LANGUAGE "plpgsql"
    AS $$
BEGIN 
	RETURN p.title;
END;
$$;
 I   DROP FUNCTION "public"."get_program_title"("p" "public"."program_info");
       public          postgres    false    914            �            1255    25074    increase_prices(real) 	   PROCEDURE     �   CREATE PROCEDURE "public"."increase_prices"(IN real)
    LANGUAGE "plpgsql"
    AS $_$
begin
	update product
	set price = price * $1;
end;$_$;
 4   DROP PROCEDURE "public"."increase_prices"(IN real);
       public          postgres    false            �            1255    25069    master_record_dates("text")    FUNCTION     _  CREATE FUNCTION "public"."master_record_dates"("last_name" "text") RETURNS "date"[]
    LANGUAGE "plpgsql"
    AS $_$
DECLARE
	cur CURSOR FOR SELECT * FROM worker WHERE worker.last_name = $1 AND post = 2;
	dates date[];
BEGIN
	FOR r IN cur LOOP 
		dates = array(select date from record where r.id = record.master);
	END LOOP;
	return dates;
END;
$_$;
 B   DROP FUNCTION "public"."master_record_dates"("last_name" "text");
       public          postgres    false            �            1255    25100    money_for_all_date()    FUNCTION     �   CREATE FUNCTION "public"."money_for_all_date"() RETURNS TABLE("date" "date", "money" integer)
    LANGUAGE "plpgsql"
    AS $$
	BEGIN
SELECT date, SUM(price) from orderr
GROUP BY date;
END;
$$;
 /   DROP FUNCTION "public"."money_for_all_date"();
       public          postgres    false            �            1255    25101    money_for_all_dates()    FUNCTION     �   CREATE FUNCTION "public"."money_for_all_dates"() RETURNS TABLE("date" "date", "money" integer)
    LANGUAGE "plpgsql"
    AS $$
	BEGIN
SELECT orderr.date, SUM(price) from orderr
GROUP BY orderr.date;
END;
$$;
 0   DROP FUNCTION "public"."money_for_all_dates"();
       public          postgres    false            �            1255    25078    post_delete()    FUNCTION       CREATE FUNCTION "public"."post_delete"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
	if exists (select * from worker where worker.post = old.id) then
		raise exception 'на этой должности есть работники';
	end if;
	return old;
end;$$;
 (   DROP FUNCTION "public"."post_delete"();
       public          postgres    false            �            1255    25073    product_for_budget(integer)    FUNCTION       CREATE FUNCTION "public"."product_for_budget"("spec" integer) RETURNS TABLE("id" integer, "type" "text", "name" "text", "price" integer)
    LANGUAGE "sql"
    AS $$
SELECT id, type, name, price FROM product 
WHERE (price <= spec)
ORDER BY price DESC
LIMIT 5;
$$;
 =   DROP FUNCTION "public"."product_for_budget"("spec" integer);
       public          postgres    false            �            1255    25072    product_for_price(integer)    FUNCTION     �   CREATE FUNCTION "public"."product_for_price"("spec" integer) RETURNS TABLE("id" integer, "type" "text", "name" "text", "price" integer)
    LANGUAGE "sql"
    AS $$
SELECT id, type, name, price FROM product 
WHERE (price <= spec)
$$;
 <   DROP FUNCTION "public"."product_for_price"("spec" integer);
       public          postgres    false            �            1255    25104 (   product_in_date("public"."product_info")    FUNCTION     �   CREATE FUNCTION "public"."product_in_date"("p" "public"."product_info") RETURNS TABLE("date" "date", "count" integer)
    LANGUAGE "plpgsql"
    AS $$
	BEGIN
SELECT orderr.date, count(id) from orderr
where product_info = p
GROUP BY orderr.date;
END;
$$;
 G   DROP FUNCTION "public"."product_in_date"("p" "public"."product_info");
       public          postgres    false    917            �            1255    25182    program_status()    FUNCTION     {   CREATE FUNCTION "public"."program_status"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
return new;
END; 
$$;
 +   DROP FUNCTION "public"."program_status"();
       public          postgres    false            �            1255    25103 &   ptype_in_date("public"."product_info")    FUNCTION     �   CREATE FUNCTION "public"."ptype_in_date"("p" "public"."product_info") RETURNS TABLE("date" "date", "count" integer)
    LANGUAGE "plpgsql"
    AS $$
	BEGIN
SELECT orderr.date, count(id) from orderr
where product_info = p
GROUP BY orderr.date;
END;
$$;
 E   DROP FUNCTION "public"."ptype_in_date"("p" "public"."product_info");
       public          postgres    false    917            �            1255    25102 %   type_in_date("public"."product_info")    FUNCTION     �   CREATE FUNCTION "public"."type_in_date"("p" "public"."product_info") RETURNS TABLE("date" "date", "count" integer)
    LANGUAGE "plpgsql"
    AS $$
	BEGIN
SELECT date, count(id) from orderr
where product_info = p
GROUP BY date;
END;
$$;
 D   DROP FUNCTION "public"."type_in_date"("p" "public"."product_info");
       public          postgres    false    917            �            1259    24841    account    TABLE     
  CREATE TABLE "public"."account" (
    "id" integer NOT NULL,
    "role" character varying(20) NOT NULL,
    "status" character varying(20) DEFAULT 'действителен'::character varying,
    "login" character varying(20) NOT NULL,
    "pwd" character varying(20) NOT NULL,
    "first_name" character varying(20) NOT NULL,
    "last_name" character varying(20) NOT NULL,
    "patronymic" character varying(30),
    "gender" character varying(10) NOT NULL,
    "birthday" "date" NOT NULL,
    "telephone" character varying(12),
    CONSTRAINT "account_birthday_check" CHECK ((("birthday" > '1923-01-01'::"date") AND ("birthday" < CURRENT_DATE))),
    CONSTRAINT "account_gender_check" CHECK (((("gender")::"text" = 'м'::"text") OR (("gender")::"text" = 'ж'::"text")))
);
    DROP TABLE "public"."account";
       public         heap    postgres    false            �            1259    24840    account_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."account_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE "public"."account_id_seq";
       public          postgres    false    215            �           0    0    account_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE "public"."account_id_seq" OWNED BY "public"."account"."id";
          public          postgres    false    214            �            1259    24870    orderr    TABLE     �  CREATE TABLE "public"."orderr" (
    "id" integer NOT NULL,
    "date" "date" NOT NULL,
    "customer" integer,
    "product" integer,
    "status" character varying(20) DEFAULT 'в обработке'::character varying,
    "note" "text",
    "product_info" "public"."product_info",
    "account" integer,
    CONSTRAINT "orderr_date_check" CHECK ((("date" > '2022-01-01'::"date") AND ("date" <= CURRENT_DATE)))
);
    DROP TABLE "public"."orderr";
       public         heap    postgres    false    917            �            1259    24869    orderr_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."orderr_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."orderr_id_seq";
       public          postgres    false    219            �           0    0    orderr_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE "public"."orderr_id_seq" OWNED BY "public"."orderr"."id";
          public          postgres    false    218            �            1259    24951    post    TABLE     �   CREATE TABLE "public"."post" (
    "id" integer NOT NULL,
    "title" character varying(30) NOT NULL,
    "salary" integer NOT NULL,
    "description" "text",
    CONSTRAINT "post_salary_check" CHECK (("salary" > 0))
);
    DROP TABLE "public"."post";
       public         heap    postgres    false            �            1259    24950    post_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."post_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE "public"."post_id_seq";
       public          postgres    false    223            �           0    0    post_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE "public"."post_id_seq" OWNED BY "public"."post"."id";
          public          postgres    false    222            �            1259    24855    product    TABLE     E  CREATE TABLE "public"."product" (
    "id" integer NOT NULL,
    "type" character varying(20) NOT NULL,
    "name" character varying(20) NOT NULL,
    "length" integer NOT NULL,
    "width" integer NOT NULL,
    "height" integer DEFAULT 1,
    "price" integer NOT NULL,
    "picture" character varying(50) NOT NULL,
    "status" character varying(20) DEFAULT 'в продаже'::character varying,
    "note" "text",
    "add1" character varying(50),
    "add2" character varying(50),
    "add3" character varying(50),
    "color" character varying(50),
    "design" character varying(50),
    CONSTRAINT "product_height_check" CHECK (("height" > 0)),
    CONSTRAINT "product_length_check" CHECK (("length" > 0)),
    CONSTRAINT "product_price_check" CHECK (("price" > 0)),
    CONSTRAINT "product_width_check" CHECK (("width" > 0))
);
    DROP TABLE "public"."product";
       public         heap    postgres    false            �            1259    25119    price_type_ranking    VIEW     �   CREATE VIEW "public"."price_type_ranking" AS
 SELECT "product"."type",
    "product"."price",
    "product"."name",
    "dense_rank"() OVER (PARTITION BY "product"."type" ORDER BY "product"."price") AS "dense_rank"
   FROM "public"."product";
 )   DROP VIEW "public"."price_type_ranking";
       public          postgres    false    217    217    217            �            1259    24854    product_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."product_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE "public"."product_id_seq";
       public          postgres    false    217            �           0    0    product_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE "public"."product_id_seq" OWNED BY "public"."product"."id";
          public          postgres    false    216            �            1259    24891    program    TABLE     �  CREATE TABLE "public"."program" (
    "id" integer NOT NULL,
    "title" character varying(30) NOT NULL,
    "description" "text",
    "max_members" integer NOT NULL,
    "price" integer NOT NULL,
    "picture" character varying(50),
    "status" character varying(20) DEFAULT 'есть записи'::character varying,
    CONSTRAINT "programm_max_members_check" CHECK ((("max_members" > 0) AND ("max_members" < 10))),
    CONSTRAINT "programm_price_check" CHECK (("price" > 0))
);
    DROP TABLE "public"."program";
       public         heap    postgres    false            �            1259    24890    programm_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."programm_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE "public"."programm_id_seq";
       public          postgres    false    221            �           0    0    programm_id_seq    SEQUENCE OWNED BY     L   ALTER SEQUENCE "public"."programm_id_seq" OWNED BY "public"."program"."id";
          public          postgres    false    220            �            1259    24989    record    TABLE     �  CREATE TABLE "public"."record" (
    "id" integer NOT NULL,
    "program" integer NOT NULL,
    "date" "date" NOT NULL,
    "time" integer NOT NULL,
    "master" integer NOT NULL,
    "assistant" integer,
    "customer" integer NOT NULL,
    "members" integer NOT NULL,
    "program_info" "public"."program_info",
    CONSTRAINT "record_date_check" CHECK (("date" > '2022-01-01'::"date")),
    CONSTRAINT "record_time_check" CHECK ((("time" >= 9) AND ("time" <= 19)))
);
    DROP TABLE "public"."record";
       public         heap    postgres    false    914            �            1259    24988    record_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."record_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."record_id_seq";
       public          postgres    false    227            �           0    0    record_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE "public"."record_id_seq" OWNED BY "public"."record"."id";
          public          postgres    false    226            �            1259    24961    worker    TABLE     �  CREATE TABLE "public"."worker" (
    "id" integer NOT NULL,
    "first_name" character varying(20) NOT NULL,
    "last_name" character varying(20) NOT NULL,
    "patronymic" character varying(30),
    "passport" character varying(10) NOT NULL,
    "gender" character varying(10) NOT NULL,
    "birthday" "date" NOT NULL,
    "telephone" character varying(12),
    "post" integer,
    "fio" "public"."fio",
    "kurator" integer,
    CONSTRAINT "worker_birthday_check" CHECK ((("birthday" > '1923-01-01'::"date") AND ("birthday" < CURRENT_DATE))),
    CONSTRAINT "worker_gender_check" CHECK (((("gender")::"text" = 'м'::"text") OR (("gender")::"text" = 'ж'::"text")))
);
    DROP TABLE "public"."worker";
       public         heap    postgres    false    908            �            1259    25145 
   vw_cubeeee    VIEW     Y  CREATE VIEW "public"."vw_cubeeee" AS
 SELECT "worker"."fio",
    "program"."title",
    "sum"("program"."price") AS "sum"
   FROM (("public"."worker"
     JOIN "public"."record" ON (("record"."master" = "worker"."id")))
     JOIN "public"."program" ON (("record"."program" = "program"."id")))
  GROUP BY CUBE("worker"."fio", "program"."title");
 !   DROP VIEW "public"."vw_cubeeee";
       public          postgres    false    221    221    221    225    225    227    227    908            �            1259    25110    vw_first_record    VIEW       CREATE VIEW "public"."vw_first_record" AS
 SELECT "program"."title",
    "first_value"("record"."date") OVER (PARTITION BY "record"."date" ORDER BY "program"."title") AS "first_value"
   FROM ("public"."record"
     JOIN "public"."program" ON (("record"."program" = "program"."id")));
 &   DROP VIEW "public"."vw_first_record";
       public          postgres    false    221    227    227    221            �            1259    25176    vw_kurators    VIEW     n  CREATE VIEW "public"."vw_kurators" AS
 WITH RECURSIVE "rec"("id", "kurator") AS (
         SELECT "worker"."id",
            "worker"."kurator"
           FROM "public"."worker"
          WHERE ("worker"."kurator" IS NULL)
        UNION ALL
         SELECT "sot"."id",
            "sot"."kurator"
           FROM ("public"."worker" "sot"
             JOIN "rec" ON (("rec"."id" = "sot"."kurator")))
        )
 SELECT "w"."id" AS "w_id",
    "w"."last_name" AS "w_last_name",
    "p1"."title" AS "w_post",
    "k"."id" AS "k_id",
    "k"."last_name" AS "k_last_name",
    "p2"."title" AS "k_post"
   FROM (((("rec" "r"
     JOIN "public"."worker" "w" ON (("r"."id" = "w"."id")))
     LEFT JOIN "public"."worker" "k" ON (("r"."kurator" = "k"."id")))
     JOIN "public"."post" "p1" ON (("p1"."id" = "w"."post")))
     LEFT JOIN "public"."post" "p2" ON (("p2"."id" = "k"."post")));
 "   DROP VIEW "public"."vw_kurators";
       public          postgres    false    225    223    223    225    225    225            �            1259    25140    vw_master_records    VIEW     S  CREATE VIEW "public"."vw_master_records" AS
 SELECT "worker"."fio",
    "program"."title",
    "sum"("program"."price") OVER (PARTITION BY "record"."master") AS "sum"
   FROM (("public"."worker"
     JOIN "public"."record" ON (("record"."master" = "worker"."id")))
     JOIN "public"."program" ON (("record"."program" = "program"."id")));
 (   DROP VIEW "public"."vw_master_records";
       public          postgres    false    225    227    227    221    221    221    225    908            �            1259    25053    vw_max_check_price    VIEW     '  CREATE VIEW "public"."vw_max_check_price" AS
 SELECT "product"."type",
    "max"("product"."price") AS "макс_цена"
   FROM ("public"."orderr"
     JOIN "public"."product" ON (("orderr"."product" = "product"."id")))
  GROUP BY "product"."type"
  ORDER BY ("max"("product"."price")) DESC;
 )   DROP VIEW "public"."vw_max_check_price";
       public          postgres    false    217    219    217    217            �            1259    25049    vw_max_salary    VIEW       CREATE VIEW "public"."vw_max_salary" AS
 SELECT "post"."title",
    "max"("post"."salary") AS "макс_ЗП"
   FROM ("public"."worker"
     JOIN "public"."post" ON (("worker"."post" = "post"."id")))
  GROUP BY "post"."title"
  ORDER BY ("max"("post"."salary")) DESC;
 $   DROP VIEW "public"."vw_max_salary";
       public          postgres    false    223    225    223    223            �            1259    25115    vw_program_record    VIEW       CREATE VIEW "public"."vw_program_record" AS
 SELECT "program"."title" AS "program",
    "count"("record"."id") AS "records"
   FROM ("public"."program"
     JOIN "public"."record" ON (("record"."program" = "program"."id")))
  GROUP BY CUBE("program"."title");
 (   DROP VIEW "public"."vw_program_record";
       public          postgres    false    227    227    221    221            �            1259    25045    vw_worker_post    VIEW       CREATE VIEW "public"."vw_worker_post" AS
 SELECT "post"."title",
    "count"("post"."title") AS "кол_во_должностей"
   FROM ("public"."post"
     JOIN "public"."worker" ON (("worker"."post" = "post"."id")))
  GROUP BY ROLLUP("post"."title");
 %   DROP VIEW "public"."vw_worker_post";
       public          postgres    false    223    225    223            �            1259    24960    worker_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."worker_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."worker_id_seq";
       public          postgres    false    225            �           0    0    worker_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE "public"."worker_id_seq" OWNED BY "public"."worker"."id";
          public          postgres    false    224            �           2604    24844 
   account id    DEFAULT     v   ALTER TABLE ONLY "public"."account" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."account_id_seq"'::"regclass");
 ?   ALTER TABLE "public"."account" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    215    214    215            �           2604    24873 	   orderr id    DEFAULT     t   ALTER TABLE ONLY "public"."orderr" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."orderr_id_seq"'::"regclass");
 >   ALTER TABLE "public"."orderr" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    24954    post id    DEFAULT     p   ALTER TABLE ONLY "public"."post" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."post_id_seq"'::"regclass");
 <   ALTER TABLE "public"."post" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    24858 
   product id    DEFAULT     v   ALTER TABLE ONLY "public"."product" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."product_id_seq"'::"regclass");
 ?   ALTER TABLE "public"."product" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    24894 
   program id    DEFAULT     w   ALTER TABLE ONLY "public"."program" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."programm_id_seq"'::"regclass");
 ?   ALTER TABLE "public"."program" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    221    220    221            �           2604    24992 	   record id    DEFAULT     t   ALTER TABLE ONLY "public"."record" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."record_id_seq"'::"regclass");
 >   ALTER TABLE "public"."record" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    226    227    227            �           2604    24964 	   worker id    DEFAULT     t   ALTER TABLE ONLY "public"."worker" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."worker_id_seq"'::"regclass");
 >   ALTER TABLE "public"."worker" ALTER COLUMN "id" DROP DEFAULT;
       public          postgres    false    224    225    225            �          0    24841    account 
   TABLE DATA                 public          postgres    false    215   ��       �          0    24870    orderr 
   TABLE DATA                 public          postgres    false    219   ��       �          0    24951    post 
   TABLE DATA                 public          postgres    false    223   ̳       �          0    24855    product 
   TABLE DATA                 public          postgres    false    217   ��       �          0    24891    program 
   TABLE DATA                 public          postgres    false    221   ��       �          0    24989    record 
   TABLE DATA                 public          postgres    false    227   "�       �          0    24961    worker 
   TABLE DATA                 public          postgres    false    225   �       �           0    0    account_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"public"."account_id_seq"', 99, true);
          public          postgres    false    214            �           0    0    orderr_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."orderr_id_seq"', 72, true);
          public          postgres    false    218            �           0    0    post_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('"public"."post_id_seq"', 7, true);
          public          postgres    false    222            �           0    0    product_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"public"."product_id_seq"', 64, true);
          public          postgres    false    216            �           0    0    programm_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('"public"."programm_id_seq"', 22, true);
          public          postgres    false    220            �           0    0    record_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."record_id_seq"', 72, true);
          public          postgres    false    226            �           0    0    worker_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."worker_id_seq"', 19, true);
          public          postgres    false    224            �           2606    24851    account account_login_key 
   CONSTRAINT     ]   ALTER TABLE ONLY "public"."account"
    ADD CONSTRAINT "account_login_key" UNIQUE ("login");
 I   ALTER TABLE ONLY "public"."account" DROP CONSTRAINT "account_login_key";
       public            postgres    false    215            �           2606    24849    account account_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY "public"."account"
    ADD CONSTRAINT "account_pkey" PRIMARY KEY ("id");
 D   ALTER TABLE ONLY "public"."account" DROP CONSTRAINT "account_pkey";
       public            postgres    false    215            �           2606    24853    account account_telephone_key 
   CONSTRAINT     e   ALTER TABLE ONLY "public"."account"
    ADD CONSTRAINT "account_telephone_key" UNIQUE ("telephone");
 M   ALTER TABLE ONLY "public"."account" DROP CONSTRAINT "account_telephone_key";
       public            postgres    false    215            �           2606    24879    orderr orderr_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."orderr"
    ADD CONSTRAINT "orderr_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."orderr" DROP CONSTRAINT "orderr_pkey";
       public            postgres    false    219                        2606    24959    post post_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY "public"."post"
    ADD CONSTRAINT "post_pkey" PRIMARY KEY ("id");
 >   ALTER TABLE ONLY "public"."post" DROP CONSTRAINT "post_pkey";
       public            postgres    false    223            �           2606    24868    product product_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY "public"."product"
    ADD CONSTRAINT "product_pkey" PRIMARY KEY ("id");
 D   ALTER TABLE ONLY "public"."product" DROP CONSTRAINT "product_pkey";
       public            postgres    false    217            �           2606    24901    program programm_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY "public"."program"
    ADD CONSTRAINT "programm_pkey" PRIMARY KEY ("id");
 E   ALTER TABLE ONLY "public"."program" DROP CONSTRAINT "programm_pkey";
       public            postgres    false    221            �           2606    24903    program programm_title_key 
   CONSTRAINT     ^   ALTER TABLE ONLY "public"."program"
    ADD CONSTRAINT "programm_title_key" UNIQUE ("title");
 J   ALTER TABLE ONLY "public"."program" DROP CONSTRAINT "programm_title_key";
       public            postgres    false    221                       2606    24997    record record_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."record"
    ADD CONSTRAINT "record_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."record" DROP CONSTRAINT "record_pkey";
       public            postgres    false    227                       2606    24970    worker worker_passport_key 
   CONSTRAINT     a   ALTER TABLE ONLY "public"."worker"
    ADD CONSTRAINT "worker_passport_key" UNIQUE ("passport");
 J   ALTER TABLE ONLY "public"."worker" DROP CONSTRAINT "worker_passport_key";
       public            postgres    false    225                       2606    24968    worker worker_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."worker"
    ADD CONSTRAINT "worker_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."worker" DROP CONSTRAINT "worker_pkey";
       public            postgres    false    225            
           2606    24972    worker worker_telephone_key 
   CONSTRAINT     c   ALTER TABLE ONLY "public"."worker"
    ADD CONSTRAINT "worker_telephone_key" UNIQUE ("telephone");
 K   ALTER TABLE ONLY "public"."worker" DROP CONSTRAINT "worker_telephone_key";
       public            postgres    false    225            �           1259    25019    ix_account_birthday    INDEX     U   CREATE INDEX "ix_account_birthday" ON "public"."account" USING "btree" ("birthday");
 +   DROP INDEX "public"."ix_account_birthday";
       public            postgres    false    215            �           1259    25021    ix_account_gender    INDEX     Q   CREATE INDEX "ix_account_gender" ON "public"."account" USING "btree" ("gender");
 )   DROP INDEX "public"."ix_account_gender";
       public            postgres    false    215            �           1259    25018    ix_account_id    INDEX     I   CREATE INDEX "ix_account_id" ON "public"."account" USING "btree" ("id");
 %   DROP INDEX "public"."ix_account_id";
       public            postgres    false    215            �           1259    25020    ix_account_lastname    INDEX     V   CREATE INDEX "ix_account_lastname" ON "public"."account" USING "btree" ("last_name");
 +   DROP INDEX "public"."ix_account_lastname";
       public            postgres    false    215            �           1259    25031    ix_orderr_customer    INDEX     S   CREATE INDEX "ix_orderr_customer" ON "public"."orderr" USING "btree" ("customer");
 *   DROP INDEX "public"."ix_orderr_customer";
       public            postgres    false    219            �           1259    25030    ix_orderr_date    INDEX     K   CREATE INDEX "ix_orderr_date" ON "public"."orderr" USING "btree" ("date");
 &   DROP INDEX "public"."ix_orderr_date";
       public            postgres    false    219            �           1259    25029    ix_orderr_id    INDEX     G   CREATE INDEX "ix_orderr_id" ON "public"."orderr" USING "btree" ("id");
 $   DROP INDEX "public"."ix_orderr_id";
       public            postgres    false    219            �           1259    25032    ix_orderr_status    INDEX     O   CREATE INDEX "ix_orderr_status" ON "public"."orderr" USING "btree" ("status");
 (   DROP INDEX "public"."ix_orderr_status";
       public            postgres    false    219            �           1259    25022 
   ix_post_id    INDEX     C   CREATE INDEX "ix_post_id" ON "public"."post" USING "btree" ("id");
 "   DROP INDEX "public"."ix_post_id";
       public            postgres    false    223            �           1259    25024    ix_post_salary    INDEX     K   CREATE INDEX "ix_post_salary" ON "public"."post" USING "btree" ("salary");
 &   DROP INDEX "public"."ix_post_salary";
       public            postgres    false    223            �           1259    25023    ix_post_title    INDEX     I   CREATE INDEX "ix_post_title" ON "public"."post" USING "btree" ("title");
 %   DROP INDEX "public"."ix_post_title";
       public            postgres    false    223            �           1259    25033    ix_product_id    INDEX     I   CREATE INDEX "ix_product_id" ON "public"."product" USING "btree" ("id");
 %   DROP INDEX "public"."ix_product_id";
       public            postgres    false    217            �           1259    25035    ix_product_status    INDEX     Q   CREATE INDEX "ix_product_status" ON "public"."product" USING "btree" ("status");
 )   DROP INDEX "public"."ix_product_status";
       public            postgres    false    217            �           1259    25034    ix_product_type    INDEX     M   CREATE INDEX "ix_product_type" ON "public"."product" USING "btree" ("type");
 '   DROP INDEX "public"."ix_product_type";
       public            postgres    false    217            �           1259    25036    ix_program_id    INDEX     I   CREATE INDEX "ix_program_id" ON "public"."program" USING "btree" ("id");
 %   DROP INDEX "public"."ix_program_id";
       public            postgres    false    221            �           1259    25037    ix_program_maxmembers    INDEX     Z   CREATE INDEX "ix_program_maxmembers" ON "public"."program" USING "btree" ("max_members");
 -   DROP INDEX "public"."ix_program_maxmembers";
       public            postgres    false    221            �           1259    25038    ix_program_status    INDEX     Q   CREATE INDEX "ix_program_status" ON "public"."program" USING "btree" ("status");
 )   DROP INDEX "public"."ix_program_status";
       public            postgres    false    221                       1259    25043    ix_record_assistant    INDEX     U   CREATE INDEX "ix_record_assistant" ON "public"."record" USING "btree" ("assistant");
 +   DROP INDEX "public"."ix_record_assistant";
       public            postgres    false    227                       1259    25044    ix_record_customer    INDEX     S   CREATE INDEX "ix_record_customer" ON "public"."record" USING "btree" ("customer");
 *   DROP INDEX "public"."ix_record_customer";
       public            postgres    false    227                       1259    25040    ix_record_date    INDEX     K   CREATE INDEX "ix_record_date" ON "public"."record" USING "btree" ("date");
 &   DROP INDEX "public"."ix_record_date";
       public            postgres    false    227                       1259    25039    ix_record_id    INDEX     G   CREATE INDEX "ix_record_id" ON "public"."record" USING "btree" ("id");
 $   DROP INDEX "public"."ix_record_id";
       public            postgres    false    227                       1259    25042    ix_record_master    INDEX     O   CREATE INDEX "ix_record_master" ON "public"."record" USING "btree" ("master");
 (   DROP INDEX "public"."ix_record_master";
       public            postgres    false    227                       1259    25041    ix_record_program    INDEX     Q   CREATE INDEX "ix_record_program" ON "public"."record" USING "btree" ("program");
 )   DROP INDEX "public"."ix_record_program";
       public            postgres    false    227                       1259    25028    ix_worker_birthday    INDEX     S   CREATE INDEX "ix_worker_birthday" ON "public"."worker" USING "btree" ("birthday");
 *   DROP INDEX "public"."ix_worker_birthday";
       public            postgres    false    225                       1259    25025    ix_worker_id    INDEX     G   CREATE INDEX "ix_worker_id" ON "public"."worker" USING "btree" ("id");
 $   DROP INDEX "public"."ix_worker_id";
       public            postgres    false    225                       1259    25026    ix_worker_lastname    INDEX     T   CREATE INDEX "ix_worker_lastname" ON "public"."worker" USING "btree" ("last_name");
 *   DROP INDEX "public"."ix_worker_lastname";
       public            postgres    false    225                       1259    25027    ix_worker_post    INDEX     K   CREATE INDEX "ix_worker_post" ON "public"."worker" USING "btree" ("post");
 &   DROP INDEX "public"."ix_worker_post";
       public            postgres    false    225                       2620    25081 $   orderr check_orders_customer_trigger    TRIGGER     �   CREATE TRIGGER "check_orders_customer_trigger" BEFORE INSERT ON "public"."orderr" FOR EACH ROW EXECUTE FUNCTION "public"."check_orders_customer"();
 C   DROP TRIGGER "check_orders_customer_trigger" ON "public"."orderr";
       public          postgres    false    248    219                       2620    25079    post post_delete_trigger    TRIGGER     ~   CREATE TRIGGER "post_delete_trigger" BEFORE DELETE ON "public"."post" FOR EACH ROW EXECUTE FUNCTION "public"."post_delete"();
 7   DROP TRIGGER "post_delete_trigger" ON "public"."post";
       public          postgres    false    223    247                       2620    25184    record program_status_t    TRIGGER        CREATE TRIGGER "program_status_t" AFTER INSERT ON "public"."record" FOR EACH ROW EXECUTE FUNCTION "public"."program_status"();
 6   DROP TRIGGER "program_status_t" ON "public"."record";
       public          postgres    false    255    227                       2606    25192 "   orderr fkfn2oumlsu5c1hmevcvvm9fp84    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."orderr"
    ADD CONSTRAINT "fkfn2oumlsu5c1hmevcvvm9fp84" FOREIGN KEY ("account") REFERENCES "public"."account"("id") ON DELETE RESTRICT;
 R   ALTER TABLE ONLY "public"."orderr" DROP CONSTRAINT "fkfn2oumlsu5c1hmevcvvm9fp84";
       public          postgres    false    219    215    3299                       2606    24880    orderr orderr_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."orderr"
    ADD CONSTRAINT "orderr_customer_fkey" FOREIGN KEY ("customer") REFERENCES "public"."account"("id") ON DELETE RESTRICT;
 K   ALTER TABLE ONLY "public"."orderr" DROP CONSTRAINT "orderr_customer_fkey";
       public          postgres    false    215    3299    219                       2606    24885    orderr orderr_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."orderr"
    ADD CONSTRAINT "orderr_product_fkey" FOREIGN KEY ("product") REFERENCES "public"."product"("id") ON DELETE RESTRICT;
 J   ALTER TABLE ONLY "public"."orderr" DROP CONSTRAINT "orderr_product_fkey";
       public          postgres    false    3310    217    219                       2606    25008    record record_assistant_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."record"
    ADD CONSTRAINT "record_assistant_fkey" FOREIGN KEY ("assistant") REFERENCES "public"."worker"("id") ON DELETE RESTRICT;
 L   ALTER TABLE ONLY "public"."record" DROP CONSTRAINT "record_assistant_fkey";
       public          postgres    false    225    3336    227                       2606    25013    record record_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."record"
    ADD CONSTRAINT "record_customer_fkey" FOREIGN KEY ("customer") REFERENCES "public"."account"("id") ON DELETE RESTRICT;
 K   ALTER TABLE ONLY "public"."record" DROP CONSTRAINT "record_customer_fkey";
       public          postgres    false    215    3299    227                       2606    25003    record record_master_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."record"
    ADD CONSTRAINT "record_master_fkey" FOREIGN KEY ("master") REFERENCES "public"."worker"("id") ON DELETE RESTRICT;
 I   ALTER TABLE ONLY "public"."record" DROP CONSTRAINT "record_master_fkey";
       public          postgres    false    227    3336    225                       2606    24998    record record_program_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."record"
    ADD CONSTRAINT "record_program_fkey" FOREIGN KEY ("program") REFERENCES "public"."program"("id") ON DELETE RESTRICT;
 J   ALTER TABLE ONLY "public"."record" DROP CONSTRAINT "record_program_fkey";
       public          postgres    false    227    221    3321                       2606    25150    worker worker_kurator_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."worker"
    ADD CONSTRAINT "worker_kurator_fkey" FOREIGN KEY ("kurator") REFERENCES "public"."worker"("id");
 J   ALTER TABLE ONLY "public"."worker" DROP CONSTRAINT "worker_kurator_fkey";
       public          postgres    false    225    3336    225                       2606    24973    worker worker_post_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."worker"
    ADD CONSTRAINT "worker_post_fkey" FOREIGN KEY ("post") REFERENCES "public"."post"("id") ON DELETE RESTRICT;
 G   ALTER TABLE ONLY "public"."worker" DROP CONSTRAINT "worker_post_fkey";
       public          postgres    false    3328    225    223            �   X  x��Z]oG}�WX~$\���������9R	}����u�^��B[*5�4BPT�g�b��v�QY{'���SG�������sϹ�+��׾]o����͍��(�����o�M�ٸ���+�f2��;Ny:�V4�1nl� F��q�}̇b\ėv6x�������A���n�Iz�ϧ��Q�qg�ˍ�X�q�z��W���n����G�A��"��f�<�oeo���e��>�s�� �x�=�{��ڝ���/;���0�q�+��.��a�#��~��g�3�#j�;�$�c-��\�{>s�9�^��X�5����Z]����r��[[�f����V�� � �є�]	����g�a��?�;]�<W���\�ı�N��"���%���;�Z8�p]�G��)gm	*� �z��W�'\W��$�/f8ʷ��r,���!��%�5��v�xp�J��b�vL$"�q8�����&m���; Q�.����?�Vl��t|��$���-Ʒk�����+�[ZJ���n=�K����\�}�_xu
�]�U�� { ����4�Q����9@v\���*Y��ثDy��:&3��"n)��j&�@O'Q�Tv4/��T|�Pg�=~����0���Nˡ-ʖ
��J���{���5#��U��߯؉��5{��umU���bfR�(x� ��H
��c�_�9�œ(�o||��,�KH+�N@&��R�I0N+��ʵ����h�
�z7VW��3v�F���訬g�?c�8�V�d׫����N���z��f)M�'!��&�����S��W�d+y�,��G��v;m�{�I\����hUFb(��@�0�YJ�/��Dz}�\AV[�5I�0͒=R1j�P�5�a�]�	\c��]( ��jT������h,���VU_�uXGT��V�u�P굉��e�h���t�HѰ�I�Ul�ʨ���0�Hz+PŴ/���X��I� �z���@m�3�<���ʄ���ì��$w�<�є��H�%� �<�Fk���,��z��G�J��,6�!�j�L"g8%�j�J"&�~m�Wh�+��b])6��ldck�f�Ǥr���$�-��-�*aO7����	Ut��\��
+M�i�OUv�=?I��(-�R��AR�e���k��M�\yQ�Y�p���=�J]z��<��=>"��s�,ث	&�'i0����r���}Q�f�^0��h���¤�ZLMb��K{������Z!\F�ӡ�늶�B�
_`-�������חTN�q�u�����Dڪ�ZK�Pٌ|�B������.O�$�O��vp,�U��Z����]��T�����;�0�X�4�L1e�0���=�5�5d,����1�eC�x���4�P�g�d�vKR�y���h��9�_6�Hw��2�ڊ15������BXU��(�{K�^�t��X�y{�Q��y�\P�A��E�$PlF���ӓ��8�n�T�,S�����4A�
y�����]���q�����W=����rI�b��k���\�Omu���S��˩��8�,V�7��K�N>��4(�����ul�|4���i��8蟁؅��Ò      �   �  x���JA��}�ao��[�s?�U���j�m���5��$�Z��Ĩ4&f}��7ꙙd܂��:m!ѝ��8�?s���X�oo�m�j��@�a�ç�����t�{ݮ�ֽ���#����S�[��^��^W]v;�~��.�z�����:��7��|��n�������Emgk��
ŔX$���$��!*'٩����˅�����!��L^e#y�B�ىg� p᱿��ԧ�n���Zm5�h�QU�n6���7�o����ת
�1NLLa����V�t��e����!�?@���+���Sϧ�p�[p�0�(��O ��X^f��޺�|ư���j�0Q�����`��%,�!|pc��`P����&*�%�Ȇ���#ñ�"DV�&jʯ�yv�7I�c�����}0�:��`����7頶�Yv	��$#.k�X-� �0�X�QV�[}s�zw�C�E�؊X9�D���8�S(��\@p����D.@� I@��DX�Pv�����L0���]�@p@�ҁ-

���,��g��=�[_HH@�/$ԐO �BQ�)<��C�2�u�>�f$(�F�"�BHad}���.�	փr��Q�n7�K�#�"(�H���zE�7���Y! =�k$��lz�4��;!�.���D�F1ʛ�\c�|Dɱ�����j�XAx@�wTM�{��wBo!bYÀ*�D�ige>�eVjY��*D��-��/���X��5��Y��;��9Vmt(3��YC�7k!r�&_��-�9��֪���-*oq�����r�ڍ���gM�ފ8�J�᠑᭨��9P 9C��O��'����㨰��,��46襰��]��U�&��i�q���9(0P`S��.����u��'�yb�?�<q��D���i�\���1y�<1��<N�N�|=�C���*�Bf      �   �  x����N�P��<Ť A���ĕQ�&�M�{[4!J � ��`�U*��@��0�F�s�Y�2m��\��|����T+'5���KV���]Z�V�ն(gyWV���׮_k�u^?o�k��u��m��������i�J��e��w�8��ҕ�tؗ������G�3�B���<&,����g����uh�u�����丵#�9����	\2�`�&���@?A��Y��	��'��XZ�e��c��C�@�~Q.L�FXtb��f��PP?�Q���<V֍9��8$��H=B!�NP�):h�Di屩��*��]5L�[J2P7���Xo2�>Bc�< 3
@��e���«|�o;��1�<���J,Xd�]��k}Z��D����ry.y>ѩ�zd�nlc�O�����$�;5�%�i
�GYkƑ<��f\:��8�!qhT��n�B�H��|�P�      �   �  x���n�F��~��.R #В\~��"M[�4N�%�*[�e��v�H���X��!��oԙ]r�U�-s)P`�+�~�����Cv�o^���:ݝm���v0�k�l���z�{�k5���&k����x��N����>��1����p�?Ƴ��pO}k4���ӓ����D�������xv����ǽ���c<��O�������[o_�a-o�5�s9M'r&�2� 䴉�g��&��_�R�� ���d�߆/�v�}����D^3�?Z��᭜�`��֖��l��^mw���a?l����ϝ�O�mt�G �j��(�0`3K� &��>�D��,6���>�e��.��f�30�Π"HOC��q5 ��%�a�>�� 
F����#N�(�*��� ��~+�;@��^�a)���L]��lCb�ZQm����3��w�0��9Ԉ��V���00�O�e�s� ��4��&Q4&���Ԟ�*Q�]�SQ�Ey�x5ք��G\����y#�Y��Bc�=���#p�/�PD�9�ȕ��t��	'�t觵��\��5S�pUԩ<� ���$�p}]���E�*N�
�֖T򋚰�rT�^KqRU�����y�\����"���8�*[_W�p���xन�ba ��B�J\} RC�2p��,��B�����T ��σs�y��M�W�(�#����o�$iO�~Ύ�8z�m�������+wŎR5��.v��l�K]�(v�����b6M��zH�2
eZ���E+�6̷-<r+^���6�4Ŏ�Id'\�"����bG�#���q�H�I�9��<G���$[,h􎢦G��9��lm懦F&Q�s
�[�̏L�LV��jqJX�L�*����\X
�O�� �O�s�Z-h�A�����y�P��3�vN���J�D}Ո$��YH�Ho�Iz!��O'/"���p��i5�;�^AD��E5�1I�Y�����.�j=�b�-�Q-�j�)�=K/V��!D�lD�i\o��9��EN΢�3���,����������s��������J��yoT��ɉ���D�?fj���"� �"��.�T?�라"$���ZGCݩBj�^b'J�x�CDdf�DkH(���]<���֤������S�=,l>���NEB֧M���R,��n�}k��������SꁨG�<�1S��(Ԑ�]jS�#�n �->{&�_��C�٨6���#�Q���}�^�Lv���R��|I�y�>=g�%+!��%�<�?�fI��ݤ�U��&+�����[��;Y����m���j��}l��;uRVR,�hS/}I?ʫ��?���bycB��)���by��R������j��R��oI=��׶T(���QW�d��W!NЍ�/���Y��P'V8�\V?P��z�M�٘N��� wm�3��d�����kk��)�6��V���|8E��W_���ϛY76�s��      �   �  x�՗�n�@��<�ʗM$�[=Ui�"!#5�׊�
�e��#?���Hy��B�_a��:^[b�B�
Tu����|��q�9=y�D5��@��?�r�ڑ��ח~���ͽЊH�ઓ�\tzm����c��>��v����,=�ms3�m}����V��i��݋���):���]�	|FpMؘ�t��@��N}��ݳ(�����-�=�l �1��-KP|s���A����"���.ޥ�9O�>x�|�)��Kw�������Ϋz���^6��h��9��j������>G��I���)�1��.���CJ����-�E9��2���JpȊ@P�i��,�N���	�"��%��K��(��J���%3�J���P	RY�1O��'�o�T�l�����zn%.�Ȗ�q@�����r�e~�:L�_U%~F�璆P�M�NR$x�b�d۟�(3��	�\rt�l�N͂/�x�*',C�e��R�J����s����'6<������V��/+eB����"�q o���I���J3:�Szy3'I��SU�T�}�"*��< ��xU@U
�,��TET��u�����/��(�i&�U�9�����f�l��&���g`�oe|���Ͼ� I�����}p*~yWʛ      �   �  x���N�@��y��oR\yw�>�W�m$�Hz[H�HTI��Г�B9�4�^a�F��Y;NL�(W�F��x!�c��&�����uV��7��uo�K{�y�t[[��m�-:�m�
�������n�[x��;��i���.�k�z�^���Ǜ��^�C:��f�������O����juce�-����*�O���].+U��*��мªo��.�F�-7�oVk���u����j��/jO"g��Å�x���@*����7�)��Ur����Z�c��E�����3}��������I�n�������9\�N�o���QI��XV��U&�?]��c��π�q��ݙ��(rRe�ĉ����#'�#��ȼ�yN�>x�&�n�s��lJv~�]Tt�@Yt��)Di�L�*���h \O�hwJ\Q����K�+d#ҕ�5ĘM"]�x�vg����|�cqŮ".�*���L��0�;�X���g�DPe@����Q���B�w��0�AE^������Z����3X2��j���1j��^�&G��$�r�ǣg�="��1���i�ZB�8~� �s�\ ���gGV
 ��bQ*P�G����+lOI,,�����<0i}������[cf����<o��C�	���.��K���� �1���w}e�+�����R@��Qd�|�+k�$՟��Ɛ2��808����̭S)*P�:L`�\X��B{�[L �ܗ�>���}Y�
i�1�_yh�����.7�5�T+��� b�����2g߉q]@�n�S��������//��c��<���*^<��jՂ�]�Y3K2�&�X3���$�.4�7�� p=�`Jl���5�p���N�r$j��k�I�:Z;�9�6������Ĥ���aBN���WS�!�4��� �a��U�O�G�rSn�N(ks���̽���X0:0�׍T�#鏭��̱	P��7z�u��`�U��Bma�/�x �      �   "  x�ݘOo�0���Q/ۤ��8�ƀJU+A�
+Pm�S[��8pA!@��	����}�a;���IW�e��,�#�����޼�~�ԛ�VP�ytg�w�v���?��j�J��Q�ڽ�`8���y�գ��3����'���h8��F��~w{CM������'�~����<�og�G��}�g�Ѡ3�j���K���7��rO�y����Sy��d�B?�4��'���7N�E1"��4A�j�5V�&
�C�U�z�f�����Z�y�Q_k�[A�վVo^��T��yM�O�Mw��{��;<3J��S��yj����'
�C����ke�y`��ˉ�.O�%f�^�c9���O������?����5����JQD�nl�撡���<k������q��&�('���L�f��a&�8I#2#!�e���X�B_��|cM東ϙ�?���TOf^�W_�]��Y��Äq��(J�[�V*�:aQ��lq�Ь�D��UѼ!R���E� �\��#�j�%h��Q^:P�8�\Z9̂r�%E*������I���О�WE�HUt��|�Q����'3��.�u���,ܯYH �П��@9������W��,�A����!� ���65lAϴs�4gRY�ƴ����.���asUA(��yE��a'�+�DFå��+J��bY� ~C�F�/����Il!D��xn���N5���x�R}{�UkODЄq/��NG8DM-j+Y���=yĕ�#�L1}iX��>����M{!?��z#��[�V$�)������tt>�P|�l������hY��8PU�	�=�F�,�m��1�1�#����S~R&�P��IY�=�=\��`SH��O�9W8�SB�e��?�1��8�����.,`G�ܦ8�Us���ήO���/�a�u&@���V�z��M��~O.��sK�*#6�ھ�E�j���9�ڜ���������$;q���Z�,0xu1�Jm�E�R+��,0(3��]c�0��X�{����9Rs2���~�3L     