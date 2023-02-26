Reproduction repository for discussion in https://prisma-company.slack.com/archives/CGMCB82N8/p1677351488769649

# Problem

`migrate dev` detects drift, but `migrate diff` is all happy

# How to reproduce

1. `docker compose up`
2. `docker ps`, note ID of running container, e.g. `9c8c9839b64d`
3. `docker exec -i 9c8c9839b64d mysql -uroot -proot api < dump.sql` (replace ID with actual one)
4. `migrate dev --create-only` (should detect drift)
5. Any of the `migrate diff` commands will not detect a difference:
    - `npx prisma migrate diff --from-migrations ./prisma/migrations --to-schema-datasource ./prisma/schema.prisma --shadow-database-url mysql://root:root@localhost:3306/shadow`
    - `npx prisma migrate diff --from-migrations ./prisma/migrations --to-schema-datamodel ./prisma/schema.prisma --shadow-database-url mysql://root:root@localhost:3306/shadow `     
    - `npx prisma migrate diff --from-migrations ./prisma/migrations --to-url mysql://root:root@localhost:3306/api --shadow-database-url mysql://root:root@localhost:3306/shadow` 

## Example

```
PS C:\Users\Jan\Documents\throwaway\wb2-api> npx prisma migrate dev
Environment variables loaded from .env
Prisma schema loaded from prisma\schema.prisma
Datasource "db": MySQL database "api" at "localhost:3306"

Drift detected: Your database schema is not in sync with your migration history.

The following is a summary of the differences between the expected database schema given your migrations files, and the actual schema of the database.

It should be understood as the set of changes to get from the expected schema to the actual schema.

If you are running this the first time on an existing database, please make sure to read this documentation page:
https://www.prisma.io/docs/guides/database/developing-with-prisma-migrate/troubleshooting-development

[+] Added tables
  - _CollectorToSurvey
  - collector
  - organization
  - respondent
  - survey
  - user

[*] Changed the `_CollectorToSurvey` table
  [+] Added foreign key on columns (A)
  [+] Added foreign key on columns (B)

[*] Changed the `collector` table
  [+] Added foreign key on columns (organizationId)

[*] Changed the `respondent` table
  [+] Added foreign key on columns (collectorId)
  [+] Added foreign key on columns (organizationId)
  [+] Added foreign key on columns (parentId)
  [+] Added foreign key on columns (surveyId)
  [+] Added foreign key on columns (userId)

[*] Changed the `survey` table
  [+] Added foreign key on columns (organizationId)

[*] Changed the `user` table
  [+] Added foreign key on columns (organizationId)

√ We need to reset the MySQL database "api" at "localhost:3306"
Do you want to continue? All data will be lost. ... no

Reset cancelled.
PS C:\Users\Jan\Documents\throwaway\wb2-api> npx prisma migrate diff --from-migrations ./prisma/migrations --to-schema-datasource ./prisma/schema.prisma --shadow-database-url mysql://root:root@localhost:3306/shadow
No difference detected.

PS C:\Users\Jan\Documents\throwaway\wb2-api> npx prisma migrate diff --from-migrations ./prisma/migrations --to-schema-datamodel ./prisma/schema.prisma --shadow-database-url mysql://root:root@localhost:3306/shadow      
No difference detected.

PS C:\Users\Jan\Documents\throwaway\wb2-api> npx prisma migrate diff --from-migrations ./prisma/migrations --to-url mysql://root:root@localhost:3306/api --shadow-database-url mysql://root:root@localhost:3306/shadow  
No difference detected.

```

# Jan's theory

`migrate dev` does only apply the migrations that are recorded in `_prisma_migrations`. As the dump does not include that table, it does not apply _any_ migration files so is effectively comparing an empty shadow database to a database with something in it - which matches the output of the drift warning that _all_ the tables need to be created.