# Storage-Attached Index Demo

This is a brief demo to highlight Datastax's new feature, Storage-Attached Indexes, available in DSE and Astra.

## Overview

Datastax Enterprise has as its foundation Apache Cassandra, which provides you the ability to handle vast scales of data. But this speed comes at a tradeoff. Tables are designed based on query patterns, not in a relational way. You need to think about how the data is physically distributed, and to access data you'll need the partition key.

Let's say that we have a user authentication table, where people can log in using their user_id. Nearly all of the time lookups to this table will be against user_id, but occasionally, people will need to be able to access their account using just their email address.

```
create table user (
user_id uuid,
firstname text,
lastname text,
email text,
created date timestamp,
PRIMARY KEY (user_id)
);
```

If you try to query anyway without the partition key, you will see this error.


```
InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING"
```

Technically you could tack on `ALLOW FILTERING` to the end of your statement, but this sends out a scatter-gather request and has the potential for a full table scan. That's bad. This is why we say performance is not predictable, and this should never be used in production.

The best practice for any query you know that you will be accessing frequently is to denormalize the data into a second table and keep that up-to-date with the main table. This lets you get the fastest access pattern for Cassandra. But in this case we know that this kind of query will only happen sporadically, so adding another table and keeping that up-to-date would add too much complexity.

Datastax Enterprise users have the option to enable DSE Search, which provides the full power of an enterprise search tool with capabilities like faceting, ranking, relevancy and more. DSE Search allows you to create search indexes over Cassandra tables, and query based on your own search usage patterns. There are some tradeoffs to adding this functionality: resources have to be shared as Solr runs in the same JVM as Cassandra; mutations have a slight delay as they are first written to Cassandra and then propagated to Solr; and of course there is the architectural complexity of adding a new enterprise system.

For users and enterprises who are looking for a simpler way to query non-partition key elements some of the time, there's now a new option.

## Storage-Attached Indexing

Storage-Attached Indexing is an exciting new feature in DSE 6.8.3 and Astra, that provides native secondary index functionality with conditions and numeric ranges.

There have been previous experimental indexes developed as part of Apache Cassandra, including a native secondary index, and a feature called SSTable-Attached Secondary Index. Storage-attached indexing takes some of the architecture and ideas from both index types, and extends them for more predictable use.

So how does this work? SAI creates indexes on both the memtable and SSTables, and the indexes live right next to the data. When a write comes in, the new data is indexed in the memtable, which gets flushed to an SSTable + index. There are individual index files stored for each column. The files contain a pointer to the offset of the actual data in the SSTable.

Here is the tradeoff: reads will be slower than a read from a core Cassandra table. It is possible that for high cardinality requests or queries of QUORUM or higher consistency levels, a full scan will be needed.

Configuration for SAI lives in cassandra.yaml, along with your other settings.

It's simple to use: just create an index and specify the type.

```
create custom index user_email_idx on user (email) using 'StorageAttachedIndex' with options = {'case_sensitive': false} ;
```

Now, you can query directly by email address, bypassing the primary key constraints.

### Email Service Example
Let's look at another example. Say that you are building an email service that offers different tiers of service and you need a table to store that information. In a relational model we would have separate tables for users, email, and so on.

In Cassandra we could model the data this way, storing all of that information here.

```
CREATE TABLE user_mail (
recipient_id int,
recipient_account_type text,
create_time timestamp,
sender_id int,
data text,
size int,
PRIMARY KEY ((recipient_id, recipient_account_type), create_time)
);
```

You can create this table and load in example data from the file in this repo by running:

```
cqlsh -f data.cql
```

Our primary key is made up of the recipient_id, the recipient_account_type, and the create_time. The partition key – which determines where the data lives physically – is a compound partition key, so we will need both the id and account type to access any information. The create_time is the sort order of the rows within the partition.

SAIs can also be beneficial for data exploration. While you are still getting familiar with the shape of your data, you can create indexes to take a look at the data.

Let's create an index and query for emails before a given date. You'll notice that you're able to select based on a range query across the date field.

```
select * from access.user_mail limit 5;
create custom index create_time_idx on user_mail (create_time) using 'StorageAttachedIndex';
select create_time from user_mail where create_time < '2020-01-01';
```

Next, create an index on `recipient_account_type`, which is part of the partition key. You can now run queries based on this field.
```
create custom index account_type_idx on user_mail (recipient_account_type) using 'StorageAttachedIndex';
select recipient_id, create_time from user_mail where recipient_account_type = 'gold';
```

And another feature is that you can run range queries across numerical fields.

```
create custom index size_idx on user_mail (size) using 'StorageAttachedIndex';
select create_time, size from user_mail where size < 75 and size >= 50;
```

## Next Steps

For more information, please see [this blog post](https://www.datastax.com/blog/2020/09/eliminate-trade-offs-between-database-ease-use-and-massive-scale-sai-storage-attached).
