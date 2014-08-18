OpenBEL - Web Tools
==================

OpenBEL is an open source and open community project providing BEL (Biological Expression Language) and a set of tools to process/store biological knowledge. As BEL expressions may become very complex, our project aims to develop a web visualization tool for BEL graph to enhance user's comprehension and interaction, using HTML5 and Javascript libraries.

0. Setup
------------------
Environment
Ruby >= 2.1.2
Rails >= 4.1.4

After cloning this project follow these steps:
  - bundle install (installs all needed gems)
  - Configure config/database.yml
  - rake db:migrate (setup your database)
  - rails s (run server)
  - access localhost:3000 to see if everything is working
  - Enjoy!

1. Graph Structure
------------------

This project make use of JSON Graph Specification Project (http://json-graph-format.info/) to make BEL files graphs available for multi-purpose use.

2. Graph Plugins
----------------

  - Cytoscape.js (http://cytoscape.github.io/cytoscape.js/)
  - Cytoscape.js Navigator (https://github.com/cytoscape/cytoscape.js-navigator)
