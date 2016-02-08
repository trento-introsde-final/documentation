.. |br| raw:: html

   <br />


Web Services
=============

Process Centric Services (SOAP)
--------------------------------

**initializeUser**
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	Given a slack user id, and his username creates a new user in the system.
	Returns the id of the newly created user.

	**Parameters**:

	====================   =====================================
	**slack_user_id**      **string** |br|
	                       Slack Identifier
	**username**           **string** |br|
	                       Nickname to personalise messages
	====================   =====================================

	**Output**:

	====================   ========================================
	**id**                 **integer** |br|
	                       id that identifies the new user in the
	                       system.
	====================   ========================================

**checkGoalStatus**
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	Checks the goals status for a given slack user, identified by a slack_user_id.
	The user must be previously registered.
	The goal status tells how many goals he has met and how much he is missing for
	the others. The system will reward him with pictures, or motivate him with quotes.

	**Parameters**:

	====================   =====================================
	**slack_user_id**      **string** |br|
	                       Slack Identifier
	====================   =====================================

	**Output**:

	====================   ========================================
	**goalStatusList**     Object containing a description of each
	                       goal, how much has been achieved, and
	                       until when the user has chance to
	                       accomplish it.
	**messages**           List of messages that should be
	                       displayed by the user interface.
	====================   ========================================

**updateRunInfo**
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	Registers a new run. The user must provide distance, time, calories. Checks if any new goals were met with the run.

	**Parameters**:

	====================   =====================================
	**slack_user_id**      **string** |br|
	                       Slack Identifier
	**distance**           **number** |br|
	                       meters
	**moving_time**        **number** |br|
	                       seconds
	**calories**           **number** |br|
	                       kcal
	====================   =====================================

	**Output**:

	====================   ========================================
	**messages**           List of messages that should be
	                       displayed by the user interface.
	                       Includes message in case a goal was met
	                       with the new run.
	====================   ========================================


**setGoal** {Params: Goal type, target, period}
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	Creates a new personal goal.

	**Parameters**:

	====================   =====================================
	**slack_user_id**      **string** |br|
	                       Slack Identifier
	**goal-type**          **string** |br|
	                       distance, time, or calories
	**target**             **number** |br|
	                       target value
	**period**             **number** |br|
	                       daily, weekly, monthly
	====================   =====================================

	**Output**:

	====================   ========================================
	**messages**           Messages notifying the creation of the
	                       goal.
	====================   ========================================



Business Logic Services (REST)
-------------------------------

**GET** ``/goal-types``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Gets all the valid goal types.

	No input

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**resuts**             **Array** of `Goal Type` |br|
						   Each string is a goal type.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	GoalType object:

	====================   ===============================================================
	**id**                 **string** |br| Goal type name
	**name**               **string** |br| Goal pretty name (e.g. 'distance', 'calories').
	**units**              **string** |br| (e.g. 'meters', 'kcal').
	====================   ===============================================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"results": [
				{
					"id": "distance",
					"name": "Distance",
					"units" "m"
				},
				{	"id": "calories",
					"name": "Calories",
					"units": "kcal"
				},
				{
					"id": "max_speed",
					"name": "Maximum speed",
					"units": "m/s"
				}
			]
		}

**GET** ``/goal-types/<goal-type>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Gets the definition of a specific goal type.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**id**                 **string**
	**name**               **string**
	**units**              **string**
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"id": "max_speed",
			"name": "Maximum Speed",
			"units": "km/h"
		}

**GET** ``/user-id/<slack-id>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Given a user's slack id, returns the corresponding user id.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**id**                 **integer**
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"id": 5
		}


**GET** ``/users/<user-id>/goal-status``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Returns the status for all the user's goals in the current period.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**goal_status**         **Array of `GoalStatus`**
	====================   =====================================

	GoalStatus object:

	====================   ==========================================
	**type**               **string** |br| Goal id
	**name**               **string** |br| Goal name
	                       (e.g. Distance, Max. Speed)
	**units**              **string**
	**target**             **float** |br| The ammount the user
	                       wants to achieve in total.
	**period**             **string**
	                       e.g. daily, weekly
	**period_start**        **integer** |br| UNIX timestamp millisec.
	**period_end**          **integer** |br| UNIX timestamp millisec.
	**goal_met**            **boolean**
	**count**              **float** |br|
	                       How much user already accumulated for
	                       goal.
	====================   ==========================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"goal_status": [
				{
					"type": "distance",
					"name": "Distance",
					"units": "m",
					"target": 5000.00,
					"period": "weekly",
					"period_start": 1452941107,
					"period_end": 1453545907,
					"goal_met": false,
					"count": 3500.00
				}
			]
		}


