CREATE KEYSPACE IF NOT EXISTS access
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
AND durable_writes = true;

USE access;

DROP TABLE IF EXISTS access.user_mail;

CREATE TABLE if not exists access.user_mail (
recipient_id int,
recipient_account_type text,
create_time timestamp,
sender_id int,
data text,
size int,
PRIMARY KEY ((recipient_id, recipient_account_type), create_time)
);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (1172, 'gold', '2020-01-01', 5934, 'Rhetoric is the counterpart of Dialectic. Both alike are concerned with such things as come more or less within the general ken of all men and belong to no definite science.', 100);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (1172, 'gold', '2020-07-06', 3921, 'Both alike are concerned with such things as come more or less within the general ken of all men and belong to no definite science.', 150);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (1172, 'gold', '2020-07-05', 5934, 'Ordinary people do this either at random or through practice and from acquired habit.', 150);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (1172, 'gold', '2020-07-09', 5934, 'Both ways being possible, the subject can plainly be handled systematically, for it is possible to inquire the reason why some speakers succeed through practice and others spontaneously; and every one will at once agree that such an inquiry is the function of an art.', 120);


insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (1172, 'gold', '2020-07-19', 5934, 'Now, the framers of the current treatises on rhetoric have constructed but a small portion of that art. The modes of persuasion are the only true constituents of the art: everything else is merely accessory.', 150);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-07-19', 1172, 'These writers, however, say nothing about enthymemes, which are the substance of rhetorical persuasion, but deal mainly with non-essentials.', 10);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-19', 1172, 'The arousing of prejudice, pity, anger, and similar emotions has nothing to do with the essential facts, but is merely a personal appeal to the man who is judging the case.', 3);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-15', 1172, 'Consequently if the rules for trials which are now laid down some states-especially in well-governed states-were applied everywhere, such people would have nothing to say.', 50);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-14', 1172, 'All men, no doubt, think that the laws should prescribe such rules, but some, as in the court of Areopagus, give practical effect to their thoughts and forbid talk about non-essentials.', 50);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-12', 1172, 'Again, a litigant has clearly nothing to do but to show that the alleged fact is so or is not so, that it has or has not happened. ', 50);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-11', 1172, 'As to whether a thing is important or unimportant, just or unjust, the judge must surely refuse to take his instructions from the litigants: he must decide for himself all such points as the law-giver has not already defined for him.', 50);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-10', 1172, 'Now, it is of great moment that well-drawn laws should themselves define all the points they possibly can and leave as few as may be to the decision of the judges; and this for several reasons.', 50);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (5934, 'silver', '2020-06-8', 1172, 'First, to find one man, or a few men, who are sensible persons and capable of legislating and administering justice is easier than to find a large number.', 50);

insert into access.user_mail (recipient_id, recipient_account_type, create_time, sender_id, data, size)
VALUES (3921, 'bronze', '2019-06-8', 1172, 'Next, laws are made after long consideration, whereas decisions in the courts are given at short notice, which makes it hard for those who try the case to satisfy the claims of justice and expediency.', 75);

select * from user_mail limit 5;
select create_time from user_mail where create_time < '2020-01-01';
select count(*) from user_mail where create_time < '2020-01-01';
select recipient_id, create_time from user_mail where recipient_account_type = 'gold';


/*
create custom index account_type_idx on user_mail (recipient_account_type) using 'StorageAttachedIndex';
create custom index create_time_idx on user_mail (create_time) using 'StorageAttachedIndex';
create custom index size_idx on user_mail (size) using 'StorageAttachedIndex';
*/



