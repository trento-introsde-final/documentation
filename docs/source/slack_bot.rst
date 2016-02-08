Slack Bot
======================

A custom Slack integration was built using incoming and outgoing webhooks, which allows users to interact with the whole system through a Slack channel in their organization and custom commands. The supported commands are the following:

- **register**:

Creates new profile for the Slack user. This must be done before calling the other commands.

- **setgoal** [goal_type] [target] [period]:

Set a new goal. Goal type is one of "distance", "calories", or "moving_time". Target is the value in meters, kcal or seconds. Period is "daily", "weekly" or "monthly".

- **run** [distance] [time] [calories]:

Log a new run. Distance is in meters, time in seconds and calories in kcal.

- **goalstatus**:

Check the current status of a user's goals. How many he has achieved, and how much he is missing for the others.