**POST** ``/users``
^^^^^^^^^^^^^^^^^^^^

	Creates a new user

	HTTP Status code: 200, 404 (Code not found)

	**Parameters**

	====================   ===============================================================
	**slack_user_id**      **string** |br|
	====================   ===============================================================


	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}


**PUT** ``/users/<user_id>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    	Performs a partial update on the user's fields. Either his profile data,
    	or his slack identifiers. Only the passed fields are updated. The user
    	identified by <user_id> must already exist.

    	**Parameters**:

    	========================   =====================================
    	**slack_user_id**          **string**
    	**email**                  **string**
    	**firstname**              **string**
    	**lastname**               **string**
    	========================   =====================================

      **Output**:

      ====================   =====================================
      **status**             **string** |br|
                             ERROR if there was a problem.
                             |br| OK otherwise.
      **error**              **string** |br|
                             Message describing encountered
                             errors.
      ====================   =====================================

      **Sample output**:

      .. code-block:: json

        {
          "status": "OK"
        }



Storage Services (REST)
------------------------

**GET** ``/goal-types``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**results**            **Array of GoalType**
	====================   =====================================

	GoalType object:

	====================   ===============================================================
	**id**                 **string** |br| Goal type name
	**name**               **string** |br| Goal pretty name (e.g. 'distance', 'calories').
	**units**              **string** |br| (e.g. 'meters', 'kcal').
	====================   ===============================================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"results": [
				{
					"id": "distance",
					"name": "Distance",
					"units" "m"
				},
				{	"id": "calories",
					"name": "Calories",
					"units": "kcal"
				},
				{
					"id": "max_speed",
					"name": "Maximum speed",
					"units": "m/s"
				}
			]
		}


**GET** ``/goal-types/<goal-type>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Gets the definition of a specific goal type.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**id**                 **string**
	**name**               **string**
	**units**              **string**
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"id": "max_speed",
			"name": "Maximum Speed",
			"units": "km/h"
		}

**POST** ``/users``
^^^^^^^^^^^^^^^^^^^^

    Creates a new user in the database

    **Parameters**:

    ========================   =====================================
    **slack_user_id**	       **string** |br| Generated by Slack.
    ========================   =====================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}

**PUT** ``/users/<user_id>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    	Performs a partial update on the user's fields. Either his profile data,
    	or his slack identifiers. Only the passed fields are updated. The user
    	identified by <user_id> must already exist.

    	**Parameters**:

    	========================   =====================================
    	**slack_user_id**          **string**
    	**email**                  **string**
    	**firstname**              **string**
    	**lastname**               **string**
    	========================   =====================================

      **Output**:

      ====================   =====================================
      **status**             **string** |br|
                             ERROR if there was a problem.
                             |br| OK otherwise.
      **error**              **string** |br|
                             Message describing encountered
                             errors.
      ====================   =====================================

      **Sample output**:

      .. code-block:: json

        {
          "status": "OK"
        }



**GET** ``/user-id/<slack-id>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Given a user's slack id, returns the corresponding user id.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**id**                 **integer**
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"id": 5
		}

**GET** ``/users/<user-id>/runs?start_date=<date>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Gets all the recent runs for the specified user.

	**Query Parameters**:

	====================   ================================================
	**start_date**         **integer** |br| UNIX timestamp in milliseconds.
	====================   ================================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**runs**               **Array** of `Run`
	====================   =====================================

	Run object:

	====================   ============================================
	**id**                 **integer**
	**distance**           **float** |br| meters
	**calories**           **float** |br| kilocalories
	**start_date**         **time string**
	**moving_time**        **integer** |br| seconds
	**elevation_gain**     **float** |br| meters
	**max_speed**          **float** |br| meters per second
	**avg_speed**          **float** |br| meters per second
	====================   ============================================


	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"runs": [
				{
					"id": 2,
					"distance": 5000,
					"calories": 3000,
					"start_date": 1454512708,
					"moving_time": 1800,
					"elevation_gain": 200,
					"max_speed": 3,
					"avg_speed": 2.5
				},
				...
			]
		}

**POST** ``/users/<user-id>/runs``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Calls Local Database Services to saves the passed run information.

	**Parameters**:

	====================   ============================================
	**distance**           **float** |br| meters
	**calories**           **float** |br| kilocalories
	**start_date**         **time string**
	**moving_time**        **integer** |br| seconds
	**elevation_gain**     **float** |br| meters
	**max_speed**          **float** |br| meters per second
	**avg_speed**          **float** |br| meters per second
	====================   ============================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample input**:

	.. code-block:: json

		{
			"distance": 5000,
			"calories": 3000,
			"start_date": 1454512708,
			"moving_time": 1800,
			"elevation_gain": 200,
			"max_speed": 3,
			"avg_speed": 2.5
		}

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}

