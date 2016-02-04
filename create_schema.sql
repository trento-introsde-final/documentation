DROP TABLE IF EXISTS PERSON CASCADE;
DROP TABLE IF EXISTS GOAL CASCADE;
DROP TABLE IF EXISTS GOAL_MEASURE_TYPE CASCADE;
DROP TABLE IF EXISTS GOAL_PERIOD CASCADE;
DROP TABLE IF EXISTS RUN_HISTORY CASCADE;
DROP SEQUENCE IF EXISTS person_id_seq;
DROP SEQUENCE IF EXISTS goal_id_seq;
DROP SEQUENCE IF EXISTS run_history_id_seq;

CREATE SEQUENCE person_id_seq;
CREATE SEQUENCE goal_id_seq;
CREATE SEQUENCE run_history_id_seq;

CREATE TABLE PERSON (
    id INT PRIMARY KEY NOT NULL DEFAULT nextval('person_id_seq'),
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    email VARCHAR(50),
    strava_access_token VARCHAR(80),
    strava_code VARCHAR(30),
    telegram_user_id INT,
    telegram_chat_id INT,
    slack_user_id VARCHAR(16)
);

CREATE TABLE GOAL (
    id INT PRIMARY KEY NOT NULL DEFAULT nextval('goal_id_seq'),
    person_id INT NOT NULL,
    target_value DECIMAL(10,2),
    creation_date TIMESTAMP,
    goal_measure_type VARCHAR(15),
    goal_period INT
); 

CREATE TABLE GOAL_MEASURE_TYPE(
    id VARCHAR(15) PRIMARY KEY,
    units VARCHAR(15),
    name VARCHAR(15) UNIQUE
);

CREATE TABLE GOAL_PERIOD(
    days_length INT PRIMARY KEY NOT NULL,
    name VARCHAR(20) UNIQUE
);

CREATE TABLE RUN_HISTORY(
    id INT PRIMARY KEY NOT NULL DEFAULT nextval('run_history_id_seq'),
    person_id INT NOT NULL,
    distance DECIMAL(12,4),
    calories DECIMAL(12,4),
    startdate TIMESTAMP,
    moving_time DECIMAL(12,4),
    elevation_gain DECIMAL(12,4),
    max_speed DECIMAL(8,4),
    avg_speed DECIMAL(8,4),
    steps INT
);


ALTER SEQUENCE person_id_seq OWNED BY PERSON.id;
ALTER SEQUENCE goal_id_seq OWNED BY GOAL.id;
ALTER SEQUENCE run_history_id_seq OWNED BY RUN_HISTORY.id;
ALTER TABLE GOAL ADD FOREIGN KEY(person_id) REFERENCES PERSON(id);
ALTER TABLE GOAL ADD FOREIGN KEY(goal_measure_type) REFERENCES GOAL_MEASURE_TYPE(id);
ALTER TABLE GOAL ADD FOREIGN KEY(goal_period) REFERENCES GOAL_PERIOD(days_length);
ALTER TABLE RUN_HISTORY ADD FOREIGN KEY(person_id) REFERENCES PERSON(id);