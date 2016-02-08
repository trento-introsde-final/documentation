# FitBot - Slack Health Pal

This document describes the architecture and inner functioning of Fitbot, a
custom Slack integration that allows users to keep track of their running goals
and log their progress. It is developed as a part of the Introduction to Service
Design and Engineering course, taught at the University of Trento, First
semester 2015-2016.

Team members:
####  Damiano Fossa - [DamianFox](https://github.com/damianfox)
#### Daniel Bruzual - [djbb7](https://github.com/djbb7)

## Introduction

The project implements a custom Slack integration, called Fitbot, that
is added to a channel inside your organization. In there, every user
can interact with it to register into the system, set new goals, record
runs, and check goal status. The aim of the project is to motivate
users inside an organization to keep healthy by building sports and
workout habits. In this way, for every action the user takes he can
be rewarded with nice pictures from instagram, or interesting
motivational quotes, that are posted to the channel.

## Project Structure

The github organization [trento-introsde-final](https://github.com/trento-introsde-final) contains all the repositories relevant to the project, including documentation. The project is composed of several Web Services, and a readthedocs documentation page:

* [Adapter Services](https://github.com/trento-introsde-final/adapter-services) REST, Java.
* [Local Database Services](https://github.com/trento-introsde-final/local-database-services) REST, Java, Postgres.
* [Storage Services](https://github.com/trento-introsde-final/storage-services) REST, Java.
* [Business Logic Services](https://github.com/trento-introsde-final/business-logic-services) REST, Java.
* [Process Centric Services](https://github.com/trento-introsde-final/process-centric-services) SOAP, Java.
* [Slack Bot](https://github.com/trento-introsde-final/slack-bot) REST, PHP.
* [ReadTheDocs API Guide](http://trento-introsde-final.readthedocs.org/en/latest/)

All web services are ready to be deployed to Heroku using the appropriate [buildpack](https://github.com/IntroSDE/heroku-buildpack-ant).

# Architecture

The project follows a SOA that consists of several layers. Although in many cases a call is simply forwarded from one layer to the other, this type of design ensures modularity and extensibility. In particular the architectural design implemented is the following:

![Architecture Diagram](https://raw.githubusercontent.com/trento-introsde-final/documentation/master/images/architecture.png)

#### Slack Bot

Is in charge of receiving commands from Slack via outgoing webhooks, and responds accordingly via incoming webhooks. It communicates directly with Process Centric Services, via SOAP requests, and receives the sequences of messages it should present to the user. Slack Bot is in charge of the formatting.

*Technologies: PHP, REST endpoint for outgoing wekhooks, SOAP client for interacting with PCS.*

#### Process Centric Services

This is where complex operations, or integration logics, involving several web services take place. It implements the 4 methods available to the public via Slack Bot. Each one has a control flow that performs the instructed operation (e.g. log a new run), and additionally can check goals and reward the user.

As a course requirement, two of the methods implement 4 sequential calls to different web services: Update Run, and Check Goal Status.

*Technologies: Java, SOAP endpoint, and REST client for interacting with BLS and SS.*

#### Business Logic Services

This web service implements methods that are exposed to the public but don't involve a process logic. It is meant for simple operations (typically GET) that involve only reading certain information.

*Technologies: Java, REST endpoint and client.*

### Adapter Services

This web service is in charge of communication with external web services. In this case we are interacting via REST APIs with [Instagram](https://www.instagram.com/developer/) for pictures and [Forismatic](http://forismatic.com/en/) for motivational quotes. However, it can easily be extended to include more services.

*Technologies: Java, REST endpoint, REST client.*

#### Local Database Services

Is in charge of storing information locally, such as user profiles, goals, and run history. It allows reading and inserting into the database. At the moment no authentication or authorization control is implemented.

*Technologies: Java, REST endpoint, Postgres.*

##### Database Design

The database is implemented in Postgres according to this design:
![ER-Diagram](https://raw.githubusercontent.com/trento-introsde-final/documentation/master/images/ER_diagram.png)

Some key points are that:
* A __person__ is identified by a *slack_user_id* externally, but internally we use our own *id*.
* A __goal__ is seen as something that a user wants to achieve periodically, i.e. run 10km every week. The user can achieve the *target* this week, but next week the count will start from 0 again. Goals can be of any duration in days (this duration is the __period__).
* A __goal__ is of a certain __type__, e.g. distance, calories, moving time.
* A __goal__ is met when the sum of the __runs__ that fall within that __period__ are greater than the *target* for the _goal_.


# Use cases

The system has 4 major use cases, that together define the complete experience the user has in terms of setting and achieving his goals. This are methods implemented in the PCS layer, but involve communication with all the parts of the system.

### User Registration

The first step for any user is to register into our system, this is down by using the trigger word *register* in the Slack channel. This will create a profile for the user, or return an error if he is already registered.

![User Registration Sequence Diagram](https://raw.githubusercontent.com/trento-introsde-final/documentation/master/images/slack_user_register.png)

## Set a Goal

The user would then set a personal goal. A registered user can have a goal for any of the existing goal types. For example, he can have a daily calories goal, a weekly distance goal, and a monthly moving time goal; but not a daily and a weekly distance goal.

![Set a goal Sequence Diagram](https://raw.githubusercontent.com/trento-introsde-final/documentation/master/images/slack_set_goal.png)

## Update Runs

The user registers the run information manually into the system. As it is, the system is based on trust. Once done, the system checks if with this run, the user meets any of his goals, and either rewards him or motivates him, depending on the case.

![Log a run Sequence Diagram](https://raw.githubusercontent.com/trento-introsde-final/documentation/master/images/slack_update_run.png)

## Check Goal Status

The user can check his goal status whenever he wants. That is, which goals he has accomplished this period, and how much he is missing for remaining ones. The system can reward him with beautiful pics or motivate him with powerful quotes depending on the case.

![Check goal status Sequence Diagram](https://raw.githubusercontent.com/trento-introsde-final/documentation/master/images/slack_check_goal_status.png)
