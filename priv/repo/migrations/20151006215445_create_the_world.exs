defmodule BdRt.Repo.Migrations.CreateTheWorld do
  use Ecto.Migration

  def up do

  execute """
--
-- Name: agencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE agencies (
    id integer NOT NULL,
    remote_id character varying,
    name character varying,
    url character varying,
    fare_url character varying,
    timezone character varying,
    language character varying,
    phone character varying,
    gtfs_endpoint character varying,
    gtfs_trip_updates_url character varying,
    gtfs_vehicle_positions_url character varying(150),
    gtfs_service_alerts_url character varying(150)
);
"""

  execute """
--
-- Name: agencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE agencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: agencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE agencies_id_seq OWNED BY agencies.id;
"""

  execute """
--
-- Name: route_stops; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE route_stops (
    id integer NOT NULL,
    route_id integer NOT NULL,
    stop_id integer NOT NULL
);
"""

  execute """
--
-- Name: route_stops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE route_stops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: route_stops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE route_stops_id_seq OWNED BY route_stops.id;
"""

  execute """
--
-- Name: routes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE routes (
    id integer NOT NULL,
    remote_id character varying,
    short_name character varying,
    long_name character varying,
    description character varying,
    route_type character varying,
    url character varying,
    color character varying,
    text_color character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    agency_id integer
);
"""

  execute """
--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE routes_id_seq OWNED BY routes.id;
"""

  execute """
--
-- Name: services; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE services (
    id integer NOT NULL,
    agency_id integer,
    remote_id character varying,
    monday boolean DEFAULT false,
    tuesday boolean DEFAULT false,
    wednesday boolean DEFAULT false,
    thursday boolean DEFAULT false,
    friday boolean DEFAULT false,
    saturday boolean DEFAULT false,
    sunday boolean DEFAULT false,
    start_date date,
    end_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
"""

  execute """
--
-- Name: service_days; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW service_days AS
 SELECT sd.id,
    sd.agency_id,
    sd.remote_id,
    sd.start_date,
    sd.end_date,
    sd.dow
   FROM ( SELECT services.id,
            services.agency_id,
            services.remote_id,
            services.start_date,
            services.end_date,
            unnest(ARRAY['monday'::text, 'tuesday'::text, 'wednesday'::text, 'thursday'::text, 'friday'::text, 'saturday'::text, 'sunday'::text]) AS dow,
            unnest(ARRAY[services.monday, services.tuesday, services.wednesday, services.thursday, services.friday, services.saturday, services.sunday]) AS active
           FROM services) sd
  WHERE sd.active;
"""

  execute """
--
-- Name: service_exceptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_exceptions (
    id integer NOT NULL,
    agency_id integer,
    service_id integer,
    date date,
    exception integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
"""

  execute """
--
-- Name: service_exceptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_exceptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: service_exceptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE service_exceptions_id_seq OWNED BY service_exceptions.id;
"""

  execute """
--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE services_id_seq OWNED BY services.id;
"""

  execute """
--
-- Name: shape_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shape_points (
    id integer NOT NULL,
    shape_id integer,
    latitude double precision,
    longitude double precision,
    sequence integer,
    distance_traveled double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
"""

  execute """
--
-- Name: shape_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shape_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: shape_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shape_points_id_seq OWNED BY shape_points.id;
"""

  execute """
--
-- Name: shapes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shapes (
    id integer NOT NULL,
    remote_id character varying,
    agency_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
"""

  execute """
--
-- Name: shapes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shapes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: shapes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shapes_id_seq OWNED BY shapes.id;
"""

  execute """
--
-- Name: stop_times; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_times (
    id integer NOT NULL,
    stop_headsign character varying,
    pickup_type integer,
    drop_off_type integer,
    shape_dist_traveled double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    agency_id integer,
    stop_id integer,
    trip_id integer,
    arrival_time interval,
    departure_time interval,
    stop_sequence integer
);
"""

  execute """
--
-- Name: stop_times_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stop_times_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: stop_times_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stop_times_id_seq OWNED BY stop_times.id;
"""

  execute """
--
-- Name: stops; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stops (
    id integer NOT NULL,
    remote_id character varying,
    code integer,
    name character varying,
    description character varying,
    latitude double precision,
    longitude double precision,
    zone_id integer,
    url character varying,
    location_type integer,
    parent_station character varying,
    timezone character varying,
    wheelchair_boarding integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    agency_id integer
);
"""

  execute """
--
-- Name: stops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: stops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stops_id_seq OWNED BY stops.id;
"""

  execute """
--
-- Name: trips; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trips (
    id integer NOT NULL,
    remote_id character varying,
    service_id integer,
    headsign character varying,
    short_name character varying,
    direction_id integer,
    block_id integer,
    wheelchair_accessible integer,
    bikes_allowed integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    agency_id integer,
    route_id integer,
    shape_id integer
);
"""

  execute """
--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
"""

  execute """
--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trips_id_seq OWNED BY trips.id;
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY agencies ALTER COLUMN id SET DEFAULT nextval('agencies_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY route_stops ALTER COLUMN id SET DEFAULT nextval('route_stops_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY routes ALTER COLUMN id SET DEFAULT nextval('routes_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_exceptions ALTER COLUMN id SET DEFAULT nextval('service_exceptions_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY services ALTER COLUMN id SET DEFAULT nextval('services_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shape_points ALTER COLUMN id SET DEFAULT nextval('shape_points_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shapes ALTER COLUMN id SET DEFAULT nextval('shapes_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_times ALTER COLUMN id SET DEFAULT nextval('stop_times_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stops ALTER COLUMN id SET DEFAULT nextval('stops_id_seq'::regclass);
"""

  execute """
--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trips ALTER COLUMN id SET DEFAULT nextval('trips_id_seq'::regclass);
"""

  execute """
--
-- Name: agencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY agencies
    ADD CONSTRAINT agencies_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: route_stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY route_stops
    ADD CONSTRAINT route_stops_pkey PRIMARY KEY (id);
"""

  execute """

--
-- Name: routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: service_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_exceptions
    ADD CONSTRAINT service_exceptions_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: services_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: shape_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shape_points
    ADD CONSTRAINT shape_points_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: shapes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shapes
    ADD CONSTRAINT shapes_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: stop_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_times
    ADD CONSTRAINT stop_times_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stops
    ADD CONSTRAINT stops_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: trips_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);
"""

  execute """
--
-- Name: index_agencies_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_agencies_on_remote_id ON agencies USING btree (remote_id);
"""

  execute """
--
-- Name: index_route_stops_on_stop_id_and_route_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_route_stops_on_stop_id_and_route_id ON route_stops USING btree (stop_id, route_id);
"""

  execute """
--
-- Name: index_routes_on_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_routes_on_agency_id ON routes USING btree (agency_id);
"""

  execute """
--
-- Name: index_routes_on_remote_id_and_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_routes_on_remote_id_and_agency_id ON routes USING btree (remote_id, agency_id);
"""

  execute """
--
-- Name: index_services_on_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_services_on_agency_id ON services USING btree (agency_id);
"""

  execute """
--
-- Name: index_shape_points_on_shape_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shape_points_on_shape_id ON shape_points USING btree (shape_id);
"""

  execute """
--
-- Name: index_shapes_on_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shapes_on_agency_id ON shapes USING btree (agency_id);
"""

  execute """
--
-- Name: index_stop_times_on_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stop_times_on_agency_id ON stop_times USING btree (agency_id);
"""

  execute """
--
-- Name: index_stop_times_on_agency_id_and_stop_id_and_trip_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stop_times_on_agency_id_and_stop_id_and_trip_id ON stop_times USING btree (agency_id, stop_id, trip_id);
"""

  execute """
--
-- Name: index_stop_times_on_stop_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stop_times_on_stop_id ON stop_times USING btree (stop_id);
"""

  execute """
--
-- Name: index_stop_times_on_trip_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stop_times_on_trip_id ON stop_times USING btree (trip_id);
"""

  execute """
--
-- Name: index_stops_on_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stops_on_agency_id ON stops USING btree (agency_id);
"""

  execute """
--
-- Name: index_stops_on_remote_id_and_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stops_on_remote_id_and_agency_id ON stops USING btree (remote_id, agency_id);
"""

  execute """
--
-- Name: index_trips_on_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trips_on_agency_id ON trips USING btree (agency_id);
"""

  execute """
--
-- Name: index_trips_on_remote_id_and_agency_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trips_on_remote_id_and_agency_id ON trips USING btree (remote_id, agency_id);
"""

  execute """
--
-- Name: index_trips_on_route_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trips_on_route_id ON trips USING btree (route_id);
"""

  execute """
--
-- Name: index_trips_on_shape_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trips_on_shape_id ON trips USING btree (shape_id);
"""

  execute """
--
-- Name: fk_rails_01d91dfe5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_times
    ADD CONSTRAINT fk_rails_01d91dfe5b FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_105982e7f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT fk_rails_105982e7f8 FOREIGN KEY (service_id) REFERENCES services(id);
"""

  execute """
--
-- Name: fk_rails_141231e2f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stops
    ADD CONSTRAINT fk_rails_141231e2f2 FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_1d59619cdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT fk_rails_1d59619cdb FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_1f4cc828f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY route_stops
    ADD CONSTRAINT fk_rails_1f4cc828f8 FOREIGN KEY (route_id) REFERENCES routes(id);
"""

  execute """
--
-- Name: fk_rails_438d0a4a30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT fk_rails_438d0a4a30 FOREIGN KEY (shape_id) REFERENCES shapes(id);
"""

  execute """
--
-- Name: fk_rails_5fe09f577c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_exceptions
    ADD CONSTRAINT fk_rails_5fe09f577c FOREIGN KEY (service_id) REFERENCES services(id);
"""

  execute """
--
-- Name: fk_rails_7ac710f08a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_times
    ADD CONSTRAINT fk_rails_7ac710f08a FOREIGN KEY (stop_id) REFERENCES stops(id);
"""

  execute """
--
-- Name: fk_rails_9a39561dfd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT fk_rails_9a39561dfd FOREIGN KEY (route_id) REFERENCES routes(id);
"""

  execute """
--
-- Name: fk_rails_a62bf79bbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT fk_rails_a62bf79bbc FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_cc9fde6bb7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY route_stops
    ADD CONSTRAINT fk_rails_cc9fde6bb7 FOREIGN KEY (stop_id) REFERENCES stops(id);
"""

  execute """
--
-- Name: fk_rails_f0cd5d1f9f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY services
    ADD CONSTRAINT fk_rails_f0cd5d1f9f FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_f1872def08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shapes
    ADD CONSTRAINT fk_rails_f1872def08 FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_f4f3aa4b66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_exceptions
    ADD CONSTRAINT fk_rails_f4f3aa4b66 FOREIGN KEY (agency_id) REFERENCES agencies(id);
"""

  execute """
--
-- Name: fk_rails_f5df03eb13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_times
    ADD CONSTRAINT fk_rails_f5df03eb13 FOREIGN KEY (trip_id) REFERENCES trips(id);
"""

  execute """
--
-- Name: fk_rails_fd88275625; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shape_points
    ADD CONSTRAINT fk_rails_fd88275625 FOREIGN KEY (shape_id) REFERENCES shapes(id);
"""

    execute """
--
-- Name: effective_services(date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION effective_services(start_date date DEFAULT ('now'::text)::date, end_date date DEFAULT (('now'::text)::date + '1 day'::interval)) RETURNS TABLE(agency_id integer, service_id integer, date date, dow character)
    LANGUAGE sql
    AS $$
  SELECT agencies.id as agency_id, service_exceptions.service_id, d as date, rtrim(to_char(days.d, 'day')) as dow
     FROM agencies
       CROSS JOIN (SELECT d::date FROM generate_series(start_date, end_date, interval '1 day') d) days
       INNER JOIN service_days ON service_days.dow = rtrim(to_char(days.d, 'day')) AND agencies.id = service_days.agency_id
       INNER JOIN service_exceptions ON service_exceptions.date = days.d AND agencies.id = service_exceptions.agency_id
       WHERE service_exceptions.exception = 1
     UNION ALL
     SELECT agencies.id as agency_id, service_days.id, d as date, rtrim(to_char(days.d, 'day')) as dow
     FROM agencies
       CROSS JOIN (SELECT d::date FROM generate_series(start_date, end_date, interval '1 day') d) days
       INNER JOIN service_days ON service_days.dow = rtrim(to_char(days.d, 'day')) AND agencies.id = service_days.agency_id
       LEFT JOIN service_exceptions ON service_exceptions.date = days.d AND agencies.id = service_exceptions.agency_id AND service_days.id = service_exceptions.service_id
       WHERE service_exceptions IS NULL OR service_exceptions.exception != 2
$$;
"""

  execute """
--
-- Name: start_time(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION start_time(start_date date DEFAULT ('now'::text)::date) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
DECLARE
  noon varchar(50);
BEGIN
  SELECT INTO noon to_char(start_date, 'YYYY-mm-dd') || ' 12:00:00';
  RETURN noon::timestamp - interval '12 hours';
END;
$$;
"""

  end
end


