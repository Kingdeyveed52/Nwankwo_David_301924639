// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("account_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("account_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "account_opened",
                    "transfer_initiated"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "transfer"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("account_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "account_opened",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "id": 5
            },
            "snapshot": {
                "id": 5,
                "source_account_id": 3,
                "destination_account_id": 4,
                "amount": 25.5,
                "currency": "USD",
                "status": "completed",
                "idempotency_key": "idem-seed-001",
                "created_at": "2026-02-01T14:00:00Z"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 3
                    },
                    "via": [
                        "transfer.source_account_id → account"
                    ]
                },
                {
                    "key": {
                        "id": 4
                    },
                    "via": [
                        "transfer.destination_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_initiated",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "id": 5
            },
            "snapshot": {
                "id": 5,
                "source_account_id": 3,
                "destination_account_id": 4,
                "amount": 25.5,
                "currency": "USD",
                "status": "completed",
                "idempotency_key": "idem-seed-001",
                "created_at": "2026-02-01T14:00:00Z"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 3
                    },
                    "via": [
                        "transfer.source_account_id → account"
                    ]
                },
                {
                    "key": {
                        "id": 4
                    },
                    "via": [
                        "transfer.destination_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "metadata": "illustrative metadata",
                "risk_signals": "illustrative risk_signals"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "account_opened",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "id": 6
            },
            "snapshot": {
                "id": 6,
                "source_account_id": 4,
                "destination_account_id": 3,
                "amount": 10,
                "currency": "USD",
                "status": "pending",
                "idempotency_key": "idem-seed-002",
                "created_at": "2026-02-02T15:30:00Z"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 4
                    },
                    "via": [
                        "transfer.source_account_id → account"
                    ]
                },
                {
                    "key": {
                        "id": 3
                    },
                    "via": [
                        "transfer.destination_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer_initiated",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "transfer",
            "key": {
                "id": 6
            },
            "snapshot": {
                "id": 6,
                "source_account_id": 4,
                "destination_account_id": 3,
                "amount": 10,
                "currency": "USD",
                "status": "pending",
                "idempotency_key": "idem-seed-002",
                "created_at": "2026-02-02T15:30:00Z"
            }
        },
        "embedded": {},
        "references": {
            "account": [
                {
                    "key": {
                        "id": 4
                    },
                    "via": [
                        "transfer.source_account_id → account"
                    ]
                },
                {
                    "key": {
                        "id": 3
                    },
                    "via": [
                        "transfer.destination_account_id → account"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "metadata": "illustrative metadata",
                "risk_signals": "illustrative risk_signals"
            }
        }
    }
]));
  await db.getCollection("account_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("account_events").find({"eventType":"account_opened"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("account_events").find({"source.key.id":5}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("account_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("account_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("account_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "account_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "id": 5
        },
        "snapshot": {
            "id": 5,
            "source_account_id": 3,
            "destination_account_id": 4,
            "amount": 25.5,
            "currency": "USD",
            "status": "completed",
            "idempotency_key": "idem-seed-001",
            "created_at": "2026-02-01T14:00:00Z"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "id": 3
                },
                "via": [
                    "transfer.source_account_id → account"
                ]
            },
            {
                "key": {
                    "id": 4
                },
                "via": [
                    "transfer.destination_account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("account_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "account_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "transfer",
        "key": {
            "id": 5
        },
        "snapshot": {
            "id": 5,
            "source_account_id": 3,
            "destination_account_id": 4,
            "amount": 25.5,
            "currency": "USD",
            "status": "completed",
            "idempotency_key": "idem-seed-001",
            "created_at": "2026-02-01T14:00:00Z"
        }
    },
    "embedded": {},
    "references": {
        "account": [
            {
                "key": {
                    "id": 3
                },
                "via": [
                    "transfer.source_account_id → account"
                ]
            },
            {
                "key": {
                    "id": 4
                },
                "via": [
                    "transfer.destination_account_id → account"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("account_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
