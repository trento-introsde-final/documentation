INSERT INTO PERSON (id, firstname, lastname, email, slack_user_id)
VALUES  (1, 'Daniel', 'Bruzual', 'danielbruzual@gmail.com', 'U43F341'), 
        (3, 'Damiano', 'Fossa', 'damianofossa@gmail.com', 'UB23312'), 
        (5, 'Ruslano', 'Pallinco', 'ruslano.pallinco@gmail.com', 'UA22049');
SELECT setval('person_id_seq', 6, true);

INSERT INTO GOAL_PERIOD (days_length, name)
VALUES  (1, 'daily'), 
        (7, 'weekly'), 
        (30, 'monthly');

INSERT INTO GOAL_MEASURE_TYPE (id, units, name)
VALUES  ('distance', 'meters','distance ran'),
        ('run_time', 'minutes','time moving'),
        ('calories', 'calories','calories burnt'),
        ('steps', 'steps', 'steps walked');

INSERT INTO GOAL (person_id, target_value, goal_measure_type, goal_period)
VALUES  (1,  2000, 'distance', 1),
        (1,  10000, 'steps', 1),
        (3,  50000, 'steps', 7);

INSERT INTO RUN_HISTORY (person_id, distance, steps)
VALUES  (1, 1500, 6000),
        (1, 1000, 2000);