**GET** ``/users/<user-id>/goals``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Connects to LocalDatabaseService and gets all the goals for the user.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**goals**              **Array** of `Goal`
	====================   =====================================

	Goal object:

	====================   ===================================================
	**id**                 **integer**
	**created**            **integer** |br| UNIX epoch timestamp in millisec.
	**target**             **float** |br| Target goal value.
	**period_days**        **integer** |br| How long does the period measure.
	**period**             **string** |br| (e.g. 'weekly', 'daily', 'monthly')
	**measure_type**       **float** |br| meters
	**units**              **float** |br| meters per second
	====================   ===================================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"goals": [
				{
					"id": 2,
					"created": 1454512708,
					"target": 5000.00,
					"measure_type": "distance",
					"name": "Distance",
					"units": "m",
					"period": "weekly",
					"period_days": 7
				},
				...
			]
		}

**PUT** ``/users/<user-id>/goals/<goal-type>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sets a goal of the specified type for the specified user.

	**Parameters**:

	====================   ===================================================
	**target**             **float** |br| Target goal value.
	**period**             **string** |br| (e.g. 'weekly', 'daily', 'monthly')
	====================   ===================================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample input**:

	.. code-block:: json

		{
			"target": 2000,
			"period": "daily"
		}

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}

**GET** ``/pretty-pic``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Connects to the adapterServices and returns 1 picture url.

	**Parameters**:

	====================   ============================================
	**tag**                **string** |br| Instagram tag to search for.
	====================   ============================================

	**Output**:

	====================   =================================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**picture**            **Object** |br|
	                       Picture with its url and thumbnail url
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**picture.url**        **string** |br| path to image.
	**picture.thumbUrl**   **string** |br| path to thumbnail.
	====================   =================================================

	**Sample input**:

	.. code-block:: json

		{
			"tag": "tagName"
		}

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"picture":
				{
					"url": "http://instagram.com/.../12dsfzH.jpg",
					"thumbUrl": "http://instagram.com/.../12dsfzH.jpg"
				}
		}

**GET** ``/motivation-quote``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Connects to the adapterServices and returns 1 motivation quote.

	No input

	**Output**:

	========================   =====================================
	**status**                 **string** |br|
	                           ERROR if there was a problem.
	                           |br| OK otherwise.
	**resut**                  **Object**
	**error**                  **string** |br|
	                           Message describing encountered
	                           errors.
	**result.quote**           **string** |br| Authentication token
	**result.author**          **Object** |br| User profile
	========================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"result":
			{
				"quote":"There is time for everything, except for losing time.",
				"author":"Anonymous"
			}
		}



Local Database Services (REST)
-------------------------------

**POST** ``/users``
^^^^^^^^^^^^^^^^^^^^

    Creates a new user in the database

    **Parameters**:

    ========================   =====================================
    **slack_user_id**	       **string** |br| Generated by Slack.
    ========================   =====================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}


**PUT** ``/users/<user_id>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	Performs a partial update on the user's fields. Either his profile data,
	or his slack identifiers. Only the passed fields are updated. The user
	identified by <user_id> must already exist.

	**Parameters**:

	========================   =====================================
	**slack_user_id**          **string**
	**email**                  **string**
	**firstname**              **string**
	**lastname**               **string**
	========================   =====================================

  **Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}



**GET** ``/goal-types``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**results**            **Array of GoalType**
	====================   =====================================

	GoalType object:

	====================   ===============================================================
	**id**                 **string** |br| Goal type name
	**name**               **string** |br| Goal pretty name (e.g. 'distance', 'calories').
	**units**              **string** |br| (e.g. 'meters', 'kcal').
	====================   ===============================================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"results": [
				{
					"id": "distance",
					"name": "Distance",
					"units" "m"
				},
				{	"id": "calories",
					"name": "Calories",
					"units": "kcal"
				},
				{
					"id": "max_speed",
					"name": "Maximum speed",
					"units": "m/s"
				}
			]
		}


**GET** ``/goal-types/<goal-type>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Gets the definition of a specific goal type.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**id**                 **string**
	**name**               **string**
	**units**              **string**
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"id": "max_speed",
			"name": "Maximum Speed",
			"units": "km/h"
		}

**GET** ``/user-id/<slack-id>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Given the slack identifier of the user, returns the corresponding id used by
this system to identify the user.

 	No input.

 	**Output**:

 	====================   =====================================
	**id**                 **integer**
	====================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"id": 5
		}


