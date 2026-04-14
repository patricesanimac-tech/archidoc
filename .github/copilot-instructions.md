# Domaine d'Affaire de Sani Marc

Sani Marc est une entreprise canadienne spécialisée dans les solutions d'hygiène, de désinfection et d'assainissement, accompagnant les organisations depuis plus de 50 ans pour atteindre l'excellence dans ces domaines. Leur mission est de transformer les défis quotidiens d'hygiène en opportunités d'efficacité, de sécurité et de confiance, en offrant des solutions durables et personnalisées qui améliorent les normes, renforcent les performances et inspirent la tranquillité d'esprit.

## Services Offerts

- Contrôle des infections
- Assainissement des usines agroalimentaires
- Traitement de l'eau des piscines et des spas
- Hygiène des mains
- Lavage de la vaisselle et buanderie commerciale
- Entretien des bâtiments
- Programme de maintenance préventive et réparations d'équipements
- Solutions pour les hôpitaux et centres de soins de santé
- Solutions pour l'agroalimentaire
- Solutions pour les pisciniers professionnels
- Solutions pour la restauration et l'hôtellerie
- Solutions pour les résidences pour aînés et centres de soins de longue durée
- Solutions commerciales et institutionnelles

## Structure du Référentiel

### Organisation par service métier

Créez une structure de dossiers dans `docs/` correspondant à chaque service d'affaires offert par Sani Marc. Organisez les documents Markdown comme suit :

```
docs/
├── Contrôle-des-infections/
├── Assainissement-agroalimentaire/
├── Traitement-eau-piscines-spas/
├── Hygiène-des-mains/
├── Lavage-vaisselle-buanderie/
├── Entretien-bâtiments/
├── Maintenance-équipements/
├── Hôpitaux-soins-santé/
├── Solutions-restauration-hôtellerie/
├── Solutions-résidences-aînés/
└── Solutions-secteur-commercial/
```

### Organisation transversale

En plus des dossiers par service métier, créez un dossier `Infrastructure/` pour les pipelines, solutions techniques et documentations transversales qui supportent plusieurs services ou toute l'organisation :

```
docs/
└── Infrastructure/
    ├── Data-Integration/
    │   └── PL_IntgrID_Account_M3ToD365_Databricks_Inner.md
    ├── Azure-Pipelines/
    ├── Security/
    └── Architecture/
```

### Principes d'organisation

- **Services métier** : Documentation spécifique à un service (procédures, guides, standards)
- **Infrastructure** : Pipelines ADF, intégrations de données, architecture technique, solutions transversales
- **Accessibilité** : Placez les documents Markdown dans les dossiers correspondants pour une meilleure organisation et accessibilité
- **Clarté** : Utilisez des noms de dossiers explicites en minuscules avec traits d'union (ex: `Contrôle-des-infections`)

