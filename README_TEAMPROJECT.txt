Baza operacyjna działa na MySQL2!
Hurtownia danych działa na PostgreSQL!

Ustawienia zakładają istnienie użytkowników odp. root i postgre z hasłem 'pass'.

Kolejność uruchamiania:
- utworzyć ręcznie bazy: teamproject_warehouse, teamproject_test_warehouse, teamproject_development_warehouse,
- uruchomić: rake db:create
- uruchomić: rake db:migrate
- uruchomić: rake db:seed

Przy dokonaniu zmian w bazie:
- rake db:drop nie zmienia struktury baz *_warehouse!
- restartować bazę najlepiej jest przez: rake db:drop:all ; rake db:create:all ; rake db:migrate ; rake db:seed.

Aktualizowanie hurtowni danych:
// najpierw uruchomić rake db:seed
etl ./etl/date_dimension.ctl