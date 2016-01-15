
 .. fitbot documentation master file, created by
   sphinx-quickstart on Mon Dec 28 09:07:23 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. _index-page:

IntroSDE 2015-16 Final Project Documentation
=============================================

This is the documentation for the final project corresponding to the lecture *Service Design and Engineering*  taught at the **University of Trento, winter semester 2015-16**. In summary, the scope of this project is to develop several web services, which interact between themselves, each corresponding to a different layer of the system architecture. The context is a system that allows the user to mantain a healthy lifestyle, and to remain motivated (by means of rewards and goals). The full project requirements and description can be found in the `course website <https://sites.google.com/a/unitn.it/introsde_2015-16/lab-sessions/assignments>`_.

This project was developed using Java, JAX-WS, and Jersey. Each web service was deployed to heroku, on a different server. 

For the client interaction a bot for Telegram was developed.

All the project documentation, and code can be found as a GitHub organization (check `https://github.com/trento-introsde-final <https://github.com/trento-introsde-final>`_).

.. toctree::
   :caption: Table of Contents:
   :maxdepth: 2

   architecture
   web_services
   telegram_bot