**PUT** ``/users/<user-id>/goals/<goal-type>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sets a goal of the specified type for the specified user.

	**Parameters**:

	====================   ===================================================
	**target**             **float** |br| Target goal value.
	**period**             **string** |br| (e.g. 'weekly', 'daily', 'monthly')
	====================   ===================================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample input**:

	.. code-block:: json

		{
			"target": 2000,
			"period": "daily"
		}

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}


**GET** ``/users/<user-id>/goals``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Gets all the goals for the specified user.

	No input.

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**goals**              **Array** of `Goal`
	====================   =====================================

	Goal object:

	====================   ===================================================
	**id**                 **integer**
	**created**            **integer** |br| UNIX epoch timestamp in millisec.
	**target**             **float** |br| Target goal value.
	**period_days**        **integer** |br| How long does the period measure.
	**period**             **string** |br| (e.g. 'weekly', 'daily', 'monthly')
	**measure_type**       **float** |br| meters
	**units**              **float** |br| meters per second
	====================   ===================================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"goals": [
				{
					"id": 2,
					"created": 1454512708,
					"target": 5000.00,
					"measure_type": "distance",
					"name": "Distance",
					"units": "m",
					"period": "weekly",
					"period_days": 7
				},
				...
			]
		}

**GET** ``/users/<user-id>/runs?start_date=<date>``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Gets all the recent runs for the specified user.

	**Query Parameters**:

	====================   ============================================
	**start_date**         **integer** |br| UNIX timestamp in millisec.
	====================   ============================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**runs**               **Array** of `Run`
	====================   =====================================

	Run object:

	====================   ============================================
	**id**                 **integer**
	**distance**           **float** |br| meters
	**calories**           **float** |br| kilocalories
	**start_date**         **long** |br| Timestamp in millisec.
	**moving_time**        **integer** |br| seconds
	**elevation_gain**     **float** |br| meters
	**max_speed**          **float** |br| meters per second
	**avg_speed**          **float** |br| meters per second
	====================   ============================================


	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"runs": [
				{
					"id": 2,
					"distance": 5000,
					"calories": 3000,
					"start_date": 1454512708,
					"moving_time": 1800,
					"elevation_gain": 200,
					"max_speed": 3,
					"avg_speed": 2.5
				},
				...
			]
		}

**POST** ``/users/<user-id>/runs``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Saves the passed run information in the RUN_HISTORY table.

	**Parameters**:

	====================   ============================================
	**distance**           **float** |br| meters
	**calories**           **float** |br| kilocalories
	**start_date**         **time string**
	**moving_time**        **integer** |br| seconds
	**elevation_gain**     **float** |br| meters
	**max_speed**          **float** |br| meters per second
	**avg_speed**          **float** |br| meters per second
	====================   ============================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	====================   =====================================

	**Sample input**:

	.. code-block:: json

		{
			"distance": 5000,
			"calories": 3000,
			"start_date": 1454512708,
			"moving_time": 1800,
			"elevation_gain": 200,
			"max_speed": 3,
			"avg_speed": 2.5
		}

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK"
		}

Adapter Services (REST)
------------------------

**GET** ``/instagram-pics``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Connects to instagram and gets latest pics that match a tag name.

	**Parameters**:

	====================   ============================================
	**tag**                **string** |br| Instagram tag to search for.
	**limit**              **integer** `optional` |br| Max
	                       images to
	                       retrieve. Default is 5.
	====================   ============================================

	**Output**:

	====================   =====================================
	**status**             **string** |br|
	                       ERROR if there was a problem.
	                       |br| OK otherwise.
	**resuts**             **Array** of `Images`
	**error**              **string** |br|
	                       Message describing encountered
	                       errors.
	**results.url**        **string** |br| path to image.
	**results.thumbUrl**   **string** |br| path to thumbnail.
	====================   =====================================

	**Sample input**:

	.. code-block:: json

		{
			"tag": "tagName",
			"limit": 5
		}

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"resultCount": 5,
			"results": [
				{
					"url": "http://instagram.com/.../12dsfzH.jpg",
					"thumbUrl": "http://instagram.com/.../12dsfzH.jpg"
				},
				...
			]
		}

**GET** ``/motivation-quote``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Gets a random inspirational quote.

	No input

	**Output**:

	========================   =====================================
	**status**                 **string** |br|
	                           ERROR if there was a problem.
	                           |br| OK otherwise.
	**resut**                  **Object**
	**error**                  **string** |br|
	                           Message describing encountered
	                           errors.
	**result.access_token**    **string** |br| Authentication token
	**result.athlete**         **Object** |br| User profile
	========================   =====================================

	**Sample output**:

	.. code-block:: json

		{
			"status": "OK",
			"result":
			{
				"quote":"There is time for everything, except for losing time.",
				"author":"Anonymous"
			}
		}
