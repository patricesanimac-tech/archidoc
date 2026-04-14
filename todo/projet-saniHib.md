SaniHub



Par Patrice Bélisle

3

Ajoutez une réaction
Contexte
Dans le cadre de l’amélioration de notre architecture d’intégration et afin de mieux maîtriser les échanges entre nos différentes applications (Infor M3, TrueCommerce, Dynamics 365, Ortems et BBX),  Nous pourrions travailler sur une proposition visant à centraliser et structurer nos flux de données.

Nous pourrions créer ou officialiser un middleware SaniHub

Ce nom reflète son rôle central dans la gestion, la synchronisation et la fiabilité de nos échanges inter applicatifs, tout en s’alignant avec l’identité de Sani Marc.

Proposition
1. Contexte
Aujourd’hui, nos applications (Infor M3, TrueCommerce, Dynamics 365, Ortems, BBX) parlent entre elles via une base de transition MariaDB et des échanges directs.
Résultat : flux difficiles à suivre, peu de traçabilité, intégrations fragiles.

Nous voulons créer une couche d’intégration (middleware) qui :

Centralise les échanges entre les applications

Gère les transformations de données

Assure la traçabilité et la gestion des erreurs

Donne une vue claire des flux (qui envoie quoi, à qui, quand)

2. Explication
C’est quoi ce middleware dans ce contexte ?

2.1. Problème actuel
Intégrations de type point-à-point (ou via une base de transition)

Logique dispersée : un bout dans infor M3, un bout dans BBX, un bout dans des scripts…

Difficile de répondre à des questions simples comme :

« Où est passé tel bon de commande ? »   Avoir avec PAUL

« Est-ce que Ortems a bien reçu …. ? » Avoir avec PAUL

« Pourquoi telle commande n’est pas rendue dans Dynamics ? »Avoir avec PAUL

2.2. Vision cible : une couche “bus d’intégration”
Nous voulons ajouter une application centrale d’intégration entre toutes les autres :

Chaque application ne parle plus directement aux autres.

Chacune parle au middleware, qui joue les rôles suivants :

Connecteurs / Adaptateurs

Un connecteur pour chaque système :

Infor M3

TrueCommerce (EDI, B2B)

Dynamics 365

Ortems

BBX (app maison VB)

Ces connecteurs savent lire/écrire dans chaque application, ou via leurs API/fichiers/bases.

Modèle de données “canonique”

Définir des objets communs comme :

CommandeClient

CommandeAchat

OrdreDeProduction

Planification

Expédition / Livraison

Le middleware traduit :

Du format application → format canonique

Du format canonique → format de la cible

Orchestration & Routage

Définir les flux :

Ex : “Quand une commande client est créée dans Dynamics, je la publie sur le bus, puis M3 la reçoit, puis Ortems reçoit le plan de prod, puis TrueCommerce envoie les avis d’expédition, etc.”

Le middleware sait qui doit recevoir quoi.

Traçabilité & Journalisation

Chaque message a un ID de corrélation (ex : ID de commande).

Consulter un tableau de bord : “Montre-moi tous les événements pour la commande 12345”.

Gestion des erreurs

Si Ortems est indisponible → message mis en file d’attente / en échec contrôlé.

On peut re-lancer un message après correction.

Sécurité et contrôle des accès

Qui peut envoyer quoi, sur quel flux.

Gestion des identités (ou au moins des comptes de service).

 

 

Planification 
Voici une suggestion de roadmap pour la réation des document d’architecture

Méthodologie TOGAF

Architectures Applicative & Données (Phases C), mais en gardant le fil de l’ADM :

Phase A – Vision d’architecture
Objectif business :

Maîtriser et sécuriser les flux inter-applicatifs

Réduire les intégrations fragiles / spécifiques

Améliorer la traçabilité et la fiabilité des données

KPIs possibles :

% de flux traçables de bout en bout

Temps moyen de résolution d’incident d’intégration

Réduction du nombre d’interfaces point-à-point

Phase B – Architecture métier
Identifier les processus impactés :

Order-to-Cash

Procure-to-Pay

Plan-to-Produce

Gestion des stocks / entrepôts

Lier chaque processus aux applications impliquées.

Phase C – Architecture des données
Cartographier les objets métier et flux de données :

Qui est “maître” de la commande client ? (Dynamics ? M3 ?)

D’où viennent les données de stock ?

Quelles données transitent par MariaDB ?

Définir le modèle de données canonique pour les principaux objets.

Phase C – Architecture applicative
Définir le middleware comme un ABB (Architecture Building Block) :

Rôle : “Plateforme d’intégration applicative”

Fonctions : transformation, routage, orchestration, journalisation

Définir les interfaces :

Interface entre M3 et middleware

Interface entre TrueCommerce et middleware

etc.

Phase D – Architecture technologique
Décider comment tu implémentes ce middleware :

Plateforme ESB / iPaaS ?

Solution maison (ex : microservices + message broker + API gateway) ?

On-prem / cloud ?

Gap Analysis & Roadmap
As-is : flux via MariaDB + intégrations ad hoc.

To-be : middleware central + flux documentés et tracés.

Planifier par lot :

Lot 1 : Flux commandes clients (Dynamics ↔ M3 ↔ Ortems)

Lot 2 : Flux EDI via TrueCommerce

Lot 3 : Remplacement des usages de MariaDB de transition

Exemple
L’importance de SaniHub 

 

Prenons un scénario : création d’une commande client.

Aujourd’hui (simplifié)
La commande est saisie dans ….

Un job / script / processus envoie les données vers MariaDB.

Une autre tâche lit MariaDB, pousse vers M3.

Ortems reçoit les infos de M3 d’une certaine façon (fichiers, interface, etc.).

TrueCommerce envoie les confirmations ou avis d’expédition.

Si un maillon casse → on perds le fil.

Demain avec middleware (SaniHub)
La commande est créée dans Dynamics 365.

Le connecteur Dynamics envoie un message CommandeClientCréée au middleware (format Dynamics).

Le middleware :

Convertit en CommandeClient (format canonique).

Journalise l’événement (trace, ID).

Route vers :

M3 (pour la gestion ERP)

Ortems (pour la planification)

Les connecteurs M3 et Ortems reçoivent chacun le message, le traduisent dans leur format propre.

Paul B. 2026-01-27: J’aurais pensé que c’est a SaniHub de convertir au format du système de destination.

Quand M3 valide la commande / la livraison :

M3 envoie un événement ExpéditionPréparée.

Le middleware route vers TrueCommerce pour les échanges B2B.

À tout moment, on peut suivre : “Commande 12345 → reçue → envoyée à M3 → envoyée à Ortems → statut d’expédition → EDI envoyé”.