SELECT role_type.role, COUNT(person.id) AS count
FROM title
JOIN cast_info ON title.id = cast_info.movie_id
JOIN person ON cast_info.person_id = person.id
JOIN role_type ON cast_info.role_id = role_type.id
WHERE title.title = 'The Matrix'
AND title.kind_id = 1
GROUP BY role_type.role;


-- SELECT person.name, char_name.name AS character_name, role_type.role
-- FROM title
-- JOIN cast_info ON title.id = cast_info.movie_id
-- JOIN person ON cast_info.person_id = person.id
-- LEFT JOIN char_name ON cast_info.person_role_id = char_name.id
-- JOIN role_type ON cast_info.role_id = role_type.id
-- WHERE title.title = 'The Matrix'
-- AND title.kind_id = 1
-- ORDER BY cast_info.nr_order ASC;


-- SELECT person.name, char_name.name AS character_name
-- FROM title
-- JOIN cast_info ON title.id = cast_info.movie_id
-- JOIN person ON cast_info.person_id = person.id
-- JOIN char_name ON cast_info.person_role_id = char_name.id
-- WHERE title.title = 'The Matrix'
-- AND title.kind_id = 1
-- ORDER BY cast_info.nr_order ASC; 

-- SELECT person.name
-- FROM title
-- JOIN cast_info ON title.id = cast_info.movie_id
-- JOIN person ON cast_info.person_id = person.id
-- WHERE title.title = 'The Matrix'
-- AND title.kind_id = 1;

-- SELECT *
-- FROM title
-- WHERE title = 'The Matrix'
-- AND kind_id = 1;